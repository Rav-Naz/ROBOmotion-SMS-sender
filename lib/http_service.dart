import 'message_model.dart';
import 'dart:convert';
import 'package:http/http.dart';

class HttpService {
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'secret': 'sVd8h88mCNWzdk7MKdTwSGb3sBPVAjbH'
  };
  final String url = "https://api.robomotion.com.pl/";

  Future<List<Message>> getMessages() async {
    Response res = await get(Uri.parse(url + 'device/getRecipients'), headers: requestHeaders);

    if(res.statusCode == 200) {
      Map<String, dynamic> map = json.decode(res.body);
      List<dynamic> data = map["body"];
      List<Message> messages = data.map((dynamic item) => Message.fromJson(item)).toList();
      return messages;
    } else {
      throw "Can't get messages";
    }
  }

  Future<bool> confirmSendMessage(int wiadomosc_id) async {
    print(wiadomosc_id);
    Response res = await post(Uri.parse(url + 'device/confirmSendMessage'),
        body: json.encode({'wiadomosc_id': wiadomosc_id}),
        headers: requestHeaders);

    return res.statusCode == 200;
  }
}