import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

const String apiKey = 'AIzaSyB2yHMXlMpRTfj8T3SG3IiZh4-WDqbxLzc';

class Auth extends ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      {String email, String password, String urlString}) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlString?key=$apiKey';

    try {
      var response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      Map responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        int code = responseData['error']['code'];
        String message = responseData['error']['message'];
        throw HTTPException('ERROR $code: $message');
      }
      _token = responseData['idToken'];
      _expiryDate = DateTime.now().add(Duration(
          seconds: int.parse(json.decode(response.body)['expiresIn'])));
      _userId = responseData['localId'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> singUp({String email, String password}) async {
    const urlString = 'signUp';
    return _authenticate(
        email: email, password: password, urlString: urlString);
  }

  Future<void> login({String email, String password}) async {
    const urlString = 'signInWithPassword';
    return _authenticate(
        email: email, password: password, urlString: urlString);
  }

  void logOut() {
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
  }
}
