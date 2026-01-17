import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import '../utils/constants.dart';

/// Service class for local storage operations
class StorageService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Favorites operations
  Future<List<Movie>> getFavorites() async {
    final String? data = prefs.getString(AppConstants.favoritesKey);
    if (data == null || data.isEmpty) return [];

    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => Movie.fromJson(json)).toList();
  }

  Future<void> saveFavorites(List<Movie> movies) async {
    final String data = json.encode(movies.map((m) => m.toJson()).toList());
    await prefs.setString(AppConstants.favoritesKey, data);
  }

  Future<void> addToFavorites(Movie movie) async {
    final favorites = await getFavorites();
    if (!favorites.contains(movie)) {
      favorites.add(movie);
      await saveFavorites(favorites);
    }
  }

  Future<void> removeFromFavorites(Movie movie) async {
    final favorites = await getFavorites();
    favorites.removeWhere((m) => m.id == movie.id);
    await saveFavorites(favorites);
  }

  Future<bool> isFavorite(int movieId) async {
    final favorites = await getFavorites();
    return favorites.any((m) => m.id == movieId);
  }

  // Watchlist operations
  Future<List<Movie>> getWatchlist() async {
    final String? data = prefs.getString(AppConstants.watchlistKey);
    if (data == null || data.isEmpty) return [];

    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => Movie.fromJson(json)).toList();
  }

  Future<void> saveWatchlist(List<Movie> movies) async {
    final String data = json.encode(movies.map((m) => m.toJson()).toList());
    await prefs.setString(AppConstants.watchlistKey, data);
  }

  Future<void> addToWatchlist(Movie movie) async {
    final watchlist = await getWatchlist();
    if (!watchlist.contains(movie)) {
      watchlist.add(movie);
      await saveWatchlist(watchlist);
    }
  }

  Future<void> removeFromWatchlist(Movie movie) async {
    final watchlist = await getWatchlist();
    watchlist.removeWhere((m) => m.id == movie.id);
    await saveWatchlist(watchlist);
  }

  Future<bool> isInWatchlist(int movieId) async {
    final watchlist = await getWatchlist();
    return watchlist.any((m) => m.id == movieId);
  }
}
