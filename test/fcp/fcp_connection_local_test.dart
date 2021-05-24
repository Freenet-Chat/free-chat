import 'package:flutter_test/flutter_test.dart';
import 'package:free_chat/src/fcp/fcp.dart';

void main() {
  group('Constructor', ()
  {
    test('Connection should use default host and port', () {
      final FcpConnection connection = FcpConnectionLocal();
      expect(connection.host, "localhost");
      expect(connection.port, FcpConnectionLocal.defaultPort);
    });
  });
}