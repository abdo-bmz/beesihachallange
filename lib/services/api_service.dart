import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/character_model.dart';

class ApiService {
  Future<List<Character>> getCharacters(
      {int offset = 0, int limit = 10}) async {
    final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timeStamp);

    final response = await http.get(
      Uri.parse(
          '$kBaseUrl/characters?ts=$timeStamp&apikey=$kPublicKey&hash=$hash&offset=$offset&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['data']['results'] as List<dynamic>;
      return results.map((result) => Character.fromJson(result)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  Future<Character> fetchCharacterById(int id) async {
    final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timeStamp);
    final response = await http.get(Uri.parse(
        '$kBaseUrl/characters/$id?apikey=$kPublicKey&ts=$timeStamp&hash=$hash'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['results'][0];
      return Character.fromJson(data);
    } else {
      throw Exception('Failed to fetch character');
    }
  }

  String generateHash(String timeStamp) {
    final bytes = utf8.encode('$timeStamp$kPrivateKey$kPublicKey');
    final digest = md5.convert(bytes);
    return digest.toString();
  }
}
