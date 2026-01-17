import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/storage_service.dart';
import 'providers/movie_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/watchlist_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();
  
  runApp(MovieApp(storageService: storageService));
}

class MovieApp extends StatelessWidget {
  final StorageService storageService;
  
  const MovieApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(storageService: storageService)
            ..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => WatchlistProvider(storageService: storageService)
            ..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'MovieHub',
        debugShowCheckedModeBanner: false,
        theme: _buildDarkTheme(),
        home: const SplashScreen(),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final baseTheme = ThemeData.dark();
    
    // Custom dark color - used for surfaces
    const surfaceColor = Color(0xFF0F0F1A);
    const surfaceVariant = Color(0xFF1A1A2E);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF6366F1), // Indigo
        secondary: Color(0xFFA855F7), // Purple
        surface: surfaceColor,
        surfaceVariant: surfaceVariant,
        background: surfaceColor,
        error: Color(0xFFEF4444),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: surfaceColor,
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceVariant,
        indicatorColor: const Color(0xFF6366F1).withOpacity(0.2),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6366F1),
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(
              color: Color(0xFF6366F1),
              size: 24,
            );
          }
          return IconThemeData(
            color: Colors.white.withOpacity(0.6),
            size: 24,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF6366F1),
          side: const BorderSide(color: Color(0xFF6366F1)),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        hintStyle: GoogleFonts.inter(
          color: Colors.white.withOpacity(0.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceVariant,
        contentTextStyle: GoogleFonts.inter(
          color: Colors.white,
        ),
        actionTextColor: const Color(0xFF6366F1),
      ),
    );
  }
}
