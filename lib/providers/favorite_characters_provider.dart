import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';

class FavoritesCharactersProvider extends ChangeNotifier {
  List<Character> _favorites = [];
  List<Character> get favorites => _favorites;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final favorites = <Character>[];
    for (final key in keys) {
      final isFavorite = prefs.getBool(key) ?? false;
      if (isFavorite) {
        final character = await ApiService().fetchCharacterById(int.parse(key));
        favorites.add(character);
      }
    }
    _favorites = favorites;
    notifyListeners();
  }

  Future<void> loadFavoriteStatus(String characterId) async {
    final prefs = await SharedPreferences.getInstance();
    _isFavorite = prefs.getBool(characterId) ?? false;
    notifyListeners();
  }

  Future<void> toggleFavorite(String characterId) async {
    final prefs = await SharedPreferences.getInstance();
    _isFavorite = !_isFavorite;
    await prefs.setBool(characterId, _isFavorite);
    notifyListeners();
  }
}
