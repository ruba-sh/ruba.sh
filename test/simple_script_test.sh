#!/bin/bash

# Simple test for parse_args in script context
# Run this from the ruba.sh directory

echo "=== Simple script context test ==="
echo ""

# Create a simple test script
cat > /tmp/simple_test.sh << 'EOF'
#!/bin/bash
# Source ruba.sh from parent directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/ruba.sh/ruba.sh"

short_description="A simple script that demonstrates parse_args."
parse_args --name= --age=30 --verbose -- "$@"

echo "Hello $name! You are $age years old."
if [[ "$verbose" == "true" ]]; then
    echo "(Verbose mode enabled)"
fi
EOF

chmod +x /tmp/simple_test.sh

echo "1. Testing --help output:"
echo "-------------------------"
/tmp/simple_test.sh --help
echo "Exit code: $?"
echo ""

echo "2. Testing -h (short form):"
echo "---------------------------"
/tmp/simple_test.sh -h
echo "Exit code: $?"
echo ""

echo "3. Testing normal operation:"
echo "---------------------------"
/tmp/simple_test.sh --name=Alice --age=25 --verbose
echo "Exit code: $?"
echo ""

echo "4. Testing missing required argument:"
echo "-------------------------------------"
/tmp/simple_test.sh --age=25 --verbose
echo "Exit code: $?"
echo ""

echo "5. Testing script name in usage (should show script name, not 'main'):"
echo "----------------------------------------------------------------------"
# Check what's shown in usage line
/tmp/simple_test.sh --help 2>&1 | grep "^Usage:"
echo ""

echo "6. Testing without short_description:"
echo "-------------------------------------"
cat > /tmp/no_desc.sh << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/ruba.sh/ruba.sh"

parse_args --file= -- "$@"
echo "File: $file"
EOF

chmod +x /tmp/no_desc.sh
/tmp/no_desc.sh --help
echo "Exit code: $?"
echo ""

echo "=== Test completed ==="
