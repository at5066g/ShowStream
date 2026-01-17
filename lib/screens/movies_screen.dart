import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../providers/watchlist_provider.dart';
import '../widgets/featured_movie_carousel.dart';
import '../widgets/movie_list_section.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import 'movie_details_screen.dart';

/// Movies screen with premium streaming layout
class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() => _isSearchFocused = _searchFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<MovieProvider>().searchMovies(query);
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    context.read<MovieProvider>().clearSearch();
  }

  void _navigateToDetails(movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }

  void _showPlayingNotification(movie) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.play_circle_filled_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Now Playing',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    movie.title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MovieProvider>(
          builder: (context, provider, _) {
            final state = provider.currentState;
            final movies = provider.currentMovies;
            final isSearching = provider.searchQuery.isNotEmpty;

            // Loading state
            if (state == LoadingState.loading && movies.isEmpty) {
              return const LoadingWidget(message: 'Loading movies...');
            }

            // Error state
            if (state == LoadingState.error && movies.isEmpty) {
              return ErrorDisplayWidget(
                message: provider.errorMessage,
                onRetry: () => provider.retry(),
              );
            }

            return Column(
              children: [
                // Glassmorphic Search Bar
                _buildSearchBar(provider),
                // Content
                Expanded(
                  child: isSearching
                      ? _buildSearchResults(movies, provider)
                      : _buildPremiumLayout(movies, provider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar(MovieProvider provider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.fromLTRB(16, 12, 16, _isSearchFocused ? 16 : 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isSearchFocused
                    ? [
                        Theme.of(context).colorScheme.primary.withOpacity(0.15),
                        Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                      ]
                    : [
                        Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withOpacity(0.8),
                        Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withOpacity(0.8),
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isSearchFocused
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                    : Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
              boxShadow: _isSearchFocused
                  ? [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search movies...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                ),
                prefixIcon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.search_rounded,
                    key: ValueKey(_isSearchFocused),
                    color: _isSearchFocused
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
                suffixIcon: provider.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: _clearSearch,
                        color: Colors.white.withOpacity(0.7),
                      )
                    : null,
                filled: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumLayout(List movies, MovieProvider provider) {
    if (movies.isEmpty) {
      return const EmptyWidget(
        icon: Icons.movie_outlined,
        title: 'No movies available',
        subtitle: 'Check back later for new content',
      );
    }

    final watchlistProvider = context.watch<WatchlistProvider>();

    return RefreshIndicator(
      onRefresh: () async {
        await provider.fetchPopularMovies();
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discover',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Find your next favorite movie',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.movie_filter_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Featured Carousel
            FeaturedMovieCarousel(
              movies: movies.cast(),
              onMovieTap: _navigateToDetails,
              onPlayTap: _showPlayingNotification,
              onAddToListTap: (movie) =>
                  watchlistProvider.toggleWatchlist(movie),
            ),
            const SizedBox(height: 28),

            // Popular Section
            MovieListSection(
              title: 'Popular Now',
              movies: movies.length > 5 ? movies.sublist(5).cast() : [],
              onMovieTap: _navigateToDetails,
            ),
            const SizedBox(height: 24),

            // Trending Section (reversed order for variety)
            if (movies.length > 10)
              MovieListSection(
                title: 'Trending This Week',
                movies: movies.reversed.take(10).toList().cast(),
                onMovieTap: _navigateToDetails,
              ),
            const SizedBox(height: 24),

            // All Movies Grid Section Title
            if (movies.length > 15)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Explore More',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ],
                ),
              ),
            if (movies.length > 15) const SizedBox(height: 16),

            // Remaining movies in grid
            if (movies.length > 15)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: (movies.length - 15).clamp(0, 9),
                  itemBuilder: (context, index) {
                    final movie = movies[index + 15];
                    return GestureDetector(
                      onTap: () => _navigateToDetails(movie),
                      child: _buildMiniMovieCard(movie),
                    );
                  },
                ),
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniMovieCard(dynamic movie) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Poster placeholder with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.surfaceVariant,
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
              ),
              child: movie.posterPath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.movie, size: 24),
                      ),
                    )
                  : const Center(child: Icon(Icons.movie, size: 24)),
            ),
            // Bottom gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List movies, MovieProvider provider) {
    if (movies.isEmpty) {
      return EmptyWidget(
        icon: Icons.search_off_rounded,
        title: 'No results found',
        subtitle: 'Try searching with different keywords',
        action: TextButton(
          onPressed: _clearSearch,
          child: const Text('Clear Search'),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () => _navigateToDetails(movie),
          child: _buildMiniMovieCard(movie),
        );
      },
    );
  }
}
