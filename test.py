#!/usr/bin/python3 

import gi
gi.require_version("voai", "1.0")
from gi.repository import voai 

voai.set_api_base("http://127.0.0.1:5000/v1")

completion = voai.ChatCompletion.new()
completion.add_message("system", "You are a helpful assistant.")
completion.add_message("user", "Hello, who are you?")

response = completion.send()

print(response.choices[0].message.get_content())