import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/genre.dart';
import '../utils/constants.dart';

/// Service class for TMDB API calls
class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch popular movies
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _client.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.popularMovies}?api_key=${AppConstants.apiKey}&page=$page',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load popular movies: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Search movies by query
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    if (query.isEmpty) return [];

    try {
      final response = await _client.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.searchMovies}?api_key=${AppConstants.apiKey}&query=${Uri.encodeComponent(query)}&page=$page',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to search movies: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Fetch all movie genres
  Future<List<Genre>> getGenres() async {
    try {
      final response = await _client.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.genreList}?api_key=${AppConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final genres = data['genres'] as List<dynamic>;
        return genres.map((json) => Genre.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load genres: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  /// Fetch movie details by ID
  Future<Movie> getMovieDetails(int movieId) async {
    try {
      final response = await _client.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.movieDetails}/$movieId?api_key=${AppConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Movie details endpoint returns genres as objects, not IDs
        final genreIds = (data['genres'] as List<dynamic>?)
                ?.map((g) => g['id'] as int)
                .toList() ??
            [];
        data['genre_ids'] = genreIds;
        return Movie.fromJson(data);
      } else {
        throw ApiException('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
