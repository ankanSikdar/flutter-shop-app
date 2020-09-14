import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

const String apiKey = 'AIzaSyB2yHMXlMpRTfj8T3SG3IiZh4-WDqbxLzc';

class Auth extends ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  String _refreshToken;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    return _token;
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
      _refreshToken = responseData['refreshToken'];
      _autoRefreshIdsTimer();
      notifyListeners();

      SharedPreferences preferences = await SharedPreferences.getInstance();
      Map<String, dynamic> userData = {
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String(),
        'userId': _userId,
        'refreshToken': _refreshToken,
      };
      preferences.setString('userData', json.encode(userData));
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

  Future<bool> isAutoLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> userData =
        json.decode(preferences.getString('userData'));
    if (userData == null) {
      return false;
    }
    if (DateTime.now().isAfter(DateTime.parse(userData['expiryDate']))) {
      return false;
    }
    _token = userData['token'];
    _expiryDate = DateTime.parse(userData['expiryDate']);
    _userId = userData['userId'];
    _refreshToken = userData['refreshToken'];
    _autoRefreshIdsTimer();
    notifyListeners();
    return true;
  }

  void logOut() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    _authTimer = null;
    _refreshToken = null;
    notifyListeners();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  Future<void> refreshIds() async {
    String url = 'https://securetoken.googleapis.com/v1/token?key=$apiKey';
    try {
      var response = await http.post(url,
          body: json.encode({
            'grant_type': 'refresh_token',
            'refresh_token': _refreshToken,
          }));
      var responseData = json.decode(response.body);
      if (responseData['error'] == null) {
        _token = responseData['id_token'];
        _expiryDate = DateTime.now().add(Duration(
            seconds: int.parse(json.decode(response.body)['expires_in'])));
        _userId = responseData['user_id'];
        _refreshToken = responseData['refresh_token'];
        _autoRefreshIdsTimer();
        notifyListeners();
      } else {
        logOut();
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void _autoRefreshIdsTimer() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    Duration timeToExpiry = _expiryDate.difference(DateTime.now());
    _authTimer =
        Timer(Duration(seconds: timeToExpiry.inSeconds - 60), refreshIds);
  }
}
