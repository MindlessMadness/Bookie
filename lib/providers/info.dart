import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Info with ChangeNotifier {
  final String token, userId;
  Info(this.token, this.userId);

  List<dynamic> _keys = [];
  List<dynamic> _available = [];
  List<dynamic> _userBooks = [];
  List<dynamic> _userRequests = [];
  List<dynamic> _requestKeys = [];

  List<dynamic> get available {
    return [..._available];
  }

  List<dynamic> get keys {
    return [..._keys];
  }

  List<dynamic> get requestKeys {
    return [..._requestKeys];
  }

  List<dynamic> get userBooks {
    return [..._userBooks];
  }

  List<dynamic> get userRequests {
    return [..._userRequests];
  }

  Future<void> getAvailable() async {
    try {
      print(userId);
      var response = await http.get(Uri.parse(
          "https://bookie-13994-default-rtdb.firebaseio.com/available.json"));
      _available = json.decode(response.body).values.toList();
      _keys = json.decode(response.body).keys.toList();
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> getUserBooks() async {
    try {
      var response = await http.get(Uri.parse(
          "https://bookie-13994-default-rtdb.firebaseio.com/userbooks/$userId.json"));
      var body = json.decode(response.body);
      if (body != null) {
        _userBooks = body["error"] != null ? [] : body.values.toList();
      } else {
        _userBooks = [];
      }
      print(userBooks);
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> addBookToAvailable(title, genre, desc) async {
    try {
      var body = {
        "desc": desc,
        "genre": genre,
        "title": title,
        "owned": false,
        "owner": userId
      };
      var payload = json.encode(body);
      var response = await http.post(
          Uri.parse(
              "https://bookie-13994-default-rtdb.firebaseio.com/available.json"),
          body: payload);
      var response2 = await http.post(
          Uri.parse(
              "https://bookie-13994-default-rtdb.firebaseio.com/userbooks/$userId.json"),
          body: payload);
      print(json.decode(response.body));
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> requestABook(desc, genre, title, owner, owned, key) async {
    try {
      var body = {
        "desc": desc,
        "genre": genre,
        "title": title,
        "owned": owned,
        "owner": owner,
        "key": key
      };
      var payload = json.encode(body);
      var response = await http.post(
          Uri.parse(
              "https://bookie-13994-default-rtdb.firebaseio.com/requests/$userId.json"),
          body: payload);
      var response2 = await http.delete(
        Uri.parse(
            "https://bookie-13994-default-rtdb.firebaseio.com/available/$key.json"),
      );
      print(json.decode(response.body));
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> cancelRequest(desc, genre, title, owner, owned, key) async {
    try {
      var body = {
        "desc": desc,
        "genre": genre,
        "title": title,
        "owned": owned,
        "owner": owner,
        "key": key
      };
      print(userRequests.indexWhere(
        (element) => element["key"] == key,
      ));
      var body2 = {
        "desc": desc,
        "genre": genre,
        "title": title,
        "owned": owned,
        "owner": owner,
      };
      var payload = json.encode(body2);
      var requestKey = requestKeys[userRequests.indexWhere(
        (element) => element["key"] == key,
      )];
      var response = await http.delete(Uri.parse(
          "https://bookie-13994-default-rtdb.firebaseio.com/requests/$userId/$requestKey.json"));
      var response2 = await http.post(
          Uri.parse(
              "https://bookie-13994-default-rtdb.firebaseio.com/available.json"),
          body: payload);
      print(json.decode(response.body));
      print(json.decode(response2.body));
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> getUserRequests() async {
    try {
      var response = await http.get(Uri.parse(
          "https://bookie-13994-default-rtdb.firebaseio.com/requests/$userId.json"));
      var body = json.decode(response.body);
      if (body != null) {
        _userRequests = body["error"] != null ? [] : body.values.toList();
        _requestKeys = body["error"] != null ? [] : body.keys.toList();
      } else {
        _userRequests = [];
        _requestKeys = [];
      }
      print(_userRequests);
      print(_requestKeys);
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }
}
