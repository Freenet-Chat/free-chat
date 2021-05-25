import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:free_chat/src/fcp/rules/rule_collection.dart';
import 'package:free_chat/src/fcp/rules/rule.dart';
import 'package:free_chat/src/fcp/rules/rule_simple_progress.dart';
import 'package:free_chat/src/network/messaging.dart';
import 'package:free_chat/src/utils/logger.dart';

import 'fcp.dart';

/// The FcpMessageHandler handles all incoming messages which get passed by the
/// [FcpConnection] via [FcpSocketHandler]
///
/// It calls the ChangeNotifier which start specific callbacks on incoming messages
///
/// Implements a [Rule] set to handle an extandable amount of incoming messages
class FcpMessageHandler extends ChangeNotifier {

  /// The [FcpMessageHandler] as a singleton
  static final FcpMessageHandler _fcpMessageHandler =
      FcpMessageHandler._internal();

  factory FcpMessageHandler() {
    return _fcpMessageHandler;
  }

  FcpMessageHandler._internal();
  ///

  /// The [Logger] instance of the FcpMessagHandler
  Logger _logger = Logger("FcpMessageHandler");
  get logger => _logger;

  /// The messaging instance for specific rules
  Messaging _messaging = Messaging();
  get messaging => _messaging;

  /// A list of all existing identifiers
  List<String> _identifiers = [];
  get identifiers => _identifiers;

  /// A list of AllData fetched
  List<String> _allData = [];
  get allData => _allData;

  void notify() {
    notifyListeners();
  }

  /// Progress map updated via [RuleSimpleProgress] showing the current progress
  /// of upload/download of data
  HashMap<String, Map<String, dynamic>> progress = HashMap();

  /// Maps unique identifiers to Uris
  HashMap<String, String> identifierToUri = HashMap();

  /// Gets called as soon as a new message was added to the [FcpMessageQueue]
  /// And applies a [Rule] accordingly
  handleMessage(FcpConnection _fcpConnection) {
    var msg = _fcpConnection.fcpMessageQueue.getLastMessage();
    _logger.i(msg.name);
    Rule rule = RuleCollection.ruleMap[msg.name];
    rule.act(this, msg, _fcpConnection);
  }
}