import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/fcp/model/fcp_message.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:free_chat/src/fcp/fcp_connection.dart';

import 'fcp_connection_test.mocks.dart';
import 'fcp_test_strings.dart';

@GenerateMocks([Socket])
void main() {
  group('Constructors', () {
    test('Connection should use default host and port', () {
      final FcpConnection connection = FcpConnection();
      expect(connection.host, "localhost");
      expect(connection.port, connection.defaultPort);
    });

    test('Connection should use default host but different port', () {
      final FcpConnection connection = FcpConnection.withPort(1234);
      expect(connection.host, "localhost");
      expect(connection.port, 1234);
    });

    test('Connection should use different host and different port', () {
      final FcpConnection connection = FcpConnection.withHostAndPort("different", 1234);
      expect(connection.host, "different");
      expect(connection.port, 1234);
    });
  });

  group('Message converter', () {
    FcpConnection connection;
    setUp(() {
      connection = FcpConnection();
    });

    test('Should create fcp message out of byte response from Socket', () {
      Iterable<int> fcpBytes = utf8.encode(FcpTestStrings.NodeHello);

      expect(connection.fcpMessageQueue.messageQueue.length, 0);
      connection.dataHandler(fcpBytes);
      expect(connection.fcpMessageQueue.getLastMessage().name, "NodeHello");
    });

    test('Should create fcp message with data out of byte response from Socket', () {
      Iterable<int> fcpBytes = utf8.encode(FcpTestStrings.AllData);

      expect(connection.fcpMessageQueue.messageQueue.length, 0);
      connection.dataHandler(fcpBytes);
      expect(connection.fcpMessageQueue.getLastMessage().name, "AllData");
      expect(connection.fcpMessageQueue.getLastMessage().data, "Hello World");
    });
  });

  group('Write messages', () {
    FcpConnection connection;
    FcpClientGet fcpClientGet;
    FcpMessage fcpMessage;
    Socket socket = MockSocket();

    void simulateMessages() {
        for(var i = 0; i < 5; i++) {
          if(i == 3) connection.fcpMessageQueue.addItemToQueue(fcpMessage);
          else connection.fcpMessageQueue.addItemToQueue(fcpClientGet);
          sleep(Duration(seconds: 1));
        }
      }

    setUp(() {
      connection = FcpConnection();
      connection.socket = socket;
      fcpClientGet = FcpClientGet("testUri", identifier: "testIdentifier");
      fcpMessage = FcpMessage("Hello World!");
      fcpMessage.setField("Identifier", "testIdentifier");

      when(connection.socket.write(any)).thenAnswer((realInvocation) {
        Future(() => simulateMessages());
      });
    });

    test('Should write FcpClientGet message and map the identifier', () async {
      when(connection.socket.write(any)).thenAnswer((realInvocation) {
        expect(realInvocation.positionalArguments.first, fcpClientGet);
      });

      await connection.sendFcpMessage(fcpClientGet);
      var ident = fcpClientGet.getField("Identifier");

      expect(fcpClientGet.getField("URI"), FcpMessageHandler().identifierToUri[ident]);
    });


    test('Should write FcpMessage and wait for a response', () async {
      var response = await connection.sendFcpMessageAndWait(fcpClientGet);
      expect(response, fcpClientGet);
    });


    test('Should write FcpMessage and wait for a specific response', () async {
      var response = await connection.sendFcpMessageAndWaitWithAwaitedResponse(fcpClientGet, fcpMessage.name);
      expect(response, fcpMessage);
    });
  });

}