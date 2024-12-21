#!/usr/bin/env python3
"""Verifies the OpenAI key that is passed in the command line."""

import sys

import openai


def verify_key(openai_key):
    """Verifies the key.

    :param str openai_key: The openai key to vefiry.
    """
    client = openai.OpenAI(api_key=openai_key)

    chat_completion = client.chat.completions.create(
        messages=[
            {
                "role": "user",
                "content": "what it the capital of France?",
            }
        ],
        model="gpt-3.5-turbo",
    )
    response = chat_completion.choices[0].message.content
    assert "PARIS" in response.upper()
    print("Key is valid.")


if __name__ == '__main__':
    assert len(sys.argv) == 2, "OpenAI key not passed in commandline."
    verify_key(sys.argv[1])
