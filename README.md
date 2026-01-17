# ShowStream - Flutter Movie App

A beautiful Flutter movie application that integrates with the TMDB API to browse, search, and manage your favorite movies.

## Features

- 🎬 **Browse Movies** - View popular movies with posters, ratings, and genres
- 🔍 **Search** - Real-time search functionality
- ❤️ **Favourites** - Save your favorite movies (persisted locally)
- 📌 **Watchlist** - Add movies to watch later (persisted locally)
- 🎯 **Movie Details** - View full details including overview, release date, and ratings
- ▶️ **Play Now** - In-app notification when clicking play
- 🌙 **Dark Theme** - Beautiful Material 3 dark theme with purple/indigo accents

## Screenshots

| Splash | Movies | Details |
|--------|--------|---------|
| Animated splash screen | Grid of movie cards with search | Full movie info with rating |

---

## Setup Instructions

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.0.0 or higher)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter extension
- A TMDB API Key (free)

### 1. Clone the Repository

```bash
git clone https://github.com/at5066g/ShowStream.git
cd ShowStream
```

### 2. Get TMDB API Key

1. Create a free account at [TMDB](https://www.themoviedb.org/signup)
2. Go to [API Settings](https://www.themoviedb.org/settings/api)
3. Request an API key (choose "Developer" option)
4. Copy your API key

### 3. Configure API Key

Create the API key file from the template:

```bash
cp lib/utils/api_key.dart.template lib/utils/api_key.dart
```

Edit `lib/utils/api_key.dart` and replace the placeholder with your API key:

```dart
const String tmdbApiKey = 'YOUR_ACTUAL_API_KEY_HERE';
```

> **Important**: The `api_key.dart` file is gitignored to keep your API key private.

### 4. Install Dependencies

```bash
flutter pub get
```

---

## Running the App

### Android

```bash
# Connect Android device or start emulator
flutter run
```

### iOS

```bash
flutter run -d ios
```

### Web (Chrome)

```bash
flutter run -d chrome
```

### Windows

```bash
flutter run -d windows
```

### Build APK

```bash
flutter build apk --debug
```

The APK will be at: `build/app/outputs/flutter-apk/app-debug.apk`

---

## Project Structure

```
lib/
├── main.dart                 # App entry point, providers, theme
├── models/                   # Data models
│   ├── movie.dart
│   └── genre.dart
├── services/                 # API and storage services
│   ├── api_service.dart      # TMDB API integration
│   └── storage_service.dart  # Local storage (SharedPreferences)
├── providers/                # State management (Provider)
│   ├── movie_provider.dart
│   ├── favorites_provider.dart
│   └── watchlist_provider.dart
├── screens/                  # App screens
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── movies_screen.dart
│   ├── movie_details_screen.dart
│   ├── favorites_screen.dart
│   └── watchlist_screen.dart
├── widgets/                  # Reusable components
│   ├── movie_card.dart
│   ├── circular_rating.dart
│   └── ...
└── utils/
    ├── constants.dart        # App constants
    └── api_key.dart          # API key (gitignored)
```

---

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.1 | State management |
| `http` | ^1.1.0 | HTTP client for API calls |
| `shared_preferences` | ^2.2.2 | Local storage for favorites/watchlist |
| `cached_network_image` | ^3.2.3 | Image caching (mobile) |
| `google_fonts` | ^4.0.4 | Custom typography (Inter font) |
| `cupertino_icons` | ^1.0.2 | iOS-style icons |

---

## Assumptions

1. **No Authentication** - The app does not require user login. Favorites and watchlist are stored locally on the device.
2. **Single User** - Storage is device-specific, not synced across devices.
3. **Internet Required** - Movies are fetched from TMDB API; offline mode shows cached images only.
4. **TMDB API v3** - Using the free tier API with standard rate limits.

---

## API Reference

This app uses the [TMDB API v3](https://developer.themoviedb.org/docs):

- `GET /movie/popular` - Fetch popular movies
- `GET /search/movie` - Search movies by title
- `GET /genre/movie/list` - Get genre list
- `GET /movie/{id}` - Get movie details

---

## License

This project is for educational/assignment purposes.

---

## Acknowledgments

- [TMDB](https://www.themoviedb.org/) for the movie data API
- [Flutter](https://flutter.dev/) for the amazing framework
