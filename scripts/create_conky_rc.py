#!/usr/bin/env python3
"""Creates the conkyrc using the existing number of CPUs.

Had to write this utility to be able to easily support machines with
different number of CPUs without having to edit the conkyrc file.

Running the install.rc from the parent directory will call this script
which will take care of creating the proper conkyrc.

Uses as basis the conkyrc that is defined in the parent directory while
it substitutes the string __ADD_CPUS_HERE__ with the lines that correspond
to the found CPUs.
"""

import multiprocessing
import os
from pathlib import Path

home_dir = str(Path.home())

_CURRENT_DIR = os.path.dirname(os.path.realpath(__file__))
_CONKEYRC_FILEPATH = os.path.join(home_dir, ".conkyrc")


def make_cpu_content():
    """Prints the cores to the screen in a conkey friendly format."""
    count = multiprocessing.cpu_count()
    x = []
    for i in range(count):
        i += 1
        x.append(f"CPU - {i:>2}: ${{cpu cpu{i} }}% ${{cpubar cpu{i} }}")
    return x


def main():
    cpu_description = make_cpu_content()
    lines = []
    fn = os.path.join(_CURRENT_DIR, "..", "conkyrc")
    with open(fn) as fin:
        for line in fin:
            line = line.strip()
            if not line.startswith("__ADD_CPUS_HERE__"):
                lines.append(line)
            else:
                lines.extend(cpu_description)

    with open(_CONKEYRC_FILEPATH, "w") as fout:
        for line in lines:
            fout.write(line)
            fout.write("\n")


if __name__ == '__main__':
    main()
