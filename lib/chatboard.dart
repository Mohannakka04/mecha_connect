// // import 'package:flutter/material.dart';

// // class Chatboard extends StatefulWidget {
// //   const Chatboard({super.key});

// //   @override
// //   State<Chatboard> createState() => _ChatboardState();
// // }

// // class _ChatboardState extends State<Chatboard> {
// //   final _search = TextEditingController();
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey.shade400,
// //       body: 
// //       Center(
// //         child: Padding(
// //           padding: const EdgeInsets.all(8.0),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Center(
// //                 child: TextFormField(
// //                   controller: _search,
// //                   decoration: InputDecoration(
// //                     border: OutlineInputBorder(
// //                       borderSide: BorderSide(color: Colors.amber),
// //                       borderRadius: BorderRadius.circular(20),
// //                     )
// //                   ),
// //                 ),
// //               )
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class ChatBotScreen extends StatefulWidget {
//   @override
//   _ChatBotScreenState createState() => _ChatBotScreenState();
// }

// class _ChatBotScreenState extends State<ChatBotScreen> {
//   final TextEditingController _controller = TextEditingController();
//   List<Map<String, String>> messages = [];

//   Future<void> sendMessage(String message) async {
//     setState(() {
//       messages.add({'role': 'user', 'content': message});
//     });

//     final response = await http.post(
//       Uri.parse("https://api.openai.com/v1/chat/completions"),
//       headers: {
//         'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         "model": "gpt-3.5-turbo",
//         "messages": messages,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final reply = jsonDecode(response.body)['choices'][0]['message']['content'];
//       setState(() {
//         messages.add({'role': 'assistant', 'content': reply});
//       });
//     } else {
//       print("Error: ${response.body}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("AI ChatBot")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (_, index) {
//                 final msg = messages[index];
//                 return ListTile(
//                   title: Align(
//                     alignment: msg['role'] == 'user'
//                         ? Alignment.centerRight
//                         : Alignment.centerLeft,
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: msg['role'] == 'user' ? Colors.blue[100] : Colors.grey[300],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(msg['content'] ?? ''),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(child: TextField(controller: _controller)),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     final message = _controller.text;
//                     _controller.clear();
//                     sendMessage(message);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
