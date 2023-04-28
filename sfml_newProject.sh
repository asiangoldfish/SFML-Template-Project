#!/usr/bin/bash
#
# Generate new SFML project template for Visual Studio 2017

# This assumes that the user executes the script from the script's original file path and not as a symlink.
CWD="$(dirname "$0")"
SFML_PROJECT="$CWD/templates/SFML.tar.gz"
PROJECT_TEMPLATE="$CWD/templates/project_template"
TARGET=""
DEFAULT_PROJECT_NAME="NewSfmlProject"
MAKEFILE="$CWD/templates/Makefile"

# Opttions
VERBOSE=false
VALID_VERBOSE_OPTIONS=( "--verbose" "-v" ) # Valid variants of verbose options

# Whether the script successfully extracted the SFML module
IS_SFML_EXTRACTED=true

####
# Create new project directory
####
function createProjectDir() {
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

function main() {
	# Create project directory
	createProjectDir

	# Attempt to find the SFML project
	if [ -d "$SFML_PROJECT" ]; then
		echo "Could not find the SFML template project"
		exit 1
	fi

	echo "Generating new SFML project..."

	# Create directory
	mkdir -p "$TARGET" || { echo "Could not create new project. Missing permission?"; exit 1; }

	# Copy project template to target destination
	cp -r "$PROJECT_TEMPLATE"/* "$TARGET" || 
		{ echo "Could not create project template."; removeProjectDir; exit 1; }

	# Decompress and extract the SFML module
	# Check if verbose is enabled

	if [ "$VERBOSE" == true ]; then
		tar -xvf "$SFML_PROJECT" -C "$TARGET/SfmlProject" || { echo "Could not extract the SFML module"; IS_SFML_EXTRACTED=false; }
	else
		tar -xvf "$SFML_PROJECT" -C "$TARGET/SfmlProject" > /dev/null || { echo "Could not extract the SFML module"; IS_SFML_EXTRACTED=false; }
	fi

}

####
# Extract the SFML library to a destination
####
function extract() {
	local target
	target="SFML"

	# Make sure no directory is already named SFML
	if [ ! -d "$target" ]; then
		# Extract the library to the target location
		mkdir "$target"

		# Check verbosity
		if [ "$VERBOSE" == true ]; then
			tar -xvf "$SFML_PROJECT" || { echo "Could not extract the SFML module"; IS_SFML_EXTACRED=false; }
		else
			tar -xvf "$SFML_PROJECT" > /dev/null || { echo "Could not extract the SFML module"; IS_SFML_EXTACRED=false; }
		fi
	else
		printf "There's already another directory named \'%s\'\n" "$target"
	fi
}

function linux() {
	# Create project directory
	createProjectDir

	# Copy main.cpp to target location
	cp "$CWD/templates/project_template/SfmlProject/main.cpp" "$TARGET"

	# Copy SFML library to target location
	#cd "$TARGET" 
	#extract

	# Copy Makefile to target location
	cp "$MAKEFILE" "$TARGET/Makefile"

	printf "To build the project, just type \"make\"\n. Execute the program with ./game\n"
}

function checkVerbosity() {
	# Check if the verbose option was passed
	if [[ " ${VALID_VERBOSE_OPTIONS[*]} " == *" $1 "* ]]; then
    	# whatever you want to do when array contains value
		VERBOSE=true
	fi
}

function usage() {
	printf """%s OPTION [--verbose]

Script to generate new SFML projects on Linux or NT systems.

Options:
	--extract		extract the SFML library to $PWD
	--help | -h		this page
	--name
""" "$(basename "$0")"
}

# If nothing was passed, then simply execute main
if [ -z "$1" ]; then
	# printf "String is empty\n"
	main
	exit 0
elif [[ " ${VALID_VERBOSE_OPTIONS[*]} " == *" $1 "* ]]; then
	VERBOSE=true
	main
	exit 0
fi

# Parse command-line arguments
case "$1" in
# Extract the SFML library
	"--extract" )
		checkVerbosity "$2"
		extract ; 
		exit 0
		;;

# Quick way to give name to the project
	"--name" )
		checkVerbosity "$3"
		# Check if the user gave us a project name
		if [ -z "$2" ]; then
			printf "Option \'--name\' is missing a project name\n"
		else
			TARGET="$2"
			main
		fi
		exit 0
		;;

	"--linux" )
		linux
		exit 0
		;;

	"--help" | "-h" )
		usage
		exit 0
		;;

	* ) printf "Invalid argument. Use the \'--help\' option for arguments.\n" ; exit 1 ;;
esac

# Output success message
if [ "$IS_SFML_EXTRACTED" == 'true' ]; then
	echo "Successfully created new SFML project at $TARGET"
else
	echo "Project was created, but is missing the SFML module."
	echo "Remember to put it at $TARGET/SfmlProject"
fi
