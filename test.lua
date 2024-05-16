local lgi = require 'lgi'
local voai = lgi.voai

voai.set_api_base("http://127.0.0.1:5000/v1")


local completion = voai.ChatCompletion.new()
completion:add_message("system", "You are a helpful assistant.")
completion:add_message("user", "Hello, who are you?")

local response = completion:send()

if response and response.get_first then
    local first_response = response:get_first()
    print(first_response)
else
    print("Error: Unable to get response or method 'get_first' not found.")
end
