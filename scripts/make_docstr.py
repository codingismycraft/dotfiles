#!/usr/bin/env python3

"""
Generates a Python docstring for a callable from system clipboard.

This module is a command-line tool designed to generate Python docstrings for a
callable object. It works by inspecting the code of the callable (which should
be present in the system clipboard) to generate an appropriate docstring
format. The resultant docstring is then displayed in the standard output.

The open-ai-key is stored in the ~/.videmux.config under a key with this name.
"""

import json
import os
import pathlib
import subprocess

import openai


def _load_settings():
    """Loads the applicable settings.

    The settings must be saved under the home directory
    in a file called .videmux.config in JSON format.

    Returns
    -------
    A python dictionary holding the config settings.
    """
    home_dir = pathlib.Path.home()
    filename = os.path.join(home_dir, '.videmux.config')
    with open(filename) as fin:
        return json.load(fin)


def _set_open_ai_key():
    """Returns the open-ai key.

    The open-ai-key is stored in the ~/.videmux.config which is a json file
    that can look as the following:

    {
        ...
        "open-ai-key": "<OPENAI_KEY>"
    }

    Returns
    -------
    The open ai key to use.
    """
    settings = _load_settings()
    openai.api_key = settings.get("open-ai-key", "")


def _read_clipboard():
    """
    Returns the content of the system clipboard by using the xclip command.

    This function attempts to execute the 'xclip -o' command in order to
    capture the current content saved in the clipboard. The output is then
    returned as a string after being decoded.

    It handles exceptions accordingly, specifically 'FileNotFoundError',
    'CalledProcessError' and 'TimeoutExpired' from the subprocess module.
    The exception is printed out and reraised.

    Returns
    -------
    The current content of the system clipboard in the form of a string, or
    None if an exception was raised during the execution of the command.

    Please note that the exceptions raised can vary depending on the system and
    what's installed, and also that the function will return None if an
    exception is raised.

    Raises
    ------
    FileNotFoundError: If the xclip command isn't found on the system.
    CalledProcessError: If the xclip command returns a non-zero exit code.
    TimeoutExpired: If the xclip command doesn't respond in a timely
    manner.
    """
    try:
        output = subprocess.run(
            ["xclip", "-o"],
            capture_output=True
        )
    except (FileNotFoundError,
            subprocess.CalledProcessError,
            subprocess.TimeoutExpired) as exc:
        print(f"{exc}")
        raise
    else:
        return output.stdout.decode().strip()


_WRITE_DOC_STR_PROMPT = "write the docstring for the passed in python function\
The first line of the docstring should follow the opening quotes without \
a new line. this line MUST end with a period and be less than 77 chars. \
For each line you MUST add the same number of spaces as there are in the \
first line of the code of the function.\
each line must be 79 or less chars including the prefixing  while \
a paragrah must be broken to separate lines up to 79 characters long eachone\
You should also include parameters, returns and raises."


def make_doc_str():
    """
    Generate a docstring for a Python function.

    Function code is provided via the clipboard.

    Returns
    -------
    str : The generated docstring content, as returned by the OpenAI API.

    Raises
    ------
    Any exception raised by the OpenAI API.
    """
    _set_open_ai_key()
    func_code = _read_clipboard()
    msg = f"this is the function code to write the docstr for {func_code}"
    chat_completion = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[
            {"role": "user", "content": _WRITE_DOC_STR_PROMPT},
            {"role": "user", "content": msg},
        ]
    )
    return chat_completion["choices"][0]["message"]["content"]


if __name__ == '__main__':
    print(make_doc_str())
