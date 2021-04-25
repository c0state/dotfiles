#!/usr/bin/env python3

# -*- coding: utf-8 -*-

# <xbar.title>Datadog Monitors Check</xbar.title>
# <xbar.version>v0.1</xbar.version>
# <xbar.author>c0state</xbar.author>
# <xbar.author.github>c0state</xbar.author.github>
# <xbar.desc>This plugin displays the status of Datadog monitors.</xbar.desc>
# <xbar.dependencies>python</xbar.dependencies>

import configparser
from json import JSONDecoder
import pathlib
import urllib.request

# --------------------------------------------------------------------------------

SERVICE_NAME = "datadog"

# --------------------------------------------------------------------------------

config = configparser.ConfigParser()
config_path = pathlib.Path.home() / ".xbar_variables"
config.read(config_path)
config_section = config[SERVICE_NAME] if SERVICE_NAME in config else None
if not config_section:
    raise Exception(f"Could not find config for {SERVICE_NAME}")

# --------------------------------------------------------------------------------

HEADERS = {
    'Content-Type': 'application/json',
    'DD-API-KEY': config_section["DD_API_KEY"],
    'DD-APPLICATION-KEY': config_section["DD_APP_KEY"],
}
GROUP_STATES = "group_states=alert,warn"
FAIL_STATES = ['Alert', 'Warn', 'Unknown']
FAIL_COLOR = "color=red"
OK_COLOR = "color=green"
FONT = "font='Menlo'"

# --------------------------------------------------------------------------------

request = urllib.request.Request(
    url=f"https://api.datadoghq.com/api/v1/monitor/?{GROUP_STATES}",
    headers=HEADERS,
)
response = urllib.request.urlopen(request).read().decode('utf-8')
decoded_response = JSONDecoder().decode(str(response))

failed_monitors = [monitor for monitor in decoded_response if monitor['overall_state'] in FAIL_STATES]
status_color = FAIL_COLOR if failed_monitors else OK_COLOR

print("Datadog", FONT, status_color, sep="|")
print("---")
for monitor in failed_monitors:
    print(monitor['name'], FONT, FAIL_COLOR, sep="|")

print("---")
print("Refresh... | refresh=true")
