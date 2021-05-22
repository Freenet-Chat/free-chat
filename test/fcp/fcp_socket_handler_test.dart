import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:free_chat/src/fcp/fcp.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'fcp_socket_handler_test.mocks.dart';
import 'fcp_test_strings.dart';

@GenerateMocks([FcpMessageQueue])
void main() {
  group('Message converter', () {
    FcpSocketHandler socketHandler;
    FcpMessageQueue fcpMessageQueue = MockFcpMessageQueue();
    FcpMessage target;

    void checkMessage(String message) {
      target = FcpMessage.fromString(message);
      Iterable<int> fcpBytes = utf8.encode(message);

      socketHandler.dataHandler(fcpBytes);
      FcpMessage answer = verify(fcpMessageQueue.addItemToQueue(captureAny)).captured[0] as FcpMessage;
      expect(answer, equals(target));
    }

    setUp(() {
      socketHandler = FcpSocketHandler(fcpMessageQueue);

      when(fcpMessageQueue.addItemToQueue(any)).thenReturn(Null);
    });

    test('Should create fcp message out of byte response from Socket', () {
      String message = FcpTestStrings.NodeHello;
      checkMessage(message);
    });

    test('Should create fcp message with data out of byte response from Socket', () {
      String message = FcpTestStrings.AllData;
      checkMessage(message);
    });
  });
}