import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../models/genre.dart';
import '../services/api_service.dart';

/// State enum for tracking loading status
enum LoadingState { initial, loading, loaded, error }

/// Provider for managing movie-related state
class MovieProvider extends ChangeNotifier {
  final ApiService _apiService;

  MovieProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // Popular movies
  List<Movie> _popularMovies = [];
  List<Movie> get popularMovies => _popularMovies;

  // Search results
  List<Movie> _searchResults = [];
  List<Movie> get searchResults => _searchResults;

  // Genres map for quick lookup
  Map<int, String> _genresMap = {};
  Map<int, String> get genresMap => _genresMap;

  // Search query
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Loading states
  LoadingState _moviesState = LoadingState.initial;
  LoadingState get moviesState => _moviesState;

  LoadingState _searchState = LoadingState.initial;
  LoadingState get searchState => _searchState;

  // Error message
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Get current movies list based on search state
  List<Movie> get currentMovies =>
      _searchQuery.isNotEmpty ? _searchResults : _popularMovies;

  LoadingState get currentState =>
      _searchQuery.isNotEmpty ? _searchState : _moviesState;

  /// Initialize provider by fetching genres and popular movies
  Future<void> initialize() async {
    await Future.wait([
      fetchGenres(),
      fetchPopularMovies(),
    ]);
  }

  /// Fetch popular movies from API
  Future<void> fetchPopularMovies() async {
    _moviesState = LoadingState.loading;
    notifyListeners();

    try {
      _popularMovies = await _apiService.getPopularMovies();
      _moviesState = LoadingState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _moviesState = LoadingState.error;
    }
    notifyListeners();
  }

  /// Fetch genres from API
  Future<void> fetchGenres() async {
    try {
      final genres = await _apiService.getGenres();
      _genresMap = {for (Genre g in genres) g.id: g.name};
    } catch (e) {
      // Silently fail for genres - not critical
      debugPrint('Failed to fetch genres: $e');
    }
  }

  /// Search movies by query
  Future<void> searchMovies(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _searchResults = [];
      _searchState = LoadingState.initial;
      notifyListeners();
      return;
    }

    _searchState = LoadingState.loading;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchMovies(query);
      _searchState = LoadingState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _searchState = LoadingState.error;
    }
    notifyListeners();
  }

  /// Clear search and show popular movies
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    _searchState = LoadingState.initial;
    notifyListeners();
  }

  /// Get genre names for a movie
  List<String> getGenreNames(List<int> genreIds) {
    return genreIds
        .where((id) => _genresMap.containsKey(id))
        .map((id) => _genresMap[id]!)
        .toList();
  }

  /// Retry fetching movies after error
  Future<void> retry() async {
    if (_searchQuery.isNotEmpty) {
      await searchMovies(_searchQuery);
    } else {
      await fetchPopularMovies();
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
