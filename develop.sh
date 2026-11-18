#!/bin/bash
set -eu

url="$1"

if [ -z "$url" ]; then
  echo "First param should be the URL of a GitHub issue (e.g. https://github.com/owner/repo/issues/123)"
  exit 1
fi

re='^https?://(www\.)?github\.com/([^/]+)/([^/]+)/issues/([0-9]+)([/?#].*)?$'
if ! echo "$url" | grep -Eq "$re"; then
  echo "Error: not a valid GitHub issue URL: $url" >&2
  exit 1
fi

owner=$(echo "$url" | sed -E "s|$re|\2|")
repo=$(echo "$url" | sed -E "s|$re|\3|")
issue=$(echo "$url" | sed -E "s|$re|\4|")

sbx env run "envs/claude-develop" -f --env-arg owner="$owner" --env-arg repo="$repo" --env-arg issue="$issue"
