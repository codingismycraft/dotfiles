#!/usr/bin/env python3
"""Pre-commit hook to prevent commits with breakpoints.

This script is intended to be used as a pre-commit hook in Git to
prevent commits containing breakpoint statements.

**How it works:**

1. **Arguments:**
    - `$GIT_ROOT`: The root directory of the Git repository.
    - `$CHANGED_FILES`: A newline-separated list of changed files.

2. **Functionality:**
    - Checks each changed file for breakpoint statements.
    - Prevents the commit if any breakpoint is found.

**Setup:**

1. Run `install-precommit-hook.sh` from the Git repository root.
   This script creates a pre-commit hook in `.git/hooks` that calls this
   script on every commit attempt.

2. Refer to `install-precommit-hook.sh` for details on pre-commit hook
   configuration.

**Installation:**

- Both this script (`check_breakpoints.py`) and `install-precommit-hook.sh`
  are installed globally by `install.sh` from your dotfiles to `/usr/local/bin`.
"""

import os
import sys


def check_for_breakpoints(filename):
    """If the passed in file contains a breakoint it returns False.

    :param str filename: The path to the file to check for breakpoints.

    :returns: True if no breakpoints exist (False otherwise).
    """
    with open(filename, 'r') as f:
        for line in f:
            if "breakpoint()" in line:
                print(f"Error: Found breakpoint in {filename}")
                return False
    return True


if __name__ == "__main__":
    git_root = sys.argv[1]
    for relative_paths in sys.argv[2:]:
        for relative_path in relative_paths.split('\n'):
            fullpath = os.path.join(git_root, relative_path)
            if os.path.isfile(fullpath):
                if not check_for_breakpoints(fullpath):
                    print(f"Fix file and try again: {fullpath}")
                    sys.exit(1)

