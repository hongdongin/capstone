import 'package:flutter/material.dart';

class GroupChatPage extends StatefulWidget {
  const GroupChatPage({Key? key}) : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() {
    _messages.add(_messageController.text);
    _messageController.clear();
  }

  void _inviteUser() {
    // TODO: Implement user invitation logic.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Messages list
            ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Text(_messages[index]);
              },
            ),
            // Message input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
            // User invitation button
            ButtonBar(
              children: [
                TextButton(
                  onPressed: _inviteUser,
                  child: Text('Invite User'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
