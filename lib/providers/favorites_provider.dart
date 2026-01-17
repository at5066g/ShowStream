import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../services/storage_service.dart';

/// Provider for managing favorites list
class FavoritesProvider extends ChangeNotifier {
  final StorageService _storageService;

  FavoritesProvider({required StorageService storageService})
      : _storageService = storageService;

  List<Movie> _favorites = [];
  List<Movie> get favorites => _favorites;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Initialize by loading favorites from storage
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _storageService.getFavorites();
    } catch (e) {
      debugPrint('Failed to load favorites: $e');
      _favorites = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Check if a movie is in favorites
  bool isFavorite(int movieId) {
    return _favorites.any((m) => m.id == movieId);
  }

  /// Toggle favorite status for a movie
  Future<void> toggleFavorite(Movie movie) async {
    if (isFavorite(movie.id)) {
      await removeFromFavorites(movie);
    } else {
      await addToFavorites(movie);
    }
  }

  /// Add movie to favorites
  Future<void> addToFavorites(Movie movie) async {
    if (!isFavorite(movie.id)) {
      _favorites.add(movie);
      await _storageService.saveFavorites(_favorites);
      notifyListeners();
    }
  }

  /// Remove movie from favorites
  Future<void> removeFromFavorites(Movie movie) async {
    _favorites.removeWhere((m) => m.id == movie.id);
    await _storageService.saveFavorites(_favorites);
    notifyListeners();
  }
}
