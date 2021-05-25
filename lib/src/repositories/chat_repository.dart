
import 'package:free_chat/src/network/database_handler.dart';
import 'package:free_chat/src/repositories/message_repository.dart';
import 'package:free_chat/src/repositories/repository_interface.dart';
import 'package:sqflite/sqflite.dart';

import '../model.dart';

/// The ChatRepository handles the communication between application and
/// database
///
/// Implements the [RepositoryInterface]
///
/// Allows to update, insert and select Data of the [ChatRepository]
class ChatRepository implements RepositoryInterface<ChatDTO>{
  /// ChatRepository as a singleton
  static final ChatRepository _chatRepository = ChatRepository._internal();


  factory ChatRepository() {
    return _chatRepository;
  }

  ChatRepository._internal();
  ///

  final DatabaseHandler _databaseHandler = DatabaseHandler();

  /// Upsert (Update or Insert) a given [ChatDTO]
  ///
  /// if a Chat with the same id as [chat] was found in the database
  /// update the current entry else insert [chat] as a new entry
  ///
  /// Return the [chat] on success
  Future<ChatDTO> upsert(ChatDTO chat) async {

    var count = Sqflite.firstIntValue(await _databaseHandler.database.rawQuery(
        "SELECT COUNT(*) FROM chat WHERE insertUri = ?", [chat.insertUri]));
    if (count == 0) {
      chat.id = await _databaseHandler.database.insert("chat", chat.toMap());
    } else {
      await _databaseHandler.database.update("chat", chat.toMap(), where: "insertUri = ?",
          whereArgs: [chat.insertUri]);
    }

    return chat;
  }

  /// Fetch a [ChatDTO] at a given [id]
  ///
  /// Returns the [chat] on successful fetch
  Future<ChatDTO> fetch(int id) async {
    List<Map> results = await _databaseHandler.database.query(
        "chat", columns: ChatDTO.columns, where: "id = ?", whereArgs: [id]);

    ChatDTO chat = ChatDTO.fromMap(results[0]);

    return chat;
  }

  /// Fetch a [ChatDTO] at a given [insertUri]
  ///
  /// Returns the [chat] on successful fetch
  Future<ChatDTO> fetchChatByInsertUri(String insertUri) async {
    List<Map> results = await _databaseHandler.database.query("chat", columns: ChatDTO.columns,
        where: "insertUri = ?",
        whereArgs: [insertUri]);

    if (results.length == 0)
      return null;

    ChatDTO chat = ChatDTO.fromMap(results[0]);

    return chat;
  }

  /// Fetch a [ChatDTO] at a given [sharedId]
  ///
  /// Returns the [chat] on successful fetch
  Future<ChatDTO> fetchChatBySharedId(String sharedId) async {
    List<Map> results = await _databaseHandler.database.query("chat", columns: ChatDTO.columns,
        where: "sharedId = ?",
        whereArgs: [sharedId]);

    if (results.length == 0)
      return null;

    ChatDTO chat = ChatDTO.fromMap(results[0]);

    return chat;
  }

  /// Fetch a [ChatDTO] at a given [requestUri]
  ///
  /// Returns the [chat] on successful fetch
  Future<ChatDTO> fetchChatByRequestUri(String requestUri) async {
    List<Map> results = await _databaseHandler.database.query("chat", columns: ChatDTO.columns,
        where: "requestUri LIKE ?",
        whereArgs: [
          "${requestUri.split("/")[0]}%"
        ]);

    if (results.length == 0)
      return null;

    ChatDTO chat = ChatDTO.fromMap(results[0]);

    return chat;
  }

  /// Fetch a [Chat] at a given [id] and fill it with messages
  ///
  /// Returns a [chat] with all corresponding [message]s on succesful fetch
  Future<Chat> fetchChatAndMessages(int id) async {
    List<Map> results = await _databaseHandler.database.query(
        "chat", columns: ChatDTO.columns, where: "id = ?", whereArgs: [id]);

    ChatDTO chatDTO = ChatDTO.fromMap(results[0]);

    Chat chat = Chat.fromDTO(chatDTO, []);

    var results2 = await MessageRepository().fetchAllMessagesByChat(id);

    for (var res in results2) {
      Message message = Message.fromDTO(res);
      chat.addMessage(message);
    }

    return chat;
  }

  /// Fetch all existing Chats in the Database
  ///
  /// Return a [List] of [ChatDTO]s
  Future<List<ChatDTO>> fetchAllChats() async {
    List<Map> results2 = await _databaseHandler.database.rawQuery("SELECT * FROM chat");

    List<ChatDTO> chats = [];

    for (var res in results2) {
      ChatDTO chat = ChatDTO.fromMap(res);
      chats.add(chat);
    }
    return chats;
  }
}