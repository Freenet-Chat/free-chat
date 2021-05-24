import 'package:flutter_test/flutter_test.dart';
import 'package:free_chat/src/fcp/fcp.dart';

void main() {
  group('Constructor', ()
  {
    test('Connection should use default host but different port', () {
      int testPort = 1234;
      final FcpConnection connection = FcpConnectionPort(testPort);
      expect(connection.host, "localhost");
      expect(connection.port, testPort);
    });
  });
}