import 'api_key.dart';

/// App constants and configuration
class AppConstants {
  // TMDB API Configuration
  // The API key is imported from api_key.dart (gitignored)
  static const String apiKey = tmdbApiKey;
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
  
  // Image sizes
  static const String posterSize = 'w500';
  static const String backdropSize = 'w780';
  static const String originalSize = 'original';
  
  // API Endpoints
  static const String popularMovies = '/movie/popular';
  static const String searchMovies = '/search/movie';
  static const String genreList = '/genre/movie/list';
  static const String movieDetails = '/movie';
  
  // Storage keys
  static const String favoritesKey = 'favorites';
  static const String watchlistKey = 'watchlist';
  
  // Helper methods
  static String getPosterUrl(String? posterPath) {
    if (posterPath == null || posterPath.isEmpty) {
      return '';
    }
    return '$imageBaseUrl/$posterSize$posterPath';
  }
  
  static String getBackdropUrl(String? backdropPath) {
    if (backdropPath == null || backdropPath.isEmpty) {
      return '';
    }
    return '$imageBaseUrl/$backdropSize$backdropPath';
  }
}
