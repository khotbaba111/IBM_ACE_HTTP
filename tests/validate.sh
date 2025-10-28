#!/bin/bash
set -e

echo "🧪 Starting functional test inside ACE container..."

# Paths
WORK_DIR=/home/aceuser/ace-server
BAR_FILE=/home/aceuser/bar/http_app.bar
INPUT_FILE=/home/aceuser/tests/testdata/input.xml
EXPECTED_FILE=/home/aceuser/tests/testdata/expected_output.json
OUTPUT_FILE=/home/aceuser/tests/testdata/actual_output.json

mkdir -p $(dirname "$OUTPUT_FILE")

# 1️⃣ Deploy BAR
echo "🚀 Deploying BAR file..."
mqsibar -c -a "$BAR_FILE" -w "$WORK_DIR"

# 2️⃣ Start IntegrationServer in background
echo "🔧 Starting IntegrationServer..."
IntegrationServer --work-dir "$WORK_DIR" &
SERVER_PID=$!

# Wait for server to come up
sleep 25

# 3️⃣ Send test message
echo "📨 Sending input message..."
curl -s -X POST -H "Content-Type: application/xml" \
  --data @"$INPUT_FILE" \
  http://localhost:7800/first > "$OUTPUT_FILE" || true

# 4️⃣ Validate output
echo "🔍 Validating response..."
if diff -q "$EXPECTED_FILE" "$OUTPUT_FILE" > /dev/null; then
  echo "✅ Test passed: Output matches expected."
else
  echo "❌ Test failed: Output mismatch!"
  echo "Expected:"
  cat "$EXPECTED_FILE"
  echo ""
  echo "Got:"
  cat "$OUTPUT_FILE"
  kill $SERVER_PID
  exit 1
fi

# 5️⃣ Cleanup
kill $SERVER_PID
echo "🧹 Cleanup done."
