#!/usr/bin/bash
#
# Generate new SFML project template for Visual Studio 2017

SFML_PROJECT="$(dirname "$0")/sfml_template.tar.gz"
TARGET=""
DEFAULT_PROJECT_NAME="NewSfmlProject"

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
	# Attempt to find the SFML project
	if [ ! -f "$SFML_PROJECT" ]; then
		echo "Could not find the SFML template project"
		exit 1
	fi
	
	# Create new project directory
	createProjectDir || exit "$?"
	
	echo "Extracting SFML template project..."
	
	# Extract the SFML project template
	tar -xvf "$SFML_PROJECT" -C "$TARGET" &> /dev/null || {
		echo "Could not create new project. Missing permission?"; \
		removeProjectDir; \
		exit 1; \
		}
	
	# Success message
	printf "Successfully created new SFML project at \'$TARGET\'\n"
}

# Accept command-line arguments for project name
if [ ! -z "$1" ]; then
	TARGET="$1"
fi

main