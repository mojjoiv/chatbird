import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SendbirdSdk.init('BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GroupChannel channel;
  List<BaseMessage> messages = [];
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _connectToChannel();
  }

  Future<void> _connectToChannel() async {
    GroupChannelListQuery query = GroupChannelListQuery();
    List<GroupChannel> channels = await query.loadNext();
    if (channels.isNotEmpty) {
      channel = channels[0];
      await channel.enter();
      _loadMessages();
    }
  }

  Future<void> _loadMessages() async {
    MessageListParams params = MessageListParams()
      ..limit = 10
      ..reverse = true;
    List<BaseMessage> messagesList = await channel.getMessages(params);
    setState(() {
      this.messages = messagesList;
    });
  }

  Future<void> _sendMessage() async {
    if (messageController.text.isNotEmpty) {
      UserMessageParams params = UserMessageParams()
        ..message = messageController.text;
      await channel.sendUserMessage(params);
      _loadMessages();
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.message),
                  subtitle: Text(message.createdAt),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(hintText: "Type a message"),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
