#!/usr/bin/env bash
# Claude Peers Auto-Registration
# Starts the broker if not running and registers this session

BROKER_URL="http://localhost:7899"

# Check if broker is running
if curl -s --connect-timeout 2 "$BROKER_URL/health" &>/dev/null; then
  echo "Claude Peers broker is running."
else
  echo "Claude Peers broker not detected at $BROKER_URL."
  echo "Start it manually: cd ~/claude-peers-mcp && bun run server.ts"
fi
