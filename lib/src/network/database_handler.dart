import 'dart:io';

import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/utils/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// The DatabaseHandler establishes the connection to the sqlite Database
/// for multiple platforms
class DatabaseHandler {

  /// Initialize [DatabaseHandler] as a singleton
  static final DatabaseHandler _databaseHandler = DatabaseHandler._internal();


  factory DatabaseHandler() {
    return _databaseHandler;
  }

  DatabaseHandler._internal();
  ///

  static final Logger _logger = Logger("DatabaseHandler");

  get database => _database;
  Database _database;

  /// Initialize a Database with the given [databaseName]
  ///
  /// Check if the platform is mobile eg. Android or iOS to use the mobile
  /// sqflite package or a desktop application to use sfliteFfiInit
  ///
  /// Creates a chat [ChatDTO] and message [MessageDTO] table
  Future<void> initializeDatabase(String databaseName) async {
    _logger.i("Initializing Database");

    String createChat = "CREATE TABLE chat(id INTEGER PRIMARY KEY, insertUri TEXT, requestUri TEXT, encryptKey TEXT, name TEXT, sharedId TEXT)";
    String createMessage = "CREATE TABLE message(id INTEGER PRIMARY KEY, sender TEXT, message TEXT, status TEXT, timestamp TEXT, chatId INTEGER, messageType TEXT, FOREIGN KEY (chatId) REFERENCES Chat (id) ON DELETE NO ACTION ON UPDATE NO ACTION)";

    if(Platform.isAndroid || Platform.isIOS) {
      _database = await openDatabase(
        join(await getDatabasesPath(), '$databaseName.db'),
        onCreate: (db, version) {
          return Future.wait([
            db.execute(
                createChat
            ),
            db.execute(
                createMessage
            )
          ]);
        },
        version: 1,
      );
    }
    else {
      sqfliteFfiInit();

      var databaseFactory = databaseFactoryFfi;

      _database = await databaseFactory.openDatabase(inMemoryDatabasePath);

      await _database.execute("$createChat");
      await _database.execute("$createMessage");
    }
  }
}