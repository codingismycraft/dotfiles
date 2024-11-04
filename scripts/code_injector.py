"""Used to mainted injected code to a script.

This script facilitates the maintenance and injection of custom code
into a script by replacing or appending to a predefined range of lines
in a target file.

The primary use case is to automate the customization of a target file
(for instance, a configuration file like `.bashrc`) by injecting
changes between specified line delimiters.

Functionality:
- The script identifies a block in the target file delimited by
  specified start and end markers.

- This block of content is replaced by content from a source file.

- If the start or end delimiter is not found, the content of the
  source file is appended to the end of the target file.

Inputs:

-b: Delimiter line indicating the beginning of the block to be
replaced in the target file.

-e: Delimiter line indicating the end of the block to be replaced in
the target file.

-t: Path to the target file, which will be modified.

-s: Path to the source file, whose content will replace the block in
the target file.

Usage:
python script.py -b "<begin_delimiter>" -e "<end_delimiter>"
        -t <target_file> -s <source_file>
"""

import argparse
import datetime
import os
import shutil
import sys

MIN_DLMTR_LNGTH = 10  # Minimum Delimeter Length


def parse_arguments():
    """Parses command-line arguments and returns them.

    Returns:
        args: Namespace object containing the parsed arguments.
    """
    parser = argparse.ArgumentParser(
        description="Inject code into a script based on defined delimiters."
    )

    parser.add_argument(
        '-b',
        '--begin',
        required=True,
        help='The begin delimiter line'
    )

    parser.add_argument(
        '-e',
        '--end',
        required=True,
        help='The end delimiter line'
    )

    parser.add_argument(
        '-t',
        '--target',
        required=True,
        help='The target file to be modified'
    )

    parser.add_argument(
        '-s',
        '--source',
        required=True,
        help='The source file containing replacement content'
    )

    return parser.parse_args()


def create_backup(file_path):
    """Backups the passed in file.

    Copies the specified file and appends the current date and time to the new
    file's name.

    :param str file_path: The path to the file to be copied.
    :raises FileNotFoundError
    """
    if not os.path.isfile(file_path):
        raise FileNotFoundError(f"The file '{file_path}' does not exist.")

    directory, original_file_name = os.path.split(file_path)
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    new_file_name = f"{original_file_name}-{timestamp}"
    new_file_path = os.path.join(directory, new_file_name)
    shutil.copy(file_path, new_file_path)


def read_file(fullpath):
    """Returns a list with the lines in the passed in file.

    :param str fullpath: The full path to the file to read.

    :returns: A list consisting with the lines in the passed in file.
    :rtype: list
    """
    lines = []
    try:
        with open(fullpath, 'r') as fin:
            for line in fin:
                lines.append(line.strip())
    except FileNotFoundError:
        print(f"Error: Source file '{fullpath}' not found.")
        sys.exit(1)
    except IOError as e:
        print(f"Error reading source file '{fullpath}': {e}")
        sys.exit(1)
    return lines


def main():
    """Injects content into a target file between specified delimiters.

    Inserts content from a source file into a target file between specified
    delimiters, replacing any existing content in that range to ensure the
    target file contains only the latest source content.  Before inserting the
    content it backs up the target file.

    Preconditions:
    - Both the source and target file paths must be specified and valid.

    - The delimiters must not be of trivial length, ensuring meaningful code
      injection boundaries.

    Raises:
    - AssertionError: If either the target or source file does not exist.

    - AssertionError: If delimiters are shorter than the required minimum
      length (`MIN_DLMTR_LNGTH`).
    """
    args = parse_arguments()

    begin_delimiter = args.begin
    end_delimiter = args.end

    begin_delimiter = begin_delimiter.strip()
    end_delimiter = end_delimiter.strip()

    target_file = args.target
    source_file = args.source

    assert os.path.isfile(target_file), f"{target_file} does not exit."
    assert os.path.isfile(source_file), f"{source_file} does not exit."

    assert len(begin_delimiter) > MIN_DLMTR_LNGTH, "Too short begin delimiter."
    assert len(end_delimiter) > MIN_DLMTR_LNGTH, "Too short end delimiter."

    source_lines = read_file(source_file)
    target_lines = read_file(target_file)

    # Remove pre-exising matches from the target.
    lines = []
    inside_block = False

    for line in target_lines:
        if inside_block:
            continue

        if line == end_delimiter:
            inside_block = False
        elif line == begin_delimiter:
            inside_block = True
        else:
            assert inside_block is False
            lines.append(line)

    # At this point the lines array is "clear" meaning that any dotfiles
    # injected that might have been there from a previous run.

    lines.append("")
    lines.append(begin_delimiter)
    lines.extend(source_lines)
    lines.append(end_delimiter)

    # Backup the file and innect the text to it.
    create_backup(target_file)

    with open(target_file, 'w') as fout:
        for line in lines:
            print(line)
            fout.write(line)
            fout.write('\n')


if __name__ == "__main__":
    main()
