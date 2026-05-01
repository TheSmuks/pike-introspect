#!/bin/bash
# Pike test runner wrapper
# Run from project root: sh tests/pike_tests.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/.."

cd "$PROJECT_DIR"

# Run tests with correct module path
echo "Running Pike introspection tests..."
pike -M src -M "$SCRIPT_DIR/../punit-tests" "$SCRIPT_DIR/run_tests.pike" "$SCRIPT_DIR/pike" "$SCRIPT_DIR/pike_tests.sh"
