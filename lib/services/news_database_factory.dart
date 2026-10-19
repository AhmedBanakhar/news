import 'package:sqflite/sqflite.dart';
import 'news_database_factory_stub.dart'
    if (dart.library.io) 'news_database_factory_native.dart' as platform;

DatabaseFactory getNewsDatabaseFactory() =>
    platform.getNewsDatabaseFactory();
