#!/bin/bash

# Direct test for parse_args in script context
# Run from ruba.sh directory

echo "=== Testing parse_args directly in script ==="
echo ""

# Test 1: Create and run a test script
echo "Test 1: Script with parse_args --help"
cat > test_script.sh << 'SCRIPT_EOF'
#!/bin/bash
# Source ruba.sh from current directory
source ./ruba.sh

short_description="Test script description."
parse_args --name= --age=30 --verbose -- "$@"

echo "Name: $name, Age: $age, Verbose: $verbose"
SCRIPT_EOF

chmod +x test_script.sh
./test_script.sh --help
echo "Exit code: $?"
echo ""

# Test 2: Check what command name is shown
echo "Test 2: Checking command name in usage"
./test_script.sh --help 2>&1 | grep "^Usage:"
echo ""

# Test 3: Test -h short option
echo "Test 3: Testing -h option"
./test_script.sh -h 2>&1 | head -5
echo "Exit code: $?"
echo ""

# Test 4: Normal operation
echo "Test 4: Normal operation"
./test_script.sh --name=John --age=25 --verbose
echo "Exit code: $?"
echo ""

# Test 5: Script without short_description
echo "Test 5: Script without short_description"
cat > test_script2.sh << 'SCRIPT_EOF'
#!/bin/bash
source ./ruba.sh

parse_args --file= --mode= -- "$@"
echo "File: $file, Mode: $mode"
SCRIPT_EOF

chmod +x test_script2.sh
./test_script2.sh --help
echo "Exit code: $?"
echo ""

# Test 6: Compare with function usage
echo "Test 6: Compare function vs script"
cat > test_script3.sh << 'SCRIPT_EOF'
#!/bin/bash
source ./ruba.sh

# Function
myfunc() {
    local short_description="Function description"
    parse_args --param= -- "$@"
    echo "Function param: $param"
}

# Script level
short_description="Script description"
parse_args --script_arg= -- "$@"

if [[ -n "$script_arg" ]]; then
    echo "Script arg: $script_arg"
else
    echo "=== Function help ==="
    myfunc --help
fi
SCRIPT_EOF

chmod +x test_script3.sh
echo "=== Script help ==="
./test_script3.sh --help 2>&1 | head -10
echo ""
echo "=== Function help (via script) ==="
./test_script3.sh --script_arg=dummy 2>&1 | head -10
echo ""

# Test 7: Test 'main' handling
echo "Test 7: Testing if 'main' appears in usage"
# Check if usage shows 'main' or script name
./test_script.sh --help 2>&1 | grep -q "Usage: main" && echo "ERROR: Shows 'main'" || echo "OK: Doesn't show 'main'"
echo ""

# Cleanup
rm -f test_script.sh test_script2.sh test_script3.sh

echo "=== All tests completed ==="
