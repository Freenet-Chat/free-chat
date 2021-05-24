
import 'package:flutter_test/flutter_test.dart';
import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/network/networking.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'invite_test.mocks.dart';
import 'networking_test_strings.dart';

@GenerateMocks([FcpConnection])
void main() {
  group('Test networking connection', () {
    Networking networking = Networking();
    setUp(() {
      networking = Networking();

      var mockFcpConnection = MockFcpConnection();

      networking.fcpConnection = mockFcpConnection;

      when(mockFcpConnection.connect()).thenAnswer((realInvocation) => null);
      when(mockFcpConnection.fcpMessageQueue).thenReturn(FcpMessageQueue());
      when(mockFcpConnection.sendFcpMessage(any)).thenAnswer((realInvocation) => null);
    });

    test('Should connect to node and return node information', () async {
      when(networking.fcpConnection.sendFcpMessageAndWait(any)).thenAnswer((realInvocation) => Future(() => FcpMessage.fromString(NetworkingTestStrings.NodeHello)));
      Node node = await networking.connectClient();

      expect(node.getNodeName(), "Fred");
    });

    test('Should update connection status on successful connect', () async {
      when(networking.fcpConnection.sendFcpMessageAndWait(any)).thenAnswer((realInvocation) => Future(() => FcpMessage.fromString(NetworkingTestStrings.NodeHello)));

      await networking.connectClient();
      expect(networking.isConnected(), true);
    });
  });

  group(('Test SSK generation'), () {
    Networking networking = Networking();
    setUp(() {
      networking = Networking();
      var mockFcpConnection = MockFcpConnection();
      networking.fcpConnection = mockFcpConnection;
      when(mockFcpConnection.sendFcpMessageAndWaitWithAwaitedResponse(any, any)).thenAnswer((realInvocation) => Future(() => FcpMessage.fromString(NetworkingTestStrings.SSKKeypair)));
    });

    test('Should generate SSKKeyPair', () async {
      SSKKey sskKey = await networking.getKeys();

      expect(sskKey.getRequestUri(), "freenet:SSK@BnHXXv3Fa43w~~iz1tNUd~cj4OpUuDjVouOWZ5XlpX0,AwUSJG5ZS-FDZTqnt6skTzhxQe08T-fbKXj8aEHZsXM,AQABAAE/");
      expect(sskKey.getInsertUri(), "freenet:SSK@AKTTKG6YwjrHzWo67laRcoPqibyiTdyYufjVg54fBlWr,AwUSJG5ZS-FDZTqnt6skTzhxQe08T-fbKXj8aEHZsXM/");
      expect(sskKey.getAsUskRequestUri(), "USK@BnHXXv3Fa43w~~iz1tNUd~cj4OpUuDjVouOWZ5XlpX0,AwUSJG5ZS-FDZTqnt6skTzhxQe08T-fbKXj8aEHZsXM,AQABAAE/");
      expect(sskKey.getAsUskInsertUri(), "USK@AKTTKG6YwjrHzWo67laRcoPqibyiTdyYufjVg54fBlWr,AwUSJG5ZS-FDZTqnt6skTzhxQe08T-fbKXj8aEHZsXM/");

    });
  });

  group('Test sending and receiving messages', () {
    Networking networking = Networking();
    setUp(() {
      networking = Networking();
      var mockFcpConnection = MockFcpConnection();
      networking.fcpConnection = mockFcpConnection;
    });

    test('Should get a message and decode message', () async {
      when(networking.fcpConnection.sendFcpMessageAndWaitWithAwaitedResponse(any, any, errorResponse: anyNamed('errorResponse'))).thenAnswer((realInvocation) => Future(() => FcpMessage.fromString(NetworkingTestStrings.AllData)));

      FcpMessage message = await networking.getMessage("testUri", "testIdentifier");

      expect(message.name, "AllData");
      expect(message.data, "Hello World!");

    });

    test('Should send a message', () async {
      when(networking.fcpConnection.sendFcpMessageAndWaitWithAwaitedResponse(any, any, errorResponse: anyNamed('errorResponse'))).thenAnswer((realInvocation) => Future(() => FcpMessage.fromString(NetworkingTestStrings.PutSuccessful)));

      FcpMessage message = await networking.sendMessage("testUri", "Hello World!","testIdentifier");

      expect(message.name, "PutSuccessful");
      expect(message.getField("URI"), "CHK@NOSdw7FF88S0HBF2RDgQFGV-S8mruFnO5aHbjP0DVkE,oB8OplZBo9txoHNEKDifFMR34BgOPxSPqv~bNg7YsgM,AAEC--8");

    });
  });
}