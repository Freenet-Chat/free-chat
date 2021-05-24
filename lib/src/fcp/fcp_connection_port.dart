import 'package:free_chat/src/fcp/fcp.dart';

class FcpConnectionPort extends FcpConnection {

  FcpConnectionPort(int port) : super("localhost", port);
}