#!/bin/bash

# Test script for parse_args function with --help support

# Source the ruba.sh library
source ../ruba.sh/ruba.sh

run_test() {
  echo "Running: $1"
  # Run in a subshell so exit 0 doesn't terminate the entire test script
  (eval "$1")
  echo "Exit code: $?"
  echo "---"
}

echo "=== Test 1: Basic parse_args with --help ==="
test_function1() {
  parse_args --name= --age=30 --title=$NIL --verbose -- "$@"
  echo "Name: $title $name, Age: $age, Verbose: $verbose"
}

echo "Calling test_function1 with --help:"
run_test "test_function1 --help"

echo ""
echo "=== Test 1b: Should exit with code 0 ==="
run_test "test_function1 --help; echo 'This should not be printed'"

echo ""
echo "=== Test 2: parse_args with -h short option ==="
echo "Calling test_function1 with -h:"
run_test "test_function1 -h"

echo ""
echo "=== Test 2b: Should exit with code 0 ==="
run_test "test_function1 -h; echo 'This should not be printed'"

echo ""
echo "=== Test 3: Normal operation without help ==="
echo "Calling test_function1 with --name=Alice --verbose:"
run_test "test_function1 --name=Alice --verbose"

echo ""
echo "=== Test 3b: Missing required argument should fail ==="
run_test "test_function1 --verbose"

echo ""
echo "=== Test 4: Test that --help shows help ==="
test_function2() {
  # Test that --help shows help even with other arguments
  parse_args --name= -- "$@"
  echo "Name: $name"
}

echo "Calling test_function2 with --help (should show help message):"
run_test "test_function2 --help --name=Bob"

echo ""
echo "=== Test 4b: Normal operation without help ==="
run_test "test_function2 --name=Bob"

echo ""
echo "=== Test 4c: Test with short_description ==="
test_function2c() {
  local short_description="This command processes names."
  parse_args --name= -- "$@"
  echo "Name: $name"
}

echo "Calling test_function2c with --help (should show description):"
run_test "test_function2c --help"

echo ""
echo "=== Test 4d: Test with empty short_description ==="
test_function2d() {
  local short_description=""
  parse_args --name= -- "$@"
  echo "Name: $name"
}

echo "Calling test_function2d with --help (should not show empty description):"
run_test "test_function2d --help"

echo ""
echo "=== Test 4e: Test without short_description ==="
test_function2e() {
  # No short_description defined
  parse_args --name= -- "$@"
  echo "Name: $name"
}

echo "Calling test_function2e with --help (should show help without description):"
run_test "test_function2e --help"

echo ""
echo "=== Test 4f: Defining --help should fail ==="
test_function2f() {
  # This should fail because --help is reserved
  parse_args --help=false --name= -- "$@"
  echo "This should not be printed"
}

echo "Calling test_function2f (should fail with error):"
run_test "test_function2f --name=Bob"

echo ""
echo "=== Test 5: Help shows all argument types ==="
test_function3() {
  parse_args --required= --optional=default --nil=$NIL --flag -- "$@"
  echo "Required: $required, Optional: $optional, Nil: $nil, Flag: $flag"
}

echo "Calling test_function3 with --help:"
run_test "test_function3 --help"

echo ""
echo "=== Test 5b: Test with short_description and multiple arguments ==="
test_function3b() {
  local short_description="This command demonstrates all argument types."
  parse_args --required= --optional=default --nil=$NIL --flag -- "$@"
  echo "Required: $required, Optional: $optional, Nil: $nil, Flag: $flag"
}

echo "Calling test_function3b with --help (should show description):"
run_test "test_function3b --help"

echo ""
echo "=== Test 5c: Normal operation with all arguments ==="
run_test "test_function3 --required=req_value --optional=opt_value --nil=nil_value --flag"

echo ""
echo "=== Test 6: Mixed arguments with help in middle ==="
test_function4() {
  parse_args --first= --second= -- "$@"
  echo "First: $first, Second: $second"
}

echo "Calling test_function4 with --first=one --help --second=two (should show help and exit):"
run_test "test_function4 --first=one --help --second=two"

echo ""
echo "=== Test 6b: Test command name in usage ==="
test_function4b() {
  local short_description="Processes two values."
  parse_args --first= --second= -- "$@"
  echo "First: $first, Second: $second"
}

echo "Calling test_function4b with --help (should show function name in usage):"
run_test "test_function4b --help"

echo ""
echo "=== Test 6c: Normal operation without help ==="
run_test "test_function4 --first=one --second=two"

echo ""
echo "=== Test 7: Test from top-level script (not function) ==="
# Test when parse_args is called from top-level (not inside a function)
# This should show script name instead of function name
echo "Creating test script..."
cat > /tmp/test_script.sh << 'EOF'
#!/bin/bash
source ./ruba.sh/ruba.sh
local short_description="Top-level script test."
parse_args --test= -- "$@"
echo "Test: $test"
EOF

chmod +x /tmp/test_script.sh
echo "Running test script with --help:"
(cd ruba.sh && /tmp/test_script.sh --help)
echo "Exit code: $?"
echo "---"

echo ""
echo "=== All tests completed ==="
