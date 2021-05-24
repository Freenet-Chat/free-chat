import 'package:free_chat/src/fcp/fcp.dart';

class FcpConnectionLocal extends FcpConnection {

  static final int defaultPort = 9481;

  FcpConnectionLocal() : super("localhost", defaultPort);
}