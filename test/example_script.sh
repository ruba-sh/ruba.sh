#!/bin/bash

# Example script using parse_args directly (not in a function)
# This demonstrates how to use parse_args for script argument parsing

source ../ruba.sh/ruba.sh

# Define short_description to be shown in help
short_description="This script processes user data with various options."

# Parse command line arguments
parse_args --name= --age=30 --title=$NIL --verbose -- "$@"

# Now the variables are set: $name, $age, $title, $verbose
# Use them in your script logic

if [[ -n "$name" ]]; then
    echo "Processing data for: $title $name"
    echo "Age: $age"

    if [[ "$verbose" == "true" ]]; then
        echo "Verbose mode enabled"
        echo "Additional debug information..."
    fi

    # Main script logic here
    echo "Data processing completed."
else
    # This shouldn't happen if parse_args worked correctly
    # (name is required argument)
    echo "Error: Name not provided"
    exit 1
fi
