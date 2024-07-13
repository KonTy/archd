#!/bin/bash

# Check if the directory is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Assign the directory argument to a variable
DIRECTORY=$1

# Check if the provided argument is a directory
if [ ! -d "$DIRECTORY" ]; then
  echo "Error: $DIRECTORY is not a directory."
  exit 1
fi

# Change permissions to make all files executable and update Git index
find "$DIRECTORY" -type f | while read -r file; do
  chmod +x "$file"
  echo "Assigned execute permission to $file"
  git update-index --chmod=+x "$file"
  echo "Updated Git index for $file"
done

echo "All files in $DIRECTORY are now executable and Git index is updated."
