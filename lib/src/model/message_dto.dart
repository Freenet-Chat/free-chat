import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/model/chat_dto.dart';

/// A MessageDTO is a Message Object formatted and ready for insertion into a SQLite
/// Database [sqflite]
///
/// The Attributes are equal to [Message] except of the [id] used locally in the
/// SQLite
class MessageDTO {
  MessageDTO();

  int id;

  get message => _message;
  String _message;

  get timestamp => _timestamp;
  String _timestamp;

  get sender => _sender;
  String _sender;
  int chatId;
  ChatDTO chat;
  String messageTyp;
  String status;

  static final columns = ["id", "message", "timestamp", "chatId", "sender", "messageType", "status"];

  Map toMap() {
    Map<String, Object> map = {
      "message": _message,
      "timestamp": _timestamp,
      "chatId": chatId,
      "sender": sender,
      "messageType": messageTyp,
      "status": status
    };

    if (id != null) {
    map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    MessageDTO messageDTO = new MessageDTO();
    messageDTO.id = map["id"];
    messageDTO._message = map["message"];
    messageDTO._timestamp = map["timestamp"];
    messageDTO.chatId = map["chatId"];
    messageDTO._sender = map["sender"];
    messageDTO.messageTyp = map["messageType"];
    messageDTO.status = map["status"];
    return messageDTO;
  }

  static fromMessage(Message message) {
    MessageDTO messageDTO = new MessageDTO();
    messageDTO._message = message.getMessage();
    messageDTO._timestamp = message.getTimestamp();
    messageDTO._sender = message.sender;
    messageDTO.status = message.status;

    return messageDTO;
  }
}
