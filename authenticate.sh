#!/bin/bash
set -eu

echo "-----------------------"
echo "Claude Authentication"
echo "-----------------------"

name="access-claude"

echo "Creating sandbox to test Claude access"
sbx create docker.io/docker/sbx-kit-claude:latest --name "$name"
trap "sbx rm $name -f" EXIT # Clean up on exit
sbx exec "$name" bash -c ":" >/dev/null # Workaround to eat initial welcome banner output

echo "Checking Claude login status"
result=$(sbx exec "$name" bash -c "claude auth status | jq '.loggedIn'")

if [ "$result" = "true" ]; then
  echo "Claude is logged in"
else
  echo "Claude is not logged in, logging in"
  sbx exec "$name" bash -c "claude auth login"
fi

if sbx exec "$name" bash -c "claude -p 'ping'" < /dev/null ; then
  echo "Claude ping successful"
else
  echo "Claude ping failed"
fi

echo "-----------------------"
echo "GitHub Authentication"
echo "-----------------------"

name="access-github"

echo "Checking if GitHub token is stored as a host secret"
if [ -z "$(sbx secrets ls -q --service github)" ]; then
  echo "No GitHub secret found. Please create a fine-grained personal access token on GitHub and paste it below:"
  echo "- Go to https://github.com/settings/credentials"
  echo "- Generate a fine-grained personal access token"
  echo "- Restrict access to repositories that should be accessible from sandboxes"
  echo "- Add read/write permissions for: Contents, Pull Requests, Issues"
  echo "- Generate the token and copy/paste it below"
  sbx secrets set github
  echo "GitHub secret stored on host"
else
  echo "GitHub secret found"
fi

echo "Enter the base url of a GitHub repo that should be accessible with the token:"
read gh_repo

if [ -z "$gh_repo" ]; then
  exit 1
fi

echo "Creating sandbox to test GitHub access"
sbx create shell --name "$name" --kit docker.io/docker/sbx-kit-gh:latest
trap "sbx rm $name -f" EXIT # Clean up on exit
sbx exec "$name" bash -c ":" >/dev/null # Workaround to eat initial welcome banner output

if sbx exec "$name" bash -c "gh auth status" 2>&1; then
  echo "gh is authenticated."
else
  echo "Error: gh is not authenticated."
  exit 1
fi

if sbx exec "$name" bash -c "gh repo view $gh_repo" 2>&1; then
  echo "gh repo access works"
else
  echo "Error: gh repo access does not work"
  exit 1
fi

echo "-----------------------------"
echo "Authentication Setup Complete"
echo "-----------------------------"
