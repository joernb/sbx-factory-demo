#!/bin/bash
set -eu

name="test-claude-config"

echo "Creating sandbox $name"
sbx -D create docker.io/docker/sbx-kit-claude --kit "./$(dirname $0)" --name "$name"

echo "Logging into shell and discarding welcome banner output"
sbx exec "$name" bash -c ":" >/dev/null

echo "Checking CLAUDE_CODE_SYNC_PLUGIN_INSTALL is set"
sbx exec "$name" bash -c "env | grep CLAUDE_CODE_SYNC_PLUGIN_INSTALL"

echo "Asking Claude for plugin installation"
sbx exec "$name" claude -p "Do you have the superpowers plugin installed?" < /dev/null

echo "Removing sandbox $name"
sbx rm -f "$name"
