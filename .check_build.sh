#!/bin/bash

BUILD_DIR="docker"
HASH_FILE=".last_build"
CURRENT_HASH=$(find "$BUILD_DIR" -type f -exec sha256sum {} \; | sha256sum | awk '{ print $1 }')

BELUGA_BUILT=0

echo "<< Checking docker build"
if [[ -f "$HASH_FILE" ]]; then
  LAST_HASH=$(cat "$HASH_FILE")
  if [[ "$CURRENT_HASH" != "$LAST_HASH" ]]; then
    echo ">> Changes detected in build context."
    echo "$CURRENT_HASH" > "$HASH_FILE"
  else
    echo ">> No changes detected in build context. Starting docker container..."
    BELUGA_BUILT=1
  fi
else
  echo ">> No previous hash found."
  echo "$CURRENT_HASH" > "$HASH_FILE"
fi