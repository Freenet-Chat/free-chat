import 'package:date_format/date_format.dart';
import 'package:free_chat/src/config.dart';
import 'package:free_chat/src/network/messaging.dart';
import 'package:free_chat/src/utils/logger.dart';
import 'package:free_chat/src/view.dart';

import '../model.dart';

/// A Controller for the chat detail view
/// Should only be used by [ChatsDetail]
class ChatController {
  /// The [ChatController] as a singleton
  static final ChatController _chatController = ChatController._internal();

  factory ChatController() {
    return _chatController;
  }

  ChatController._internal();

  /// The [Logger] of the ChatController
  final Logger _logger = Logger("ChatController");

  /// The [Messaging] instance used to send messages
  final Messaging _messaging = Messaging();

  /// Send a message to the freenet by updating a [ChatDTO] with a text
  ///
  /// Updates [chat] with a current formatted timestamp ([DateTime.now]) and [text] and sends it
  Future<void> sendMessage(ChatDTO chat, String text) async {
    _logger.i("Sending message: $text");

    var timestamp = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);

    Message message = Message(text, timestamp, Config.clientName, "sender", "sending");

    await _messaging.sendMessage(chat, message);
  }
}