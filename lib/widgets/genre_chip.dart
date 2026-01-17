import 'package:flutter/material.dart';

/// Genre chip widget for displaying movie genres
class GenreChip extends StatelessWidget {
  final String genre;
  final bool isSmall;

  const GenreChip({
    super.key,
    required this.genre,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 4 : 6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.2),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        genre,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: isSmall ? 10 : 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
