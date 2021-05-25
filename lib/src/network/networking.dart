import 'dart:async';
import 'dart:convert';
import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/fcp/model/persistence.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/utils/converter.dart';
import 'package:free_chat/src/utils/logger.dart';

/// The Networking class implements most of the functionalities of the
/// [FcpConnection] class and offers functions to easily send and receives
/// [FcpMessage]s from given URI as well as to establish a connection to the
/// Freenet
class Networking {

  /// Networking instance as a singleton
  static final Networking _networking = Networking._internal();

  factory Networking() {
    return _networking;
  }

  Networking._internal();
  ///

  static final Logger _logger = Logger(Networking().toString());

  /// Create a [FcpConnection] with default parameters
  FcpConnection fcpConnection = FcpConnectionLocal();

  /// State if the application is connected to the node
  bool _connected = false;

  /// Connect the client to the Freenet
  ///
  /// Call the [connect] Function of the [fcpConnection] and set all kind of handlers
  /// and listeners
  ///
  /// A [FcpClientHello] has to be always the first message send, which also gets
  /// send here
  ///
  /// Initializes further FCP states
  ///
  /// Returns a [Node]
  Future<Node> connectClient() async {

    var _deviceId = Uuid().v4();

    await fcpConnection.connect();

    fcpConnection.fcpMessageQueue.addListener(() => FcpMessageHandler().handleMessage(fcpConnection));

    FcpClientHello clientHello = FcpClientHello(_deviceId);
    var json = await fcpConnection.sendFcpMessageAndWait(clientHello);

    FcpWatchGlobal fcpWatchGlobal = FcpWatchGlobal(enabled: true);

    await fcpConnection.sendFcpMessage(fcpWatchGlobal);

    if(json != null) {
      _connected = true;
    }

    return Node.fromJson(json.toJson());
  }

  /// Returns if the node is connected to the FCP
  bool isConnected() {
    return _connected;
  }

  /// Generate an SSKKey by sending an [FcpGenerateSSK] to the Freenet
  ///
  /// Returns an [SSKKey]
  Future<SSKKey> getKeys() async {
    FcpGenerateSSK fcpGenerateSSK = FcpGenerateSSK(identifier: Uuid().v4());

    FcpMessage response = await fcpConnection.sendFcpMessageAndWaitWithAwaitedResponse(fcpGenerateSSK, "SSKKeypair");

    return SSKKey.fromJson(response.toJson());
  }

  /// Fetch a message at a given uri
  ///
  /// Create a [FcpClientGet] with the given [uri] and [identifier]
  ///
  /// Wait until an [FcpMessage] of type "AllData" is received
  ///
  /// Returns the [FcpMessage] "AllData"
  ///
  /// Throws [Exception] on "GetFailed"
  Future<FcpMessage> getMessage(String uri, String identifier) async {
    FcpClientGet fcpClienteGet = FcpClientGet(uri, identifier: identifier, global: true, persistence: Persistence.forever, realTimeFlag: true);

    FcpMessage t = await fcpConnection.sendFcpMessageAndWaitWithAwaitedResponse(fcpClienteGet, "AllData", errorResponse: "GetFailed");

    if(t.name == "GetFailed") {
      throw Exception(t);
    }

    var data = t.data;
    Converter.stringToBase64.decode(data);

    t.data = Converter.stringToBase64.decode(data);

    return t;
  }

  /// Send Data to the Freenet
  ///
  /// Creates a [FcpClientPut] request with the given [uri], [data] and [identifer]
  /// Uploads it and waits for a "PutSuccessful" response
  ///
  /// Returns the PutSuccesful as a [FcpMessage]
  ///
  /// Throws [Exception] on "PutFailed"
  Future<FcpMessage> sendMessage(String uri, String data, String identifier) async {
    var base64Str = Converter.stringToBase64.encode(data) + "\n";

    FcpClientPut put = FcpClientPut(uri, base64Str, priorityClass: 2, dontCompress: true, identifier: identifier, global: true, persistence: Persistence.forever, dataLength: base64Str.length, metaDataContentType: "", realTimeFlag: true, extraInsertsSingleBlock: 0, extraInsertsSplitfileHeaderBlock: 0);

    _logger.i("Sending message: ${put.toString()}");

    FcpMessage t = await fcpConnection.sendFcpMessageAndWaitWithAwaitedResponse(put, "PutSuccessful", errorResponse: "PutFailed");

    if(t.name == "PutFailed") {
      throw Exception(t);
    }

    _logger.i("Put Status: $t}");

    return t;
  }

  /// Fetches the newest messages for [chatDTO]
  ///
  /// Subscribes to the USK of [chatDTO]
  Future<void> update(ChatDTO chatDTO) async {
    FcpClientGet fcpClienteGet = FcpClientGet(chatDTO.requestUri, identifier: Uuid().v4() + "-chat", realTimeFlag: true, global: true, persistence: Persistence.forever);
    FcpSubscribeUSK fcpSubscribeUSK = FcpSubscribeUSK(chatDTO.requestUri, Uuid().v4());

    fcpConnection.sendFcpMessage(fcpClienteGet);
    fcpConnection.sendFcpMessage(fcpSubscribeUSK);
  }
}