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

@GenerateMocks([FcpSocketHandler])
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

  group('Write messages', () {
    FcpConnection connection;
    FcpClientGet fcpClientGet;
    FcpMessage fcpMessage;
    FcpSocketHandler fcpSocketHandler = MockFcpSocketHandler();

    void simulateMessages() {
        for(var i = 0; i < 5; i++) {
          if(i == 3) connection.fcpMessageQueue.addItemToQueue(fcpMessage);
          else connection.fcpMessageQueue.addItemToQueue(fcpClientGet);
          sleep(Duration(seconds: 1));
        }
      }

    setUp(() {
      connection = FcpConnection();
      connection.fcpSocketHandler = fcpSocketHandler;
      fcpClientGet = FcpClientGet("testUri", identifier: "testIdentifier");
      fcpMessage = FcpMessage("Hello World!");
      fcpMessage.setField("Identifier", "testIdentifier");

      when(connection.fcpSocketHandler.writeSocket(any)).thenAnswer((realInvocation) {
        Future(() => simulateMessages());
      });
    });

    test('Should write FcpClientGet message and map the identifier', () async {
      when(connection.fcpSocketHandler.writeSocket(any)).thenAnswer((realInvocation) {
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

  group("Contains message", () {
    FcpConnection connection;
    setUp(() {
      connection = FcpConnection();
      connection.fcpMessageQueue.addItemToQueue(FcpClientGet("testUri", identifier: "TestIdentifier"));
    });

    test('Should return true because message queue contains message', () {
      bool contains = connection.containsMessage("ClientGet", "TestIdentifier");
      expect(contains, true);
    });


    test('Should return false because message queue doesn\'t contain message', () {
      bool contains = connection.containsMessage("ClientPut", "TestIdentifier");
      expect(contains, false);
    });
  });

}