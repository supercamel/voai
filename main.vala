
public int main() {
    voai.api_base = "http://127.0.0.1:5000/v1";
    voai.api_key = "";

    var completion = new voai.ChatCompletion();
    completion.add_message("system", "You are an AI assistant.");
    completion.add_message("user", "Hello. Say hello to me.");
    var response = completion.send();

    stdout.printf("n choices: %u\n", response.choices.length());
    stdout.printf("response: %s\n", response.choices.nth_data(0).message.get_content());
    return 0;
}
