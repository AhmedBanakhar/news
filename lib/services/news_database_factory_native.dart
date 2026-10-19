import 'dart:io';

import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

sqflite.DatabaseFactory getNewsDatabaseFactory() {
  if (Platform.isLinux || Platform.isWindows) {
    ffi.sqfliteFfiInit();
    return ffi.databaseFactoryFfi;
  }
  return sqflite.databaseFactory;
}
