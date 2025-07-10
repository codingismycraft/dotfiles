#!/bin/bash

# remove_leftovers.sh : A script to clean up Python bytecode files and cache
# directories.

# Print a message indicating the start of the cleanup process
echo "Starting cleanup: Removing all .pyc files and __pycache__ directories..."

# Find and remove all .pyc files
echo "Removing .pyc files..."
find . -type f -name "*.pyc" -exec rm -f {} \;

# Find and remove all __pycache__ directories
echo "Removing __pycache__ directories..."
find . -type d -name "__pycache__" -exec rm -rf {} \;

# Print a message indicating completion
echo "Cleanup complete!"
