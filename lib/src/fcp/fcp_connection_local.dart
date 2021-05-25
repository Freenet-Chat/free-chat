import 'package:free_chat/src/fcp/fcp.dart';

/// Extension of the [FcpConnection] class
///
/// Constucting the Connection with the default values
///
/// [defaultPort] for Freenet = 9481
/// [defaultHost] localhost
class FcpConnectionLocal extends FcpConnection {

  static final int defaultPort = 9481;

  FcpConnectionLocal() : super("localhost", defaultPort);
}