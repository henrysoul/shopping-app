import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:store/models/http_exception.dart';
// for storage on device
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime expiryDate;
  String userId;
  Timer authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (expiryDate != null &&
        expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get theUserId {
    return userId;
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBcyGD1ugNdhRSscmST2Kikv59J53j6G_g";
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(HttpException(responseData['error']['message']));
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      userId = responseData['localId'];

      // firebaze login comes in wih expirytime in seconds so i will add current time to expiry time to get the expiry time
      expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );

      
        // note i listen to this provider in main.dart material app to know if login or not
      // i wanna auto logout
      autoLogout();
      notifyListeners();
    

      // shared prevefence is an async code that involves working with future
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        // standard date format toIso8601String
        {
          'token': _token,
          'userId': userId,
          'expiryDate': expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);

    } catch (error) {
      throw error;
    }
  }

// auto login
  Future<bool> tryAutoLogin() async {
    print("auto login");
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    // this is a string but i wanna convert it to maps of string key and mixed falues
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final _expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (_expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    userId = extractedUserData['userId'];
    expiryDate = _expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> signup(String email, String password) async {
    // ineed to add return here if not it wont wait for authenticate method
    // check some errors returnd by fireebase i wanna handle it
    return authenticate(email, password, 'signUp');
  }

  Future<void> sigin(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    userId = null;
    expiryDate = null;
    // cancel existing timer
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
  }

  void autoLogout() {
    //  to use the timer import async.dart

    // cancel existing timer
    if (authTimer != null) {
      authTimer.cancel();
    }
    final timeTOExpiry = expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeTOExpiry), logout);
  }
}
