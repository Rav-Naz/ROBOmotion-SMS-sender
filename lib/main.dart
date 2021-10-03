import 'http_service.dart';
import 'message_model.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ROBO~motion SMS sender',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final HttpService httpService = HttpService();
  final Telephony telephony = Telephony.instance;


  List<Message> messagesToSend = [];
  var isSending = false;
  var messageSended = 0;

  @override
  void initState() {
    Timer.periodic(new Duration(seconds: 5), (timer)  {
      if (isSending && this.messagesToSend.length == 0) {
        httpService.getMessages().then((value) =>
        {
          setState(()  {
            this.messagesToSend =  value;
          }),
          this.sendingMessages()
        });
      }
    });
    super.initState();
  }

  void _switchSending() {
    setState(() {
      this.isSending = !this.isSending;
    });
  }

  void sendingMessages() async {

    var iterations = this.messagesToSend.length.floor();
    this.messagesToSend.sort((b,a) => (a.wiadomosc_id).compareTo(b.wiadomosc_id));
    for (var i = 0; i < iterations; i++)  {
      var mess = this.messagesToSend.removeLast();
      await telephony.sendSms(
          to: mess.numer_telefonu,
          message: mess.tresc);
      await this.httpService.confirmSendMessage(mess.wiadomosc_id);
      setState(() {
        this.messageSended += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ROBO~motion SMS sender"),
      ),
      body: Center(
          child: this.isSending ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(padding: const EdgeInsets.all(20), child: CircularProgressIndicator()),
              Text("Message sended: $messageSended")
            ],
          ) : Text("Start listening to new messages")
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _switchSending,
        tooltip: 'On/off',
        child: this.isSending ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
    );
  }
}
