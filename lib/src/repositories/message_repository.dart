import 'package:free_chat/src/network/database_handler.dart';
import 'package:free_chat/src/repositories/repository_interface.dart';


import '../model.dart';

/// The MessageRepository handles the communication between application and
/// database
///
/// Implements the [RepositoryInterface]
///
/// Allows to update, insert and select Data of the [MessageRepository]
class MessageRepository implements RepositoryInterface<MessageDTO> {
  /// Initialize MessageRepository as singleton
  static final MessageRepository _messageRepository = MessageRepository._internal();

  factory MessageRepository() {
    return _messageRepository;
  }

  MessageRepository._internal();
  ///

  final DatabaseHandler _databaseHandler = DatabaseHandler();

  /// Upsert (Update or Insert) a given [MessageDTO]
  ///
  /// if a Message with the same id as [message] was found in the database
  /// update the current entry else insert [message] as a new entry
  ///
  /// Return the [message] on success
  Future<MessageDTO> upsert(MessageDTO message) async {
    if (message.id == null) {
      message.id = await _databaseHandler.database.insert("message", message.toMap());
    } else {
      await _databaseHandler.database.update(
          "message", message.toMap(), where: "id = ?", whereArgs: [message.id]);
    }

    return message;
  }

  /// Fetch a [MessageDTO] at a given [id]
  ///
  /// Returns the [message] on successful fetch
  Future<MessageDTO> fetch(int id) async {
    List<Map> results = await _databaseHandler.database.query(
        "message", columns: MessageDTO.columns,
        where: "id = ?",
        whereArgs: [id]);

    MessageDTO message = MessageDTO.fromMap(results[0]);

    return message;
  }
  Future<List<MessageDTO>> fetchAllMessagesByChat(int chatId) async {
    List<Map> results = await _databaseHandler.database.rawQuery(
        "SELECT * FROM message WHERE chatId = ? ORDER BY timestamp ASC", [chatId]);

    List<MessageDTO> messages;

    for(var res in results) {
      MessageDTO messageDTO = MessageDTO.fromMap(res);
      messages.add(messageDTO);
    }

    return messages;
  }
}