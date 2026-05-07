// session-pin: pin a Copilot CLI session ID to the current working directory.
//
// On every session start (startup / resume / new / post-/clear), this
// extension looks for a file named .agent_session_copilot in the cwd:
//
//   - If the file does NOT exist, the active session ID is written to it,
//     creating the pin so future invocations can pick up where this one left
//     off.
//
//   - If the file exists and matches the active session, no-op (the
//     companion shell wrapper resumed the pinned session correctly).
//
//   - If the file exists but differs from the active session, the pin is
//     overwritten with the active session ID. This handles /clear (which
//     creates a new in-process session) and also covers the case where the
//     shell wrapper isn't in effect -- a warning is logged in either case.
//
// The actual --resume must be applied by a wrapper around `copilot` itself,
// because onSessionStart fires AFTER the session has already been attached;
// hooks can only inject context, not redirect to a different session id.
// See ~/.dotfiles/agents/copilot/copilot.fish for the matching wrapper.

import { joinSession } from "@github/copilot-sdk/extension";
import { promises as fs } from "node:fs";
import path from "node:path";

const PIN_FILENAME = ".agent_session_copilot";

let session;

async function readPin(cwd) {
    const pinPath = path.join(cwd, PIN_FILENAME);
    try {
        const raw = await fs.readFile(pinPath, "utf8");
        return { pinPath, sessionId: raw.trim() || null };
    } catch (err) {
        if (err.code === "ENOENT") return { pinPath, sessionId: null };
        throw err;
    }
}

async function writePin(pinPath, sessionId) {
    await fs.writeFile(pinPath, `${sessionId}\n`, { mode: 0o644 });
}

session = await joinSession({
    hooks: {
        onSessionStart: async (input, invocation) => {
            const cwd = input?.cwd ?? process.cwd();
            const sessionId = invocation?.sessionId;
            if (!sessionId) {
                await session.log(
                    "session-pin: no sessionId on invocation; skipping",
                    { level: "warning", ephemeral: true },
                );
                return;
            }

            let pin;
            try {
                pin = await readPin(cwd);
            } catch (err) {
                await session.log(
                    `session-pin: failed to read ${PIN_FILENAME}: ${err.message}`,
                    { level: "warning" },
                );
                return;
            }

            if (pin.sessionId === null) {
                try {
                    await writePin(pin.pinPath, sessionId);
                    await session.log(
                        `session-pin: wrote ${PIN_FILENAME} (session ${sessionId.slice(0, 8)}…) in ${cwd}`,
                        { ephemeral: true },
                    );
                } catch (err) {
                    await session.log(
                        `session-pin: failed to write ${PIN_FILENAME}: ${err.message}`,
                        { level: "warning" },
                    );
                }
                return;
            }

            if (pin.sessionId === sessionId) {
                await session.log(
                    `session-pin: resumed pinned session ${sessionId.slice(0, 8)}…`,
                    { ephemeral: true },
                );
                return;
            }

            try {
                await writePin(pin.pinPath, sessionId);
                await session.log(
                    `session-pin: overwrote ${PIN_FILENAME} ` +
                        `(was ${pin.sessionId.slice(0, 8)}…, now ${sessionId.slice(0, 8)}…) ` +
                        `-- /clear or shell wrapper not in effect`,
                    { level: "warning" },
                );
            } catch (err) {
                await session.log(
                    `session-pin: failed to overwrite ${PIN_FILENAME}: ${err.message}`,
                    { level: "warning" },
                );
            }
        },
    },
});
