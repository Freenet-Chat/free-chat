import 'dart:async';
import 'dart:io';
import 'package:free_chat/src/utils/logger.dart';

import 'fcp.dart';

/// The FcpSocketHandler used by the [socket] in the [FcpConnection] class
///
/// Used to handle the input stream of the socket and write messages to the socket
class FcpSocketHandler {

  FcpMessageQueue _fcpMessageQueue;

  Socket _socket;

  final Logger _logger = Logger("FcpDataHandler");

  FcpSocketHandler(FcpMessageQueue fcpMessageQueue) {
    this._fcpMessageQueue = fcpMessageQueue;
  }

  void registerSocket(Socket socket) {
    this._socket = socket;
  }

  void writeSocket(FcpMessage message) {
    this._socket.write(message);
  }

  void doneHandler() {
    this._socket.destroy();
  }

  /// Format and transform an incoming byte stream [data] to a [FcpMessage] and
  /// return it
  void dataHandler(data) {

    FcpMessage fcpMessage;

    String msg = new String.fromCharCodes(data).trim();
    bool flag = false;
    for(var line in msg.split("\n")) {
      if (line == null) {
        this._fcpMessageQueue.addItemToQueue(fcpMessage);
        break;
      }
      if (flag) {

        fcpMessage.data = line;
        this._fcpMessageQueue.addItemToQueue(fcpMessage);
        fcpMessage = null;

        flag = false;
        continue;
      }
      if (line.length == 0) {
        continue;
      }
      line = line.trim();
      if (fcpMessage == null) {
        fcpMessage = new FcpMessage(line);
        continue;
      }
      if (line.toLowerCase() == "EndMessage".toLowerCase()) {
        //fcpConnection.handleMessage(fcpMessage);

        this._fcpMessageQueue.addItemToQueue(fcpMessage);
        fcpMessage = null;
      }
      if("Data".toLowerCase() == line.toLowerCase()) {
        flag = true;
      }
      int equalSign = line.indexOf('=');
      if (equalSign == -1) {
        continue;
      }
      String field = line.substring(0, equalSign);
      String value = line.substring(equalSign + 1);
      assert(fcpMessage != null);
      fcpMessage.setField(field, value);
    }
  }

  /// Log an [error] send by the [_socket]
  AsyncError errorHandler(Object error, StackTrace trace) {
    _logger.e(error);
    return null;
  }


}