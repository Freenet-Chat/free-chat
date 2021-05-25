import 'package:free_chat/src/model.dart';

/// A message contains the for a chat message typical information and is used in
/// every [Chat]
class Message {

  /// The message as [String] of the Message object
  get message => _message;
  String _message;

  /// The timestamp of the message
  String _timestamp;

  /// The sender of the message
  get sender => _sender;
  String _sender;

  /// The type of the message:
  ///
  /// sender - message was send by this user
  /// receiver - message was received from a different user
  get messageType => _messageType;
  String _messageType;

  /// Status of the message:
  ///
  /// sending - Message isn't uploaded to the fcp yet
  ///  sent - Message is uploaded to the fcp
  String status;

  Message(this._message, this._timestamp, this._sender, this._messageType, this.status);

  /// Generate a message from a [dto] out of the database
  factory Message.fromDTO(MessageDTO dto) {
    return Message(dto.message, dto.timestamp, dto.sender, dto.messageTyp, dto.status);
  }

  factory Message.fromJson(dynamic json) {
    return Message(
      json["message"],
      json["timestamp"],
      json["sender"],
      "receiver",
      "received"
    );
  }

  String getMessage() {
    return this._message;
  }

  String getTimestamp() {
    return this._timestamp;
  }

  @override
  String toString() {
    return '{"message": "$_message","timestamp": "$_timestamp", "sender": "$_sender", "messageType": "$_messageType"}';
  }
}