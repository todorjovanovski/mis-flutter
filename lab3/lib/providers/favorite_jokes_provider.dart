import 'package:flutter/material.dart';

class FavoriteJokesProvider with ChangeNotifier {
  final Set<String> _favoriteJokes = {};

  List<String> get favoriteJokes => _favoriteJokes.toList();

  bool isFavorite(String joke) => _favoriteJokes.contains(joke);

  void toggleFavorite(String joke) {
    if (_favoriteJokes.contains(joke)) {
      _favoriteJokes.remove(joke);
    } else {
      _favoriteJokes.add(joke);
    }
    notifyListeners();
  }
}
