import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../services/storage_service.dart';

/// Provider for managing watchlist
class WatchlistProvider extends ChangeNotifier {
  final StorageService _storageService;

  WatchlistProvider({required StorageService storageService})
      : _storageService = storageService;

  List<Movie> _watchlist = [];
  List<Movie> get watchlist => _watchlist;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Initialize by loading watchlist from storage
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _watchlist = await _storageService.getWatchlist();
    } catch (e) {
      debugPrint('Failed to load watchlist: $e');
      _watchlist = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Check if a movie is in watchlist
  bool isInWatchlist(int movieId) {
    return _watchlist.any((m) => m.id == movieId);
  }

  /// Toggle watchlist status for a movie
  Future<void> toggleWatchlist(Movie movie) async {
    if (isInWatchlist(movie.id)) {
      await removeFromWatchlist(movie);
    } else {
      await addToWatchlist(movie);
    }
  }

  /// Add movie to watchlist
  Future<void> addToWatchlist(Movie movie) async {
    if (!isInWatchlist(movie.id)) {
      _watchlist.add(movie);
      await _storageService.saveWatchlist(_watchlist);
      notifyListeners();
    }
  }

  /// Remove movie from watchlist
  Future<void> removeFromWatchlist(Movie movie) async {
    _watchlist.removeWhere((m) => m.id == movie.id);
    await _storageService.saveWatchlist(_watchlist);
    notifyListeners();
  }
}
