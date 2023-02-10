import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quiz/globals.dart' as globals;

class Auth extends ChangeNotifier {
  String message = "";
  Future<void> signUp(String email, String username, String password) async {
    String url = '${globals.ipv4}/users/';

    var data = jsonEncode({
      "username": username,
      "email": email,
      "password": password,
    });

    try {
      final res = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: data);

      final respond = await jsonDecode(res.body);

      res.statusCode == 200
          ? {
              message = "Authentification réussite",
            }
          : message = respond.toString();
    } catch (e) {
      print(e.toString());
      message = "Authentification échouée";

      rethrow;
    }
  }
}
