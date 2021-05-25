import 'package:free_chat/src/fcp/fcp.dart';

/// Extension of the [FcpConnection] class
///
/// Constucting the Connection with the default host but a given port
///
/// [defaultHost] localhost
class FcpConnectionPort extends FcpConnection {

  FcpConnectionPort(int port) : super("localhost", port);
}