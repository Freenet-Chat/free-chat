import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/fcp/model/fcp_model.dart';

/// The FcpMessageQueue contains all incoming FcpMessages and notifies the
/// [FcpMessageHandler] on incoming messages to handle them
class FcpMessageQueue extends ChangeNotifier {

  /// The list of all received messages during this session
  List<FcpMessage> _messageQueue = [];

  /// Return the list
  get messageQueue => _messageQueue;

  /// Adds an [FcpMessage] [message] to the [_messageQueue] and launches the
  /// listener
  void addItemToQueue(FcpMessage message) {
    _messageQueue.add(message);
    notifyListeners();
  }

  /// Returns the last and most recent message of the [_messageQueue] or null
  /// if queue is empty
  FcpMessage getLastMessage() {
    if(_messageQueue.isEmpty) {
      return null;
    }
    return _messageQueue.last;
  }

  /// Remove item at [index] from the queue
  void removeItemFromQueue(int index) {
    _messageQueue.remove(index);
  }
}