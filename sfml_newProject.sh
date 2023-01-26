#!/usr/bin/bash
#
# Generate new SFML project template for Visual Studio 2017

SFML_PROJECT="$(dirname "$0")/sfml_template.tar.gz"
TARGET=""

# Check whether target destination was passed
if [ -z "$1" ]; then
	echo "Missing target destination"
	exit 1
else
	TARGET="$1"
fi

# Attempt to find the SFML project
if [ ! -f "$SFML_PROJECT" ]; then
	echo "Could not find the SFML template project"
	exit 1
fi

echo "Generating new SFML project..."

mkdir -p "$TARGET" || { echo "Could not create new project. Missing permission?"; exit 1; }

tar -xvf "$SFML_PROJECT" -C "$TARGET" || { echo "Could not create new project. Missing permission?"; exit 1; }

echo "Successfully created new SFML project at $TARGET"
