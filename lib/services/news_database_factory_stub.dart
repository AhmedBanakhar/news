import 'package:sqflite/sqflite.dart';

DatabaseFactory getNewsDatabaseFactory() {
  throw UnsupportedError('The SQLite news cache is not configured for web.');
}
