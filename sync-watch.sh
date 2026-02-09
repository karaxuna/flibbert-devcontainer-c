#!/usr/bin/env bash
set -e

# Top level domain
FLIBBERT_TLD="${FLIBBERT_TLD:-flibbert.com}"

# Load environment variables from .env
env_file=".env"
if [ -f "$env_file" ]; then
  source "$env_file"
else
  echo "🚨  .env file not found."
  exit 1
fi

# Ensure required variables are set
if [ -z "$FLIBBERT_DEVICE_ID" ] || [ -z "$FLIBBERT_TOKEN" ]; then
  echo "🚨  FLIBBERT_DEVICE_ID and FLIBBERT_TOKEN must be set in the .env file."
  exit 1
fi

# Directory to watch for changes
WATCH_DIR="$PWD/src"

echo "🔍  Watching $WATCH_DIR …"
while inotifywait -q -r -e modify,create,delete "$WATCH_DIR"; do
  if clang -O3 -nostdlib --target=wasm32-wasi --sysroot="${WASI_SDK_PATH}/share/wasi-sysroot" -o output.wasm src/*.c -Wl,--export=__heap_base -Wl,--export=__data_end -Wl,--export=main -Wl,--no-gc-sections -Wl,--no-entry -Wl,--allow-undefined -Wl,--strip-all -Wl,--max-memory=65536 -Wl,--global-base=1024 -Wl,-z,stack-size=16384; then
    echo "✅  Compilation successful."
  else
    echo "❌  Compilation failed, skipping upload."
    continue
  fi

  if curl --fail-with-body -X POST -H "Authorization: Bearer $FLIBBERT_TOKEN" \
    -F "file=@output.wasm" \
    "https://api.$FLIBBERT_TLD/devices/$FLIBBERT_DEVICE_ID/localpush"; then
    echo "✅  Wasm file pushed to the device successfully."
  else
    echo "\n"
    echo "❌  Failed to push Wasm file to the device."
    continue
  fi
done