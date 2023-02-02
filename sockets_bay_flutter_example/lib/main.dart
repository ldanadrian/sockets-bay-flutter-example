// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String socketsBayUrl = "wss://socketsbay.com/wss/v2/1/demo/";

  late WebSocketChannel channel;
  bool isConnected = false;

  List<String> messages = [];

  _connect() {
    try {
      channel = WebSocketChannel.connect(
        Uri.parse(socketsBayUrl),
      );
      channel.stream.listen(_onMessage, onError: _onError);
      setState(() {
        isConnected = true;
      });

      print("Connected with success!");
    } on Exception catch (_) {
      print("ERROR! Cannot connect to host!");
    }
  }

  _sendMessage(String message) {
    channel.sink.add(message);
    setState(() {
      messages.add(message);
    });

    print("We sent: ${message}");
  }

  _onMessage(dynamic message) {
    setState(() {
      messages.add(message);
    });
    print("We have received: ${message}");
  }

  _onError(Object err) {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                color: Colors.blue,
                height: 200,
                child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var item = messages[index];
                      return ListTile(
                          title: Text(item,
                              style: const TextStyle(color: Colors.black)));
                    }),
              ),
              isConnected
                  ? const Text("connected")
                  : ElevatedButton(
                      onPressed: (() => _connect()),
                      child: const Text("connect")),
              ElevatedButton(
                  onPressed: (() => _sendMessage("hello hello!")),
                  child: const Text("send message")),
            ]),
      ),
    );
  }
}
