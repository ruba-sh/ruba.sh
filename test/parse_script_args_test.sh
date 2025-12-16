#!/bin/bash

# Test script for parse_args function when used directly in scripts (not in functions)

echo "=== Testing parse_args in script context ==="
echo ""

# Test 1: Basic script with parse_args
echo "=== Test 1: Basic script with parse_args ==="
cat > /tmp/test_script1.sh << 'EOF'
#!/bin/bash
source ./ruba.sh/ruba.sh

short_description="Process user data with options."
parse_args --name= --age=30 --verbose -- "$@"

echo "Name: $name, Age: $age, Verbose: $verbose"
EOF

chmod +x /tmp/test_script1.sh
(cd . && /tmp/test_script1.sh --help 2>&1 | head -15)
echo "Exit code: $?"
echo ""

# Test 2: Script without short_description
echo "=== Test 2: Script without short_description ==="
cat > /tmp/test_script2.sh << 'EOF'
#!/bin/bash
source ./ruba.sh/ruba.sh

parse_args --input= --output= -- "$@"
echo "Input: $input, Output: $output"
EOF

chmod +x /tmp/test_script2.sh
(cd . && /tmp/test_script2.sh --help 2>&1 | head -10)
echo "Exit code: $?"
echo ""

# Test 3: Script with empty short_description
echo "=== Test 3: Script with empty short_description ==="
cat > /tmp/test_script3.sh << 'EOF'
#!/bin/bash
source ./ruba.sh/ruba.sh

short_description=""
parse_args --file= -- "$@"
echo "File: $file"
EOF

chmod +x /tmp/test_script3.sh
(cd . && /tmp/test_script3.sh --help 2>&1 | head -10)
echo "Exit code: $?"
echo ""

# Test 4: Normal operation of script
echo "=== Test 4: Normal script operation ==="
(cd . && /tmp/test_script1.sh --name=John --age=25 --verbose)
echo "Exit code: $?"
echo ""

# Test 5: Script with missing required argument
echo "=== Test 5: Script with missing required argument ==="
(cd . && /tmp/test_script1.sh --age=25 --verbose 2>&1)
echo "Exit code: $?"
echo ""

# Test 6: Script name in usage should be script path/name
echo "=== Test 6: Checking script name in usage ==="
cat > /tmp/test_script6.sh << 'EOF'
#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/ruba.sh/ruba.sh"

short_description="Test script with relative path."
parse_args --test= -- "$@"
echo "Test: $test"
EOF

chmod +x /tmp/test_script6.sh
(cd /tmp && ./test_script6.sh --help 2>&1 | head -5)
echo "Exit code: $?"
echo ""

# Test 7: Compare function vs script usage
echo "=== Test 7: Function vs Script usage comparison ==="
cat > /tmp/test_script7.sh << 'EOF'
#!/bin/bash
source ./ruba.sh/ruba.sh

# Function usage
my_function() {
    local short_description="This is a function."
    parse_args --param= -- "$@"
    echo "Function param: $param"
}

# Script usage
short_description="This is a script."
parse_args --script_param= -- "$@"

if [[ -n "$script_param" ]]; then
    echo "Script param: $script_param"
elif [[ "$1" == "--help" ]]; then
    # Help already shown by parse_args
    exit 0
else
    echo "Testing function help..."
    my_function --help 2>&1 | head -10
fi
EOF

chmod +x /tmp/test_script7.sh
echo "=== Script help ==="
(cd . && /tmp/test_script7.sh --help 2>&1 | head -10)
echo "=== Function help ==="
(cd . && /tmp/test_script7.sh --script_param=dummy 2>&1 | head -10)
echo ""

# Test 8: Script with complex arguments
echo "=== Test 8: Script with all argument types ==="
cat > /tmp/test_script8.sh << 'EOF'
#!/bin/bash
source ./ruba.sh/ruba.sh

short_description="Demonstrates all argument types in script context."
parse_args --required= --optional=default --nil=$NIL --flag -- "$@"

echo "Required: $required"
echo "Optional: $optional"
echo "Nil: $nil"
echo "Flag: $flag"
EOF

chmod +x /tmp/test_script8.sh
(cd . && /tmp/test_script8.sh --help 2>&1 | head -20)
echo "Exit code: $?"
echo ""

# Test 9: Script called with -h (short form)
echo "=== Test 9: Script with -h (short form) ==="
(cd . && /tmp/test_script1.sh -h 2>&1 | head -10)
echo "Exit code: $?"
echo ""

# Test 10: Nested script execution
echo "=== Test 10: Nested script execution ==="
cat > /tmp/test_wrapper.sh << 'EOF'
#!/bin/bash
echo "Wrapper calling test script..."
./test_script1.sh --help 2>&1 | head -5
EOF

chmod +x /tmp/test_wrapper.sh
cp /tmp/test_script1.sh /tmp/test_script1_copy.sh
chmod +x /tmp/test_script1_copy.sh
cd /tmp && ./test_wrapper.sh 2>&1
echo "Exit code: $?"

echo ""
echo "=== All script context tests completed ==="
