import 'package:flutter/material.dart';

class ChatMessage {
  final String sender;
  final String message;

  ChatMessage({required this.sender, required this.message});
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> _messages = [];
  ScrollController _scrollController = ScrollController();
  TextEditingController _controller = TextEditingController();

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
      // Scroll to the bottom after adding a new message
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 300,
            color: Colors.amber,
            padding: const EdgeInsets.only(bottom: 6),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ListView.builder(
                      // shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: _messages.length,
                      padding:
                          EdgeInsets.only(bottom: kBottomNavigationBarHeight),
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return ListTile(
                          title: Text(message.sender),
                          subtitle: Text(message.message),
                        );
                      },
                    ),
                  )
                ],
              );
            }),
          ),
          Divider(height: 2, color: Colors.red),
          SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type a message',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (text) {
                      _addMessage(
                          ChatMessage(sender: 'Me', message: _controller.text));
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty && _controller.text != '') {
                      final text = _controller.text;
                      _addMessage(ChatMessage(sender: 'Me', message: text));

                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
