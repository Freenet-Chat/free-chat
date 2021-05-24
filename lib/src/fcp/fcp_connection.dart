import 'dart:async';
import 'dart:io';

import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/utils/logger.dart';

import 'model/fcp_message.dart';

class FcpConnection {

  get port => _port;
  int _port;

  get host => _host;
  String _host;

  String response;

  FcpSocketHandler fcpSocketHandler;

  final Logger _logger = Logger("FcpConnection");

  final FcpMessageQueue fcpMessageQueue = FcpMessageQueue();

  FcpMessage _foundMessage;

  FcpConnection(String host, int port) {
    this._port = port;
    this._host = host;
  }

  Future<void> connect() async {
    _logger.i("Connecting to $_host on Port $_port");
    this.fcpSocketHandler = FcpSocketHandler(fcpMessageQueue);
    Socket socket;
    socket = await Socket.connect(_host, _port).then((Socket sock) {
      socket = sock;
      socket.listen(this.fcpSocketHandler.dataHandler,
          onError: this.fcpSocketHandler.errorHandler,
          onDone: this.fcpSocketHandler.doneHandler,
          cancelOnError: false);
      return socket;
    });
    this.fcpSocketHandler.registerSocket(socket);
  }

  Future<void> sendFcpMessage(FcpMessage message) async {
    _logger.i("Sending message: ${message.toString()}");
    this.fcpSocketHandler.writeSocket(message);
    FcpMessageHandler().identifierToUri[message.getField("Identifier")] = message.getField("URI");
  }

  Future<FcpMessage> sendFcpMessageAndWait(FcpMessage message) async {
    this.fcpSocketHandler.writeSocket(message);
    FcpMessageHandler().identifierToUri[message.getField("Identifier")] = message.getField("URI");
    FcpMessage lastMessage = fcpMessageQueue.getLastMessage();

    await waitWhile(() => lastMessage == fcpMessageQueue.getLastMessage());

    return fcpMessageQueue.getLastMessage();
  }

  Future<FcpMessage> sendFcpMessageAndWaitWithAwaitedResponse(FcpMessage message, String awaitedResponse, {String errorResponse}) async {
    this.fcpSocketHandler.writeSocket(message);
    FcpMessageHandler().identifierToUri[message.getField("Identifier")] = message.getField("URI");

    await waitWhile(() => !(containsMessage(awaitedResponse, message.getField("Identifier"), errorResponse: errorResponse)));

    return _foundMessage;
  }

  bool containsMessage(String type, String identifier, {String errorResponse}) {
    bool has = false;
    for(FcpMessage msg in fcpMessageQueue.messageQueue) {
      if((msg.name == type || msg.name == errorResponse ?? "") && msg.getField("Identifier") == identifier) {
        has = true;
        _foundMessage = msg;
      }
    }
    return has;
  }

  Future waitWhile(bool test(), [Duration pollInterval = Duration.zero]) {
    var completer = new Completer();
    check() {
      if (!test()) {
        completer.complete();
      } else {
        new Timer(pollInterval, check);
      }
    }
    check();
    return completer.future;
  }
}