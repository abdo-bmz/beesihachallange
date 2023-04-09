import 'package:flutter/material.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';

class ApiServiceProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final _pageSize = 10;
  int _currentPage = 0;
  bool _isLoading = false;
  final List<Character> _characters = [];
  List<Character> get characters => _characters;
  bool get isLoading => _isLoading;

  Future<List<Character>> getCharacters(
      {int offset = 0, int limit = 10}) async {
    final characters =
        await _apiService.getCharacters(offset: offset, limit: limit);
    notifyListeners();
    return characters;
  }

  Future<Character> fetchCharacterById(int id) async {
    final character = await _apiService.fetchCharacterById(id);
    notifyListeners();
    return character;
  }

  Future<void> loadCharacters() async {
    _isLoading = true;
    notifyListeners();
    final characters = await _apiService.getCharacters(
        offset: _currentPage * _pageSize, limit: _pageSize);
    _isLoading = false;
    _characters.addAll(characters);
    _currentPage++;
    notifyListeners();
  }
}
