import 'dart:async';
import 'dart:io';

import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/utils/logger.dart';

import 'model/fcp_message.dart';

/// The FcpConnection class handles the connection to the Freenet and communicates
/// via Freenet-Client-Protocol (FCP)
///
/// * https://github.com/freenet/wiki/wiki/FCPv2
class FcpConnection {

  /// The selected port as [int] to connect to
  get port => _port;
  int _port;

  /// The seleected host as [String] to connect to
  get host => _host;
  String _host;

  /// The socket handler, handling incoming data
  /// Refer to [FcpSocketHandler] for more information
  FcpSocketHandler fcpSocketHandler;

  /// The [Logger] instance of the FcpConnection class
  final Logger _logger = Logger("FcpConnection");

  /// The message queue containing all received messages
  /// Refer to [FcpMessageQueue] for more information
  final FcpMessageQueue fcpMessageQueue = FcpMessageQueue();

  /// The specific [FcpMessage] which gets found on
  /// [sendFcpMessageAndWaitWithAwaitedResponse]
  FcpMessage _foundMessage;

  /// The constructor of the class taking in the [host] as a String and the [port]
  /// as an int, setting the values accordingly
  FcpConnection(String host, int port) {
    this._port = port;
    this._host = host;
  }

  /// Connect to the Freenet via [Socket] on the giving [_host] : [_port]
  ///
  /// Set the [socket] of the [fcpSocketHandler] and sets the [onError] and
  /// [onDone] handler of the Socket
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

  /// Send a [message] to the Freenet and don't await any response
  Future<void> sendFcpMessage(FcpMessage message) async {
    _logger.i("Sending message: ${message.toString()}");
    this.fcpSocketHandler.writeSocket(message);
    FcpMessageHandler().identifierToUri[message.getField("Identifier")] = message.getField("URI");
  }

  /// Send a [message] to the Freenet and return the first received message after
  ///
  /// Useful for messages like [FcpGenerateSSK] and [FcpClientHello] which only
  /// reply with a sigle response and not with multiples
  Future<FcpMessage> sendFcpMessageAndWait(FcpMessage message) async {
    this.fcpSocketHandler.writeSocket(message);
    FcpMessageHandler().identifierToUri[message.getField("Identifier")] = message.getField("URI");
    FcpMessage lastMessage = fcpMessageQueue.getLastMessage();

    await waitWhile(() => lastMessage == fcpMessageQueue.getLastMessage());

    return fcpMessageQueue.getLastMessage();
  }

  /// Send a [message] to the freenet and await a specific [awaitedResponse] as
  /// an answer.
  ///
  /// Eg. when sending a [FcpClientGet] and waiting for an [awaitedResponse]
  /// "AllData" the node will reply with multiple messages like
  /// "PersistentGet", "GetRequestStatus", "DataFound", "AllData", etc. only when
  /// "AllData" was found the function finishes and returns the [FcpMessage]
  /// "AllData"
  ///
  /// If optional parameter [errorResponse] is passed the function will also
  /// terminate as soon as the error [FcpMessage] eg. "GetFailed" was received
  Future<FcpMessage> sendFcpMessageAndWaitWithAwaitedResponse(FcpMessage message, String awaitedResponse, {String errorResponse}) async {
    this.fcpSocketHandler.writeSocket(message);
    FcpMessageHandler().identifierToUri[message.getField("Identifier")] = message.getField("URI");

    await waitWhile(() => !(containsMessage(awaitedResponse, message.getField("Identifier"), errorResponse: errorResponse)));

    return _foundMessage;
  }

  /// Checks in the [fcpMessageQueue] if a given message with [type] (or optional
  /// [errorResponse] and [identifier] exists and
  ///
  /// returns a [bool]
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

  /// Async function waiting for an expression [test] to return true used to
  /// terminate the function [sendFcpMessageAndWait]
  /// [sendFcpMessageAndWaitWithAwaitedResponse] only if an message was received
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