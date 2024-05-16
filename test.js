imports.gi.versions.voai = "1.0";
const { voai } = imports.gi;

voai.set_api_base("http://127.0.0.1:5000/v1");


completion = voai.ChatCompletion.new();
completion.add_message("system", "You are a helpful assistant.");
completion.add_message("user", "Hello, who are you?");

response = completion.send().get_first();

print(response);