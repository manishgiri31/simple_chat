import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ChatPage());
  }
}

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final channel = WebSocketChannel.connect(Uri.parse('ws://YOUR_IP:3000'));

  final TextEditingController controller = TextEditingController();

  List<String> messages = [];

  @override
  void initState() {
    super.initState();

    channel.stream.listen((message) {
      setState(() {
        messages.add("Friend: $message");
      });
    });
  }

  void sendMessage() {
    if (controller.text.isEmpty) return;

    channel.sink.add(controller.text);

    setState(() {
      messages.add("Me: ${controller.text}");
    });

    controller.clear();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Chat")),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(messages[index]),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Enter message",
                    ),
                  ),
                ),

                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
