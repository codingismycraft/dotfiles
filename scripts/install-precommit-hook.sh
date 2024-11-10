#!/bin/bash

# Installs the pre-commit hook to an existing git directory.
cd .git/hooks
echo "#!/bin/sh" > pre-commit
echo 'GIT_ROOT=$(git rev-parse --show-toplevel)' >> pre-commit
echo 'CHANGED_FILES=$(git diff --name-only --cached)' >> pre-commit
echo 'check_breakpoints.py "$GIT_ROOT" "$CHANGED_FILES"' >> pre-commit
chmod +x pre-commit
cd -
