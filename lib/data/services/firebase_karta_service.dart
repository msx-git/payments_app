import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/karta.dart';

class FirebaseKartaService {
  final String _apiKey = dotenv.get("WEB_API_KEY");
  final String _baseUrl = dotenv.get('BASE_URL');

  /// FETCH CARDS
  Future<List<Karta>> fetchCards() async {
    final userToken = await _getUserToken();
    Uri url = Uri.parse("$_baseUrl/cards.json?auth=$userToken");

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw (errorData['error']);
      }

      final data = jsonDecode(response.body);
      // debugPrint("RESPONSE DATA: $data");
      List<Karta> cards = [];

      if (data != null) {
        data.forEach((key, value) {
          cards.add(Karta(
            id: key,
            fullName: value['fullName'],
            cardNumber: value['cardNumber'],
            expiryDate: value['expiryDate'],
            balance: value['balance'],
          ));
        });
      }
      return cards;
    } catch (e) {
      rethrow;
    }
  }

  /// GET USER TOKEN
  Future<String> _getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("userData");

    if (userData == null) {
      // redirect to login
      debugPrint("NULL USERDATA: $userData");
    }

    Map<String, dynamic> user = jsonDecode(userData!);
    bool isTokenExpired = DateTime.now().isAfter(
      DateTime.parse(
        user['expiresIn'],
      ),
    );

    if (isTokenExpired) {
      // refresh token
      user = await _refreshToken(user);
      prefs.setString("userData", jsonEncode(user));
    }

    return user['idToken'];
  }

  /// GET NEW TOKEN with REFRESH TOKEN
  Future<Map<String, dynamic>> _refreshToken(Map<String, dynamic> user) async {
    Uri url =
        Uri.parse("https://securetoken.googleapis.com/v1/token?key=$_apiKey");

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "grant_type": "refresh_token",
            "refresh_token": user['refreshToken'],
          },
        ),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw (errorData['error']);
      }

      final data = jsonDecode(response.body);

      user['refreshToken'] = data['refresh_token'];
      user['idToken'] = data['id_token'];
      user['expiresIn'] = DateTime.now()
          .add(
            Duration(
              seconds: int.parse(
                data['expires_in'],
              ),
            ),
          )
          .toString();
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
