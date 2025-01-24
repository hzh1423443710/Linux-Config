#!/usr/bin/env python3
import os
import sys

PROXY_HOST = "127.0.0.1"
PROXY_PORT = "7890"
PROXY_URL = f"http://{PROXY_HOST}:{PROXY_PORT}"

def toggle_proxy():
    # Check if proxy is enabled
    if not os.environ.get('https_proxy'):
        # Print shell commands for eval
        print(f'export http_proxy="{PROXY_URL}"')
        print(f'export https_proxy="{PROXY_URL}"')
        # Print status to stderr (not evaluated)
        print(f"Proxy enabled: {PROXY_URL}", file=sys.stderr)
    else:
        print('unset http_proxy')
        print('unset https_proxy')
        print("Proxy disabled", file=sys.stderr)

if __name__ == '__main__':
    toggle_proxy()

# Create alias in ~/.bashrc
# alias proxy='eval "$(python3 ~/.script/toggle_proxy.py)"'