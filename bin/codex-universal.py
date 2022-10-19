#! /usr/bin/env python3
import os
import openai
import sys, getopt

prompt = ""
for line in sys.stdin:
    prompt = prompt + line

openai.api_key = os.getenv("OPENAI_API_KEY")

response = openai.Completion.create(
  engine="code-davinci-001",
  prompt=prompt,
  temperature=0,
  max_tokens=2000,
  top_p=1,
  frequency_penalty=0,
  presence_penalty=0
)

print(prompt + response.choices[0].text)
