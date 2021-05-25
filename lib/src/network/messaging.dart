import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:free_chat/src/controller/chat_controller.dart';
import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/network/networking.dart';
import 'package:free_chat/src/repositories/chat_repository.dart';
import 'package:free_chat/src/repositories/message_repository.dart';
import 'package:free_chat/src/utils/logger.dart';
import 'package:free_chat/src/utils/converter.dart';

/// Messaging is a class used as a wrapper around the sendMessage functions
/// of the [Networking] class
///
/// It is called via [ChatController]s [sendMessage] function
class Messaging extends ChangeNotifier {

  /// Messaging as a singleton
  static final Messaging _messaging = Messaging._internal();

  factory Messaging() {
    return _messaging;
  }

  Messaging._internal();
  ///

  final Logger _logger = Logger("Messaging");

  final Networking _networking = Networking();



  /// Sends a message to another user
  ///
  /// [chat] is the Chat the [message] gets send to
  /// Updates the [ChatDTO] datanase with the new message
  Future<void> sendMessage(ChatDTO chat, Message message) async {

    MessageDTO messageDTO = MessageDTO.fromMessage(message);
    messageDTO.chatId = chat.id;
    messageDTO.messageTyp = "sender";

    await MessageRepository().upsert(messageDTO);

    var messages = (await ChatRepository().fetchChatAndMessages(chat.id)).messages;

    Chat _chat = Chat.fromDTO(chat, messages);

    _networking.sendMessage(chat.insertUri, _chat.toString(), Uuid().v4()).then((value) {
      _logger.i("Send Message Successful");
      messageDTO.status = "sent";
      MessageRepository().upsert(messageDTO).then((value) => notifyListeners());

    });
  }

  /// Updates a chat by an incoming [fcpMessage]
  ///
  /// Creates a [Chat] object out of the [fcpMessages] data and merges ot with
  /// the currently existing chat
  ///
  /// Resolves the deltas by calling [updateMessages]
  Future<void> updateChat(FcpMessage fcpMessage, String requestUri) async {

    String json = Converter.stringToBase64.decode(fcpMessage.data);
    Chat chat = Chat.fromJson(jsonDecode(json), requestUri);

    ChatDTO chatDTO = await ChatRepository().fetchChatBySharedId(chat.sharedId);

    updateMessages(chatDTO, chat);

  }


  /// Merges two chats together to update a chat
  ///
  /// [chatDTO] is the currently outdated chat
  /// [newChat] is the newly fetched chat
  ///
  /// Uses an algorithm O(n^2) to check messages of both chats if there are any
  /// missing insert new messages to resolve deltas
  Future<void> updateMessages(ChatDTO chatDTO, Chat newChat) async {
    List<String> updated = [];
    var oldChat = await ChatRepository().fetchChatAndMessages(chatDTO.id);
    for(Message msg in newChat.messages) {
      bool flag = false;
      for(Message msg2 in oldChat.messages) {
        if(msg.message == msg2.message && msg.getTimestamp() == msg2.getTimestamp() && msg.sender == msg2.sender) {
          flag = true;
          break;
        }
      }
      String checkString = msg.message + msg.messageType + msg.getTimestamp() + msg.sender;
      if(!flag && !updated.contains(checkString)) {
        updated.add(checkString);
        MessageDTO messageDTO = MessageDTO.fromMessage(msg);
        messageDTO.messageTyp = "receiver";
        messageDTO.chatId = chatDTO.id;
        messageDTO.status = "received";
        await MessageRepository().upsert(messageDTO);
        notifyListeners();
      }
    }
  }
}