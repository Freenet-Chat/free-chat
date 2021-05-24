import 'package:free_chat/src/network/database_handler.dart';
import 'package:free_chat/src/repositories/repository_interface.dart';
import 'package:free_chat/src/utils/logger.dart';


import '../model.dart';

class MessageRepository implements RepositoryInterface<MessageDTO> {
  static final MessageRepository _messageRepository = MessageRepository._internal();

  final DatabaseHandler _databaseHandler = DatabaseHandler();

  factory MessageRepository() {
    return _messageRepository;
  }

  MessageRepository._internal();

  Future<MessageDTO> upsert(MessageDTO message) async {
    if (message.id == null) {
      message.id = await _databaseHandler.database.insert("message", message.toMap());
    } else {
      await _databaseHandler.database.update(
          "message", message.toMap(), where: "id = ?", whereArgs: [message.id]);
    }

    return message;
  }

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