
namespace voai {
    

    public class CompletionResponse : Object {
        public CompletionResponse(Json.Object json_obj) {
            this.json_obj = json_obj;

            if(json_obj.has_member("usage")) {
                usage = new Usage(json_obj.get_object_member("usage"));
            }

            choices = new List<Choice>();
            if(json_obj.has_member("choices")) {
                var choices_arr = json_obj.get_array_member("choices");
                for (int i = 0; i < choices_arr.get_length(); i++) {
                    choices.append(new Choice(choices_arr.get_object_element(i)));
                }
            }
        }

        public class Choice : Object {
            public Choice (Json.Object json_obj) {
                this.json_obj = json_obj;
                if(json_obj.has_member("message")) {
                    message = new Message(json_obj.get_object_member("message"));
                }
            }

            public class Message : Object {
                public Message(Json.Object json_obj) { 
                    this.json_obj = json_obj;
                }

                private Json.Object json_obj;
                public bool has(string key) {
                    return json_obj.has_member(key);
                }

                public string role {
                    get { return json_obj.get_string_member("role"); }
                }
                public string content {
                    get { return json_obj.get_string_member("content"); }
                }
            }

            private Json.Object json_obj;
            public bool has(string key) {
                return json_obj.has_member(key);
            }

            public string index {
                get { return json_obj.get_string_member("index"); }
            }

            public string logprobs {
                get { return json_obj.get_string_member("logprobs"); }
            }

            public Message message;

            public string finish_reason {
                get { return json_obj.get_string_member("finish_reason"); }
            }
        }

        public class Usage : Object {
            public Usage(Json.Object json_obj) {
                this.json_obj = json_obj;
            }

            public int64 prompt_tokens {
                get { return json_obj.get_int_member("prompt_tokens"); }
            }

            public int64 completion_tokens {
                get { return json_obj.get_int_member("completion_tokens"); }
            }

            public int64 total_tokens {
                get { return json_obj.get_int_member("total_tokens"); }
            }

            private Json.Object json_obj;
        }

        public bool has_member(string name) {
            return json_obj.has_member(name);
        }

        public string id {
            get { return json_obj.get_string_member("id"); }
        }

        public string object {
            get { return json_obj.get_string_member("object"); }
        }

        public string created {
            get { return json_obj.get_string_member("created"); }
        }

        public string model {
            get { return json_obj.get_string_member("model"); }
        }

        public string system_fingerprint {
            get { return json_obj.get_string_member("system_fingerprint"); }
        }

        public string get_first() {
            if(choices.length() > 0) {
                return choices.nth_data(0).message.content;
            }
            else {
                return "";
            }
        }

        public List<Choice> choices;
        public Usage usage;

        private Json.Object json_obj;
    }
}
