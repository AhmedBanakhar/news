import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:news_app/services/news_database_factory.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/services/news_services.dart';
import 'package:news_app/services/sqflite_news_cache.dart';
import 'package:news_app/views/welcome_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseFactory = getNewsDatabaseFactory();
  final appDirectory = await getApplicationSupportDirectory();
  final cache = await SqfliteNewsCache.open(
    databaseFactory: databaseFactory,
    path: path.join(appDirectory.path, 'news_app.db'),
  );
  final repository = CachedNewsRepository(
    remoteDataSource: NewsServices(
      Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ),
    ),
    cache: cache,
  );
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repository});

  final NewsRepository repository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F5F0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC58A4A),
          surface: const Color(0xFFF7F5F0),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F5F0),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: WelcomeView(repository: repository),
    );
  }
}
