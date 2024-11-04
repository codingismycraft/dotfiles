#!/usr/bin/env python3

"""CLI tool to convert a local filepath to its corresponding Github URL.

This tool takes a local filepath as input and outputs the corresponding Github
URL. It is inspired by a feature in PyCharm that allows users to open a Github
URL directly from the IDE.

Primarily intended for use in Vim as part of a pipe filter. It can handle full
or partial file names, along with a line number. The tool will display the
corresponding information in a new buffer, allowing the user to directly
navigate to the relevant location on Github.  """


import argparse
import os
import pathlib
import subprocess


def _get_hash_for_git_object(filename):
    """If the passed in file is under git returns the commit hash.

    Parameter:
    filename(str): The full path to the file to get the commit hash.

    Returns:
    The commit hash if the file is under git version control or None.
    """
    dirname = os.path.dirname(filename)
    basename = os.path.basename(filename)
    original_dir = None
    try:
        original_dir = os.getcwd()
        os.chdir(dirname)
        output = subprocess.run(
            ["git", "log", "-n", "1", "--pretty=format:%H", "--", basename  ], 
            capture_output=True
        )
    except (FileNotFoundError, 
            subprocess.CalledProcessError, 
            subprocess.TimeoutExpired) as exc:
        print(f"{exc}")
    else:
        return output.stdout.decode().strip()
    finally:
        if original_dir:
            os.chdir(original_dir)
    return None


def _get_top_level_dir(filename):
    """Retrieve root directory of a local Git repository.
    
    Args:
        filename (str): Full path to a file within a local Git repository.
    
    Returns:
        str: Path to the root directory of the local Git repository.
        If the file is not under a git repo it will return None.
    """
    dirname = os.path.dirname(filename)
    basename = os.path.basename(filename)
    original_dir = None
    try:
        original_dir = os.getcwd()
        os.chdir(dirname)
        output = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"], 
            capture_output=True
        )
    except (FileNotFoundError, 
            subprocess.CalledProcessError, 
            subprocess.TimeoutExpired) as exc:
        print(f"{exc}")
    else:
        return output.stdout.decode().strip()
    finally:
        if original_dir:
            os.chdir(original_dir)
    return None


def _get_remote_servers(filename, linenum=None):
    """Fetches remote server URLs for a Git version-controlled file.

    Args:
        filename (str): Name of the file for which to retrieve the remote
        server URLs.
    
    Returns:
        list: List of URLs for remote servers if file is under Git version
        control.  Otherwise, returns an empty list.
    """
    hash_code = _get_hash_for_git_object(filename)
    if not hash_code:
        return []
    dirname = os.path.dirname(filename)
    top_level_dir = _get_top_level_dir(filename) 
    basename = filename.replace(top_level_dir, "")
    if basename.startswith("/"):
        basename = basename[1:]
    original_dir = None
    try:
        original_dir = os.getcwd()
        os.chdir(dirname)
        output = subprocess.run(
            ["git", "remote", "-v"], 
            capture_output=True
        )
    except (FileNotFoundError, 
            subprocess.CalledProcessError, 
            subprocess.TimeoutExpired) as exc:
        print(f"{exc}")
    else:
        response = output.stdout.decode().strip()
        urls = set()
        for row in response.split('\n'):
            row = row.replace('\t', ' ')
            name, url, _ = row.split(' ')
            url = url.replace('git@', '')
            url = url.replace(':', '/')
            url = url.replace('.git', '')
            url = "https://" + url + "/blob/" + hash_code + "/" + basename
            if linenum is not None:
                url += f"#L{linenum}"
            urls.add(url)
        return list(urls)
    finally:
        if original_dir:
            os.chdir(original_dir)
    return []

def get_file_path(file_name):
    """Get absolute path of a file from either a full or partial filename.

    Args
    file_name: Filename (absolute or partial path)
    
    Returns
    The absolute path of the file.
    """
    if os.path.isabs(file_name):
        return file_name
    else:
        current_dir = os.getcwd()
        return os.path.join(current_dir, file_name)
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Displays github info for a file.'
    )

    parser.add_argument(
        'filename', type=str, help='The name of the file to use.'
    )

    parser.add_argument(
        '-l', '--linenum', type=int, help='The line number.', default=None
    )

    args = parser.parse_args()

    linenum = None
    if args.linenum:
        linenum = int(args.linenum)

    fn = args.filename
    fn = get_file_path(fn)

    for url in _get_remote_servers(fn, linenum):
        print(url)
        # Only print one link.
        break

