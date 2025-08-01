import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  final List<Map<String, String>> qaPairs = [
    {
      "question":"hi",
      "answer":"hi",
    },
    {
      "question": "what is flutter",
      "answer": "Flutter is an open-source UI toolkit by Google.",
    },
    {"question": "who created dart", "answer": "Dart was created by Google."},
    {
      "question": "what is state",
      "answer": "State is information that can change in a widget.",
    },
  ];

  void _sendMessage() {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    final botResponse = getAnswer(userMessage);

    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _messages.add({'role': 'bot', 'text': botResponse});
    });

    _controller.clear();
  }

  String getAnswer(String userInput) {
    for (var pair in qaPairs) {
      if (userInput.toLowerCase().contains(pair["question"]!)) {
        return pair["answer"]!;
      }
    }
    return "Sorry, I don't understand that yet.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,title: Text("AI Chatbot",style: TextStyle(fontWeight: FontWeight.bold),)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message['text']!),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Ask a question...',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
