import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:free_chat/src/fcp/rules/rule_collection.dart';
import 'package:free_chat/src/fcp/rules/rule.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/network/messaging.dart';
import 'package:free_chat/src/utils/logger.dart';
import 'package:free_chat/src/utils/toast.dart';

import 'fcp.dart';

class FcpMessageHandler extends ChangeNotifier {
  static final FcpMessageHandler _fcpMessageHandler =
      FcpMessageHandler._internal();

  factory FcpMessageHandler() {
    return _fcpMessageHandler;
  }

  FcpMessageHandler._internal();

  Logger _logger = Logger("FcpMessageHandler");
  get logger => _logger;

  Messaging _messaging = Messaging();
  get messaging => _messaging;

  List<String> _identifiers = [];
  get identifiers => _identifiers;

  List<String> _allData = [];
  get allData => _allData;

  HashMap<String, Map<String, dynamic>> progress = HashMap();

  HashMap<String, String> identifierToUri = HashMap();

  // TODO: Refactor Switch case
  handleMessage(FcpConnection _fcpConnection) {
    var msg = _fcpConnection.fcpMessageQueue.getLastMessage();
    _logger.i(msg.name);
    Rule rule = RuleCollection.ruleMap[msg.name];
    rule.act(this, msg, _fcpConnection);
  }
}