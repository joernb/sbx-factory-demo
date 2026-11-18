#!/bin/bash
set -eu

url="$1"

if [ -z "$url" ]; then
  echo "First param should be the URL of a GitHub pull request (e.g. https://github.com/owner/repo/pull/42)"
  exit 1
fi

re='^https?://(www\.)?github\.com/([^/]+)/([^/]+)/pull/([0-9]+)([/?#].*)?$'
if ! echo "$url" | grep -Eq "$re"; then
  echo "Error: not a valid GitHub pull request URL: $url" >&2
  exit 1
fi

owner=$(echo "$url" | sed -E "s|$re|\2|")
repo=$(echo "$url" | sed -E "s|$re|\3|")
pull_request=$(echo "$url" | sed -E "s|$re|\4|")

sbx env run "envs/claude-review" -f --env-arg owner="$owner" --env-arg repo="$repo" --env-arg pull_request="$pull_request"
