#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# <xbar.title>Github review requests</xbar.title>
# <xbar.desc>Shows a list of PRs that need to be reviewed</xbar.desc>
# <xbar.version>v0.1</xbar.version>
# <xbar.author>Adam Bogdał</xbar.author>
# <xbar.author.github>bogdal</xbar.author.github>
# <xbar.image>https://github-bogdal.s3.amazonaws.com/bitbar-plugins/review-requests.png</xbar.image>
# <xbar.dependencies>python</xbar.dependencies>

import configparser
import datetime
import json
import os
import pathlib
import sys
from urllib.request import Request, urlopen

# --------------------------------------------------------------------------------

config = configparser.ConfigParser()
config_path = pathlib.Path.home() / ".xbar_variables"
config.read(config_path)
config_section = config["github"] if "github" in config else None
if not config_section:
    raise Exception(f"Could not find XBar config file {config_path}")
# https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/
ACCESS_TOKEN = config_section["ACCESS_TOKEN"]
if not ACCESS_TOKEN:
    raise Exception(f"API Token missing")

# --------------------------------------------------------------------------------

GITHUB_LOGIN = config_section["LOGIN_NAME"]

# (optional) PRs with this label (e.g 'in progress') will be grayed out on the list
WIP_LABEL = "wip"

# (optional) Filter the PRs by an organization, labels, etc. E.g 'org:YourOrg -label:dropped'
FILTERS = ""

# --------------------------------------------------------------------------------

DARK_MODE = os.environ.get("BitBarDarkMode")

query = """{
  search(query: "%(search_query)s", type: ISSUE, first: 100) {
    issueCount
    edges {
      node {
        ... on PullRequest {
          repository {
            nameWithOwner
          }
          author {
            login
          }
          createdAt
          number
          url
          title
          labels(first:100) {
            nodes {
              name
            }
          }
        }
      }
    }
  }
}"""

colors = {
    "inactive": "#b4b4b4",
    "title": "#ffffff" if DARK_MODE else "#000000",
    "subtitle": "#586069",
}


def execute_query(query):
    headers = {
        "Authorization": "bearer " + ACCESS_TOKEN,
        "Content-Type": "application/json",
    }
    data = json.dumps({"query": query}).encode("utf-8")
    req = Request("https://api.github.com/graphql", data=data, headers=headers)
    body = urlopen(req).read()
    return json.loads(body)


def search_pull_requests(login, filters=""):
    search_query = "type:pr state:open review-requested:%(login)s %(filters)s" % {
        "login": login,
        "filters": filters,
    }
    response = execute_query(query % {"search_query": search_query})
    return response["data"]["search"]


def parse_date(text):
    date_obj = datetime.datetime.strptime(text, "%Y-%m-%dT%H:%M:%SZ")
    return date_obj.strftime("%B %d, %Y")


def print_line(text, **kwargs):
    params = " ".join(["%s=%s" % (key, value) for key, value in kwargs.items()])
    print("%s | %s" % (text, params) if kwargs.items() else text)


if __name__ == "__main__":
    if not all([ACCESS_TOKEN, GITHUB_LOGIN]):
        print_line("⚠ Github review requests", color="red")
        print_line("---")
        print_line("ACCESS_TOKEN and GITHUB_LOGIN cannot be empty")
        sys.exit(0)

    response = search_pull_requests(GITHUB_LOGIN, FILTERS)

    print_line(f"{str(response['issueCount']).rjust(2)} PRs")
    print_line("---")

    for pr in [r["node"] for r in response["edges"]]:
        labels = [label["name"] for label in pr["labels"]["nodes"]]
        title = "%s - %s" % (pr["repository"]["nameWithOwner"], pr["title"])
        title_color = colors.get("inactive" if WIP_LABEL in labels else "title")
        subtitle = "#%s opened on %s by @%s" % (
            pr["number"],
            parse_date(pr["createdAt"]),
            pr["author"]["login"],
        )
        subtitle_color = colors.get("inactive" if WIP_LABEL in labels else "subtitle")

        print_line(title, size=16, color=title_color, href=pr["url"])
        print_line(subtitle, size=12, color=subtitle_color)
        print_line("---")
