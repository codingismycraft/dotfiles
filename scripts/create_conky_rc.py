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
import sys

assert len(sys.argv) == 3, "You must pass the user name and a " \
                           "flag to indicate if nvidia is installed " \
                           "(1 or 0) in the command line."
USER_NAME = sys.argv[1]
assert USER_NAME.strip() != "root", "Cannot install dotfiles for root"
home_dir = os.path.join("/", "home", USER_NAME)
assert os.path.isdir(home_dir), "Invalid home directory: " + home_dir

NVIDIA_IS_AVAILABLE = bool(int(str(sys.argv[2])))

_CURRENT_DIR = os.path.dirname(os.path.realpath(__file__))
_CONKEYRC_FILEPATH = os.path.join(home_dir, ".conkyrc")


def make_cpu_content():
    """Returns the conky config for the cores.

    :returns: The lines to add to the conkyrc for the CPUs.
    :rtype: list
    """
    count = multiprocessing.cpu_count()
    x = []
    for i in range(count):
        i += 1
        x.append(f"CPU - {i:>2}: ${{cpu cpu{i} }}% ${{cpubar cpu{i} }}")
    return x


def make_gpu_content():
    """Returns the conky config for the GPU related section.

    :returns: The lines to add to the conkyrc GPU section.
    :rtype: list
    """
    lines = [
        "GPU Temp ${execi 60 nvidia-settings -query [gpu:0]/GPUCoreTemp -t}°C",
        "${color FFA300}GPU:$color${font}${exec nvidia-smi -L | cut -c 6-30}${color FFA300} Freq:$color${nvidia gpufreq} Mhz $color${color FFA300}Temperature $color${nvidia temp} C",
        "${color FFA300}Watt:$color${font}${exec nvidia-smi -i 0 -q -d POWER |grep 'Draw' | cut -c 45-49}${color FFA300} Used:$color${font}${exec nvidia-smi -i 0 -q -d MEMORY |grep 'Used' | cut -c 45-55 | head -1}"
    ]
    return lines


def main():
    lines = []
    fn = os.path.join(_CURRENT_DIR, "..", "conkyrc")
    with open(fn) as fin:
        for line in fin:
            line = line.strip()
            if line.startswith("__ADD_CPUS_HERE__"):
                cpu_description = make_cpu_content()
                for line1 in cpu_description:
                    lines.append(line1)
            elif line.startswith("__ADD_NVIDIA_INFO_HERE__"):
                if NVIDIA_IS_AVAILABLE:
                    gpu_description = make_gpu_content()
                    for line1 in gpu_description:
                        lines.append(line1)
            else:
                lines.append(line)

    with open(_CONKEYRC_FILEPATH, "w") as fout:
        for line in lines:
            fout.write(line)
            fout.write("\n")


if __name__ == '__main__':
    main()
