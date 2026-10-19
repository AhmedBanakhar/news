# news_app

A new Flutter project.

## Offline news

News requests go through `CachedNewsRepository`. Successful responses are saved
in a local SQLite database using `SqfliteNewsCache`, keyed by category and
search query.
When a request fails because the network is unavailable, the app displays the
saved results for that same category and query. Results are available offline
after they have first been loaded while online. Article titles and descriptions
remain available offline; remote images use a local placeholder when they
cannot be loaded.
The cache uses native SQLite on Android, iOS, and macOS, and SQLite FFI on
Windows and Linux. The current database setup does not support web builds.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
