# Ruba.sh

Ruba.sh is a lightweight Bash library that brings Ruby-like simplicity and clarity to Bash scripting. It provides utility functions for common tasks like file checks, string manipulation, logging, and argument parsing, making your scripts more readable and maintainable.

## Installation

### System-Wide Installation

To make Ruba.sh available to all users on the system:

1. Clone or download the repository.
2. Copy `ruba.sh` to a directory in the system’s `$PATH`, such as `/usr/local/bin`:
   ```bash
   sudo cp ruba.sh /usr/local/bin/ruba.sh
   ```
3. Ensure `/usr/local/bin` is in your `$PATH` (it usually is by default). You can verify with:
   ```bash
   echo $PATH | grep /usr/local/bin
   ```
4. In your Bash scripts, include the library with:
   ```bash
   source ruba.sh
   ```

### Per-User Installation

To install Ruba.sh for a single user:

1. Clone or download the repository.
2. Copy `ruba.sh` to a user-specific directory in your `$PATH`, such as `~/.local/bin`:
   ```bash
   mkdir -p ~/.local/bin
   cp ruba.sh ~/.local/bin/ruba.sh
   ```
3. Ensure `~/.local/bin` is in your `$PATH`. Add it to `~/.bashrc` or `~/.bash_profile` if needed:
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   ```
4. Reload your shell configuration:
   ```bash
   source ~/.bashrc
   ```
5. In your Bash scripts, include the library with:
   ```bash
   source ruba.sh
   ```

## Usage Examples

Below are simple examples demonstrating each function in `ruba.sh`.

### `is_empty`

```bash
if is_empty ""; then
  echo "Empty"
else
  echo "Not empty"
fi  # Prints: Empty
```

### `is_not_empty`

```bash
if is_not_empty "hello"; then
  echo "Not empty"
else
  echo "Empty"
fi  # Prints: Not empty
```

### `does_exist`

```bash
touch test.txt
if does_exist "test.txt"; then
  echo "Exists"
else
  echo "Does not exist"
fi  # Prints: Exists
```

### `does_not_exist`

```bash
if does_not_exist "nonexistent.txt"; then
  echo "Does not exist"
else
  echo "Exists"
fi  # Prints: Does not exist
```

### `is_dir`

```bash
mkdir mydir
if is_dir "mydir"; then
  echo "Is directory"
else
  echo "Not a directory"
fi  # Prints: Is directory
```

### `is_file`

```bash
touch test.txt
if is_file "test.txt"; then
  echo "Is file"
else
  echo "Not a file"
fi  # Prints: Is file
```

### `is_not_file`

```bash
mkdir mydir
if is_not_file "mydir"; then
  echo "Not a file"
else
  echo "Is file"
fi  # Prints: Not a file
```

### `is_not_ok`

```bash
false
if is_not_ok; then
  echo "Last command failed"
else
  echo "Last command succeeded"
fi  # Prints: Last command failed
```

### `command_exists`

```bash
if command_exists "ls"; then
  echo "Command exists"
else
  echo "Command does not exist"
fi  # Prints: Command exists
```

### `is_tar_path`

```bash
if is_tar_path "archive.tar.gz"; then
  echo "Is tar path"
else
  echo "Not a tar path"
fi  # Prints: Is tar path
```

### `is_compressed`

```bash
if is_compressed "file.zip"; then
  echo "Is compressed"
else
  echo "Not compressed"
fi  # Prints: Is compressed
```

### `is_own`

```bash
touch myfile.txt
if is_own "myfile.txt"; then
  echo "I own this file"
else
  echo "I don't own this file"
fi  # Prints: I own this file
```

### `dbg`

```bash
export DEBUG_XD="debug.log"
dbg "Debug message"
cat debug.log  # Prints: Debug message
```

### `echo2`

```bash
echo2 "Error message"  # Prints: Error message (to stderr)
```

### `error`

```bash
export DEBUG_XD="debug.log"
error "Something went wrong"  # Prints: Something went wrong (to stderr)
cat debug.log  # Prints: Something went wrong
```

### `fatal`

```bash
fatal "Critical error"  # Prints: Critical error (to stderr) and exits
```

### `trim_1_extention`

```bash
trim_1_extention "file.tar.gz"  # Prints: file.tar
```

### `trim_2_extentions`

```bash
trim_2_extentions "file.tar.gz"  # Prints: file
```

### `extension`

```bash
extension "file.tar.gz"  # Prints: gz
```

### `log`

```bash
log "Starting process"  # Prints: 2025-05-17_01-11-23-123 Starting process (to stderr)
```

### `parse_args`


```bash
my_function() {
  local short_description='This command is doing something.'
  parse_args --name= --age=30 --title=$NIL --verbose -- "$@"
  echo "Name: $title $name, Age: $age, Verbose: $verbose"
}
my_function --name=Alice --verbose  # Prints: Name: Alice, Age: 30, Verbose: true
my_function --name=Alice --title=lady  # Prints: Name: lady Alice, Age: 30, Verbose: 
my_function --age=90 --verbose  # fails with message: Argument name is obligatory
my_function --help  # Shows help message and exits
my_function -h      # Shows help message and exits (short form)
```

The `parse_args` function automatically supports `--help` and `-h` options. When provided, it displays a help message showing all defined arguments with their types (required, optional with default value, optional may be empty, or flag) and exits with code 0. The `--help` argument is reserved and cannot be defined as a user argument.

The help message automatically uses the name of the calling function (or script name if called from top-level). If a `short_description` variable is defined in the local scope, its content will be displayed below the usage line.

Example help output:
```
Usage: my_function [options]
This command is doing something.

Options:
  --age      VALUE    (optional, default: 30)
  --name     VALUE    (required)
  --title    VALUE    (optional, may be empty)
  --verbose            (flag)
  --help, -h           Show this help message
```

## Contributing

Contributions are welcome! You can contribute in the following ways:

- **Submit a Merge Request**: Fork the repository, make your changes, and submit a merge request with a clear description of your changes.
- **Request a Feature**: Create an issue labeled "Feature Request" to suggest new functionality or improvements.

Please ensure your code follows the existing style and includes relevant tests or examples.

## License

This project is licensed under the GPL3 License. See the `LICENSE.txt` file for details.
