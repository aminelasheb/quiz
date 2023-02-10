import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:quiz/globals.dart' as globals;
import 'package:http/http.dart' as http;

class question {
  int? id;
  String? text;
  String? trueReply;
  List<String> replies = [];

  question(
      {required this.id, required this.text, required this.trueReply, replies});
}

class Quiz extends ChangeNotifier {
  List<question> questionItems = [];

  Future<void> getQuestions() async {
    print("doingIN1");
    String url = '${globals.ipv4}questions/';
    print("doingIN2");

    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print("doingIN3");

      final result = await jsonDecode(utf8.decode(res.bodyBytes));
      print(result);
      int i = 0;
      for (var element in result) {
        questionItems.add(question(
            id: element['id'],
            text: element['question'],
            trueReply: element['reply'],
            replies: []));

        String s = element['id'].toString();
        final resReplies = await http.get(
          Uri.parse('${globals.ipv4}replies/question/$s'),
          headers: {
            'Content-Type': 'application/json',
          },
        );
        final resultReplies =
            await jsonDecode(utf8.decode(resReplies.bodyBytes));
        for (var reply in resultReplies) {
          questionItems[i].replies.add(reply['reply']);
        }
        i = i + 1;
      }
      print("ss");
      notifyListeners();
      print("done");
    } catch (e) {
      print('error');
      print(e.toString());
      rethrow;
    }
  }
}
