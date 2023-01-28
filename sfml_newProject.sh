#!/usr/bin/bash
#
# Generate new SFML project template for Visual Studio 2017

SFML_PROJECT="$(dirname "$0")/templates/SFML.tar.gz"
PROJECT_TEMPLATE="$(dirname "$0")/templates/project_template"
TARGET=""
DEFAULT_PROJECT_NAME="NewSfmlProject"

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
	if [ ! -f "$SFML_PROJECT" ]; then
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
	tar -xvf "$SFML_PROJECT" -C "$TARGET/SfmlProject" || { echo "Could not extract the SFML module"; IS_SFML_EXTACRED=false; }
}

# Accept command-line arguments for project name
if [ ! -z "$1" ]; then
	TARGET="$1"
fi

main

# Output success message
if [ "$IS_SFML_EXTRACTED" == 'true' ]; then
	echo "Successfully created new SFML project at $TARGET"
else
	echo "Project was created, but is missing the SFML module."
	echo "Remember to put it at $TARGET/SfmlProject"
fi
