#!/usr/bin/bash
#
# This assumes that the user executes the script from the script's original file path and not as a symlink.

# Microsoft Visual C/C++ Compiler version number
MSVC_VERSION=412

# Directory from which this project is executed from
CWD="$(dirname "$0")"

# This script's name
SCRIPT="$(basename "$0")"

# Archived SFML module location
SFML_PROJECT="$CWD/templates/SFML.tar.gz"

# Project template location
PROJECT_TEMPLATE="$CWD/templates/project_template"

# Loction in the user's system to deploy the SFML project to
TARGET=""

# The target SFML project's default name
DEFAULT_PROJECT_NAME="NewSfmlProject"

# Makefile template location. Used for Linux systems
MAKEFILE="$CWD/templates/Makefile"

####
# Options that the users can enable
####
# Print out extra information to stdout
VERBOSE=false

# Valid variants of verbose options
VALID_VERBOSE_OPTIONS=( "--verbose" "-v" )

# Whether the script successfully extracted the SFML module
IS_SFML_EXTRACTED=false

####
# Create new project directory
####
function create_project_dir() {
	# If the target directory already exists, then we output error message and
	# exit the script
	if [ -d "$TARGET" ]; then
		echo "Project directory already exists"
		exit 1
	# If no target was specified, then we prompt for one
	elif [ -z "$TARGET" ]; then
		local name=""	# Project name
		local isUnique=false # Whether the project name is unique

		echo -n "Enter project name [$DEFAULT_PROJECT_NAME]: "

		while [ $isUnique == false ]; do
			# Get project name from the user
			# If the user doesn't enter anything, then we use the default project name
			read -p "" name
			if [ -z "$name" ]; then
				name="$DEFAULT_PROJECT_NAME"
			fi

			# We make sure that the project name doesn't already exist
			if [ -d "$name" ]; then
				echo -n "Project name already exists. Please choose another name: "
			else
				isUnique=true
			fi
		done;

		# We update the target name
		TARGET="$name"
	fi

	# Finally, we create the project directory
	mkdir -p "$TARGET" || exit 1
}

####
# Delete the project directory
####
function removeProjectDir() {
	rm -rf "$TARGET"
}

function create_VS_project() {
	# Create project directory
	create_project_dir

	# Attempt to find the SFML project
	if [ -d "$SFML_PROJECT" ]; then echo "Could not find the SFML template project" && exit 1; fi

	echo "Generating new SFML project..."

	# Create directory
	mkdir -p "$TARGET" || { echo "Could not create new project. Missing permission?"; exit 1; }

	# Copy project template to target destination
	cp -r "$PROJECT_TEMPLATE"/* "$TARGET" || 
		{ echo "Could not create project template."; removeProjectDir; exit 1; }

	# Decompress and extract the SFML module
	extract "$TARGET/SfmlProject"

}

####
# Extract the SFML library to a destination
####
function extract() {
	local target=""
	

	if [ -z "$1" ]; then target="."
	else target="$1/SFML"
	fi

	# Make sure no directory is already named SFML
	if [ ! -d "$target" ]; then
		mkdir "$target"

		# Check verbosity
		if [ "$VERBOSE" == true ]; then
			tar -xvf "$SFML_PROJECT" --directory "$target" --strip-components=1 || { echo "Could not extract the SFML module"; return 1; }
		else
			tar -xvf "$SFML_PROJECT" --directory "$target" --strip-components=1 > /dev/null || { echo "Could not extract the SFML module"; return 1; }
		fi
	else
		printf "There's already another directory named \'%s\'\n" "$target"
	fi

	IS_SFML_EXTRACTED=true
}

function linux() {
	local confirmSfml=""

	# Create project directory
	create_project_dir || return "$?"

	# Copy main.cpp to target location
	cp "$CWD/templates/project_template/SfmlProject/main.cpp" "$TARGET"

	# Copy SFML library to target location after asking the user for
	# confirmation
	#read -p "Would you like to include the SFML library? [Y/n] " confirmSfml

	# Makefile is bugged and will also compile SFML example projects from the
	# SFML library

	# If yes, then extract the library to TARGET location. Otherwise
	# delete the newly created project directory
	#if [ "$confirmSfml" == "Y" ] || [ "$confirmSfml" == "y" ] || [ "$confirmSfml" == "" ]; then
	#	extract "$TARGET" || { removeProjectDir; return 1; } 
	#fi

	# Copy Makefile to target location
	cp "$MAKEFILE" "$TARGET/Makefile"

	# Success messages
	printf "\nSuccessfully created a SFML project at \'%s\'!\n" "$TARGET"
	printf "To build the project, \"make\". Execute the program with ./game\n"
}

function usage() {
	printf """%s OPTIONS [FLAGS]

Script to generate new SFML projects on Linux or NT systems.

Options:
	--extract \t\textract the SFML library
	--help | -h \t\tthis page
	--linux	\t\tcreate SFML project for Linux systems
	--visual-studio \tcreate Visual Studio solution with the SFML library
	--version | -v \t\tthis script's version

Flags:
	--verbose \t\tprint verbose data to console. This must be the first
				argument to the script
""" "$(basename "$0")"
}

####
# Handle the user's command-line arguments
#
# After arguments have been passed and evaluated, appropriate functions are
# called
####
function handleCommands() {
	local execute_cmd

	# If no arguments were passed, then run the help page
	if [[ $# -eq 0 ]]; then usage; return 0; fi
	
	# Parse arguments
	for arg in "$@"; do
		case "$1" in
			# Extract the SFML library
			"--extract" ) extract; exit 0;;

			# Help page
			"--help" | "-h" ) usage; return "$?" ;;

			# Install SFML project for Linux
			"--linux" ) linux; return "$?" ;;

			# Quick way to give name to the project
			"--visual-studio" ) create_VS_project; return "$?" ;;

			# Extra information printed to console
			"--verbose" ) VERBOSE=true;;

			# Print this project's version
			"--version" | "-v" ) printf "1.0.0\n"; return 0 ;;

			* ) printf "Invalid argument. Use the \'--help\' option for arguments.\n" ; exit 1 ;;
		esac
		shift
	done
}

# Run the program
handleCommands "$@"