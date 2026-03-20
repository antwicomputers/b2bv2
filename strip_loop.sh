#!/bin/bash
while true; do
  xattr -rc build/ios 2>/dev/null || true
  sleep 0.5
done
