namespace voai {
    public string api_key;
    public string api_base;
    public string default_model;

    public void set_api_key(string key) {
        api_key = key;
    }

    public void set_api_base(string b) {
        api_base = b;
    }

    public void set_default_model(string m) {
        default_model = m;
    }


    public class ChatCompletion : Object {
        public ChatCompletion() {
            json_object = new Json.Object();

            if(default_model == null || default_model == "") {
                default_model = "gpt-3.5-turbo";
            }
            model = default_model;

            if(api_base == "" || api_base == null) {
                api_base = "https://api.openai.com/v1";
            }

            if(api_key == null) {
                // try load from environment variable
                api_key = Environment.get_variable("OPENAI_API_KEY");
                if(api_key == null) {
                    stdout.printf("Warning: Open API key is not set. Please set it in the environment variable OPENAI_API_KEY, or set voai.api_key to the value of your API key, or an empty string if no key is needed.\n");
                }
            }
        }
        
        public void add_message(string role, string content) {
            if(json_object.has_member("messages") == false) {
                json_object.set_array_member("messages", new Json.Array());
            }

            var msg_obj = new Json.Object();
            msg_obj.set_string_member("role", role);
            msg_obj.set_string_member("content", content);
            var messages_array = json_object.get_array_member("messages");
            messages_array.add_object_element(msg_obj);
        }

        public void add_stop(string stop_string) {
            if(json_object.has_member("stop") == false) {
                // if the stop is not set, set it to an empty array
                json_object.set_array_member("stop", new Json.Array());
            }
            
            var stop_array = json_object.get_array_member("stop");
            stop_array.add_string_element(stop_string);
        }

        // sends a blocking request to the OpenAI API and returns a CompletionResponse
        public CompletionResponse send() {
            // create json string from the object
            var node = new Json.Node(Json.NodeType.OBJECT);
            node.set_object(json_object);
            var json_string = Json.to_string(node, true);

            var session = new Soup.Session();
            var message = new Soup.Message("POST", api_base + "/chat/completions");
            message.request_headers.append("Content-Type", "application/json");
            message.request_headers.append("Authorization", "Bearer " + api_key);

            var bytes = new Bytes.static(json_string.data);
            message.set_request_body_from_bytes("application/json; chatset=utf-8", bytes);

            var response_bytes = session.send_and_read(message);
            string response_json = (string)response_bytes.get_data();

            var parser = new Json.Parser();
            parser.load_from_data(response_json);
            var response_node = parser.get_root();
            if(response_node == null) {
                stdout.printf("Error: Could not parse response json\n");
            } 
            if(response_node.get_object() == null) {
                stdout.printf("Error: Response json is not an object\n");
            }
            return new CompletionResponse(response_node.get_object());
        }

        public async CompletionResponse send_async() {
            // create json string from the object
            var node = new Json.Node(Json.NodeType.OBJECT);
            node.set_object(json_object);
            var json_string = Json.to_string(node, true);

            var session = new Soup.Session();
            var message = new Soup.Message("POST", api_base + "/chat/completions");
            message.request_headers.append("Content-Type", "application/json");
            message.request_headers.append("Authorization", "Bearer " + api_key);

            var bytes = new Bytes.static(json_string.data);
            message.set_request_body_from_bytes("application/json; chatset=utf-8", bytes);

            var response_bytes = yield session.send_and_read_async(message, Priority.DEFAULT, null);
            string response_json = (string)response_bytes.get_data();

            var parser = new Json.Parser();
            parser.load_from_data(response_json);
            var response_node = parser.get_root();

            if(response_node == null) {
                stdout.printf("Error: Could not parse response json\n");
            } 
            if(response_node.get_object() == null) {
                stdout.printf("Error: Response json is not an object\n");
            }
            return new CompletionResponse(response_node.get_object());
        }

        public string model { 
            get { return json_object.has_member("model") ? json_object.get_string_member("model") : ""; }
            set { json_object.set_string_member("model", value); }
        }

        public double frequency_penalty { 
            get { return json_object.has_member("frequency_penalty") ? json_object.get_double_member("frequency_penalty") : 0.0; } 
            set { json_object.set_double_member("frequency_penalty", value); } 
        }

        public int64 max_tokens { 
            get { return json_object.has_member("max_tokens") ? json_object.get_int_member("max_tokens") : 0; }
            set { json_object.set_int_member("max_tokens", value); }
        }

        public int64 n { 
            get { return json_object.has_member("n") ? json_object.get_int_member("n") : 0; }
            set { json_object.set_int_member("n", value); }
        }

        public double presence_penalty {
            get { return json_object.has_member("presence_penalty") ? json_object.get_double_member("presence_penalty") : 0.0; }
            set { json_object.set_double_member("presence_penalty", value); }
        }

        public int64 seed {
            get { return json_object.has_member("seed") ? json_object.get_int_member("seed") : 0; }
            set { json_object.set_int_member("seed", value); }
        }

        public double temperature {
            get { return json_object.has_member("temperature") ? json_object.get_double_member("temperature") : 0.0; }
            set { json_object.set_double_member("temperature", value); }
        }

        public bool top_p {
            get { return json_object.has_member("top_p") ? json_object.get_boolean_member("top_p") : false; }
            set { json_object.set_boolean_member("top_p", value); }
        }

        public string user {
            get { return json_object.has_member("user") ? json_object.get_string_member("user") : ""; }
            set { json_object.set_string_member("user", value); }
        }

        // json object
        Json.Object json_object;

        // TODO tools & tool choice 
        // stream and stream choice
    }
}
