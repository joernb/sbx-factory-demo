#!/bin/bash

echo "Paste the URL of a GitHub issue (e.g. https://github.com/owner/repo/issues/123)"
read url

re='^https?://(www\.)?github\.com/([^/]+)/([^/]+)/issues/([0-9]+)([/?#].*)?$'
if ! echo "$url" | grep -Eq "$re"; then
  echo "Error: not a valid GitHub issue URL: $url" >&2
  exit 1
fi

owner=$(echo "$url" | sed -E "s|$re|\2|")
repo=$(echo "$url" | sed -E "s|$re|\3|")
issue=$(echo "$url" | sed -E "s|$re|\4|")

echo "Starting sandbox"
sbx -D create shell --kit docker.io/docker/sbx-kit-gh:latest --kit "./$(dirname $0)" --name test-gh-clone --kit-arg owner="$owner" --kit-arg repo="$repo" --kit-arg issue="$issue"

sbx -D run test-gh-clone
