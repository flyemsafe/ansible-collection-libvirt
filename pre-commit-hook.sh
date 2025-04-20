#!/bin/bash

# Pre-commit hook to remove trailing whitespace from files
# To install, copy this file to .git/hooks/pre-commit and make it executable
# or create a symlink: ln -s ../../pre-commit-hook.sh .git/hooks/pre-commit

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running pre-commit hook to remove trailing whitespace...${NC}"

# Find all staged files
staged_files=$(git diff --cached --name-only --diff-filter=ACM)

# Exit if no files are staged
if [ -z "$staged_files" ]; then
    echo -e "${GREEN}No files staged for commit.${NC}"
    exit 0
fi

# Counter for modified files
modified_count=0

# Process each staged file
for file in $staged_files; do
    # Skip binary files, only process text files
    if file "$file" | grep -q "text"; then
        # Check if file has trailing whitespace
        if grep -q "[[:space:]]$" "$file"; then
            echo -e "${YELLOW}Removing trailing whitespace from $file${NC}"

            # Remove trailing whitespace and add the file back to staging
            sed -i 's/[[:space:]]*$//' "$file"
            git add "$file"

            ((modified_count++))
        fi
    fi
done

if [ $modified_count -gt 0 ]; then
    echo -e "${GREEN}Removed trailing whitespace from $modified_count files.${NC}"
else
    echo -e "${GREEN}No trailing whitespace found in staged files.${NC}"
fi

# Special handling for YAML files to ensure proper formatting
yaml_files=$(echo "$staged_files" | grep -E '\.ya?ml$')
if [ -n "$yaml_files" ]; then
    echo -e "${YELLOW}Checking YAML files for proper formatting...${NC}"

    # Check if ansible-lint is available
    if command -v ansible-lint &> /dev/null; then
        for yaml_file in $yaml_files; do
            if ansible-lint "$yaml_file" --format=pep8 2>/dev/null | grep -q "yaml\[trailing-spaces\]"; then
                echo -e "${YELLOW}Fixing trailing spaces in YAML file: $yaml_file${NC}"
                sed -i 's/[[:space:]]*$//' "$yaml_file"
                git add "$yaml_file"
            fi
        done
    else
        echo -e "${YELLOW}ansible-lint not found, skipping YAML specific checks${NC}"
    fi
fi

exit 0
