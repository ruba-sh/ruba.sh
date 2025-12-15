# Rubash - Make Bash more Rubysh

NIL="_𝕟𝕚𝕝_𝕧𝕒𝕝𝕦𝕖_"

is_empty() {
	[[ -z "$1" ]]
}

is_not_empty() {
	[[ -n "$1" ]]
}

does_exist() {
	[[ -e "$1" ]]
}

does_not_exist() {
	is_not_empty "$1" && ! does_exist "$1"
}

is_dir() {
	[[ -d "$1" ]]
}

is_file() {
	[[ -f "$1" ]]
}

is_block_dev() {
	[[ -b "$1" ]]
}

is_not_block_dev() {
	! is_block_dev "$1"
}

is_not_file() {
	! is_file "$1"
}

is_not_ok() {
	[[ $? -ne 0 ]]
}

command_exists() {
	basename "$(command -v "$1" || echo "$2")"
}

is_tar_path() {
	[[ "$1" == *.tar.* ]]
}

is_compressed() {
	[[ "$1" =~ \.(gz|bz2|xz|zst|lzma|zip|7z|rar)$ ]]
}

is_own() {
	[[ "$(stat -c "%u" "$1")" -eq "$(id -u)" ]]
}

dbg() {
	is_empty "${DEBUG_XD:-}" && return 0

	echo "$@" >> "$DEBUG_XD"
}

echo2() {
	echo "$@" >&2
}

error() {
	dbg "$@"
	echo2 "$@"
}

fatal() {
	error "$@"
	exit 1
}

trim_1_extention() {
	echo "${1%.*}"
}

trim_2_extentions() {
	echo "${1%.*.*}"
}

extension() {
	echo "${1##*.}"
}

log() {
	time="$(date +%Y-%m-%d_%H-%M-%S-%3N)"
	echo2 "$time $*"
}

parse_args() {
	# usage example: parse_args --name= --age=30 --title=$NIL --verbose -- "$@"
	local parse_def=true
	local arg_name
	local arg_value
	local arg_default_value

	local -A args
	local -A arg_types  # "flag", "required", "optional", "nil"

	while [[ $# -gt 0 ]]; do
		if $parse_def; then
			if [[ $1 == -- ]]; then
				# end of definitions
				parse_def=false
			elif [[ $1 == --*=* ]]; then
				# argument
				IFS='=' read -r arg_name arg_default_value <<<"${1#--}"
				# log "argument: $arg_name, default: $arg_default_value"
				if [[ $arg_name == "help" ]]; then
					fatal "Cannot define '--help' argument - it is reserved for help display"
				fi
				args["$arg_name"]=$arg_default_value
				if [[ $arg_default_value == "$NIL" ]]; then
					arg_types["$arg_name"]="nil"
				elif [[ -z $arg_default_value ]]; then
					arg_types["$arg_name"]="required"
				else
					arg_types["$arg_name"]="optional"
				fi
			elif [[ $1 == --* ]]; then
				# flag
				arg_name="${1#--}"
				# log "flag: $arg_name"
				if [[ $arg_name == "help" ]]; then
					fatal "Cannot define '--help' flag - it is reserved for help display"
				fi
				args["$arg_name"]=false
				arg_types["$arg_name"]="flag"
			else
				fatal "wrong definition: $1"
			fi
		else
			# parse arguments
			if [[ $1 == --help ]] || [[ $1 == -h ]]; then
				# Show help message
				local cmd_name="${FUNCNAME[1]:-$0}"
				echo "Usage: $cmd_name [options]"
				# Check if short_description variable is defined and non-empty
				if declare -p short_description &>/dev/null 2>&1 && [[ -n "${short_description:-}" ]]; then
					echo "$short_description"
				fi
				echo ""
				echo "Options:"

				# Collect and sort argument names
				local sorted_args=()
				for arg_name in "${!arg_types[@]}"; do
					sorted_args+=("$arg_name")
				done
				# Sort alphabetically
				IFS=$'\n' read -r -d '' -a sorted_args < <(printf '%s\n' "${sorted_args[@]}" | sort && printf '\0')
				unset IFS
				# Find max argument name length for alignment
				local max_len=0
				for arg_name in "${sorted_args[@]}"; do
					local len=${#arg_name}
					if [[ $len -gt $max_len ]]; then
						max_len=$len
					fi
				done

				# Display each argument
				for arg_name in "${sorted_args[@]}"; do
					# Skip 'help' from user-defined arguments since it's always a special option
					if [[ $arg_name == "help" ]]; then
						continue
					fi

					local arg_type="${arg_types[$arg_name]}"
					local default_value="${args[$arg_name]}"
					local padding=$((max_len - ${#arg_name} + 2))

					case "$arg_type" in
						"required")
							printf "  --%s%*sVALUE    (required)\n" "$arg_name" "$padding" ""
							;;
						"optional")
							printf "  --%s%*sVALUE    (optional, default: %s)\n" "$arg_name" "$padding" "" "$default_value"
							;;
						"nil")
							printf "  --%s%*sVALUE    (optional, may be empty)\n" "$arg_name" "$padding" ""
							;;
						"flag")
							printf "  --%s%*s          (flag)\n" "$arg_name" "$padding" ""
							;;
					esac
				done

				echo "  --help, -h           Show this help message"
				exit 0
			fi
			if [[ $1 == --*=* ]]; then
				IFS='=' read -r arg_name arg_value <<<"${1#--}"
				if [[ ${args[$arg_name]} == false ]]; then fatal "$arg_name is a flag"; fi
				args["$arg_name"]="$arg_value"
			elif [[ $1 == --* ]]; then
				arg_name="${1#--}"
				if is_empty "${args["$arg_name"]}"; then fatal "wrong flag given: $arg_name"; fi
				if [[ ${args[$arg_name]} != false ]]; then fatal "$arg_name is not a flag"; fi
				args["$arg_name"]=true
			else
				fatal "wrong argument: $1"
			fi
		fi
		shift
	done

	for arg_name in "${!args[@]}"; do
		arg_value="${args[$arg_name]}"
		if is_empty "$arg_value"; then
			fatal "Argument $arg_name is obligatory"
		else
			eval "$arg_name='${arg_value//$NIL/""}'"
		fi
	done
}
