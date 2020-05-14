#!/usr/bin/env python
"""'Installs' apps"""

from os import path
import json
import subprocess

JSON_FILE = path.abspath(path.join(path.dirname(__file__), 'apps.json'))

def main():
    """Basically, open the URLs in apps.json"""
    apps = json.load(open(JSON_FILE))
    for app in apps:
        answer = input(f'Open {app["name"]}? (type "ok") ')
        if answer == "ok":
            subprocess.call(['open', app["url"]])


if __name__ == "__main__":
    main()
