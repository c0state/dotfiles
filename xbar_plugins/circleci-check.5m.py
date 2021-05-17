#!/usr/bin/env python3

# -*- coding: utf-8 -*-

# <xbar.title>CircleCI Status Check</xbar.title>
# <xbar.version>v0.1</xbar.version>
# <xbar.author>c0state</xbar.author>
# <xbar.author.github>c0state</xbar.author.github>
# <xbar.desc>This plugin displays the build status of repositories listed on CircleCI.</xbar.desc>
# <xbar.dependencies>python</xbar.dependencies>

import configparser
import datetime
import json
import pathlib
import re
from urllib.parse import unquote
import urllib.request

# --------------------------------------------------------------------------------

config = configparser.ConfigParser()
config_path = pathlib.Path.home() / ".xbar_variables"
config.read(config_path)
config_section = config["circleci"] if "circleci" in config else None
if not config_section:
    raise Exception(f"Could not find XBar config file {config_path}")
API_TOKEN = config_section["API_KEY"]
if not API_TOKEN:
    raise Exception(f"API Token missing")

# --------------------------------------------------------------------------------

CIRCLECI_API_ENDPOINT = 'https://circleci.com/api/v1/'
PROJECT_USERNAMES = ["quantumsi"]
MAIN_BRANCH_NAMES = ["main", "master"]
REPO_BRANCH_PREFIXES = MAIN_BRANCH_NAMES + ["staging", "prod", "sliu"]
LINE_SEPARATOR = "---"
MAX_BUILD_AGE_DAYS = 30

# --------------------------------------------------------------------------------

SYMBOLS = {
    'running': ' ▶',
    'success': ' ✓',
    'failed': ' ✗',
    'timedout': ' ⚠',
    'canceled': ' ⊝',
    'scheduled': ' ⋯',
    'no_tests': ' ',
}

COLORS = {
    'running': "#61D3E5",
    'success': "#39C988",
    'failed': "#EF5B58",
    'timedout': "#F3BA61",
    'canceled': "#898989",
    'scheduled': "#AC7DD3",
    'no_tests': "black",
}

NO_SYMBOL = ' ❂'


def request(resource):
    url = f"{CIRCLECI_API_ENDPOINT}{resource}?circle-token={API_TOKEN}"
    headers = {'Accept': 'application/json'}
    req = urllib.request.Request(url, headers=headers)
    response = urllib.request.urlopen(req).read().decode("UTF-8")
    return json.loads(response)


def get_resource(resource_name):
    return request(resource_name)


def output_branch_status(user_name, repo_name, status, branch_name, output):
    color = f"color={COLORS[status]}" if COLORS[status] else ""
    symbol = SYMBOLS.get(status, NO_SYMBOL)
    branch_href = f"href=https://circleci.com/gh/{user_name}/{repo_name}/tree/{branch_name}"
    output_msg = f"- {symbol} {unquote(branch_name)}"
    output.append(f"{output_msg} | {branch_href} {color}")


def update_statuses(projects):
    xbar_output_string_list = [LINE_SEPARATOR]
    status_bar_output = f"CircleCI passed | color=green"

    for project in projects:
        if project['username'].lower() not in PROJECT_USERNAMES:
            continue

        user_name = project['username']
        repo_name = project['reponame']
        repo_href = project['vcs_url']
        branches = project['branches']
        xbar_output_string_list.append(f"{user_name}/{repo_name} | href={repo_href}")

        for branch_name, branch_info in branches.items():
            if not branch_info['recent_builds']:
                continue

            if datetime.datetime.strptime(branch_info['recent_builds'][0]['added_at'], "%Y-%m-%dT%H:%M:%S.%fZ").replace(tzinfo=None) \
                    < (datetime.datetime.utcnow().replace(tzinfo=None) - datetime.timedelta(days=MAX_BUILD_AGE_DAYS)):
                continue

            match_results = [
                True if re.match(f"{branch_prefix}.*", branch_name) else False
                for branch_prefix in REPO_BRANCH_PREFIXES]
            if not any(match_results):
                continue

            if recent_builds := branch_info.get("recent_builds"):
                recent_build = recent_builds[0]
                status = recent_build['outcome']
                if status not in ['no_tests']:
                    output_branch_status(user_name, repo_name, status, branch_name, xbar_output_string_list)

                if status == "failed" and branch_name in MAIN_BRANCH_NAMES:
                    status_bar_output = f"{repo_name} | color=red"

        xbar_output_string_list.append(LINE_SEPARATOR)

    # put first failed main branch in status bar
    xbar_output_string_list = [status_bar_output] + xbar_output_string_list
    for line in xbar_output_string_list:
        print(line)


if __name__ == '__main__':
    update_statuses(get_resource("projects"))
