import 'package:free_chat/src/fcp/rules/rules.dart';

import '../fcp.dart';

/// Implements a Rule which gets handled by the [FcpMessageHandler]
///
/// Extends [Rule] to have a Key and an [act] function which gets called by the
/// message handler on incoming message
///
/// Handles incoming ProtocolError Message
/// https://github.com/freenet/wiki/wiki/FCPv2-ProtocolError
class RuleProtocolError extends Rule {
  RuleProtocolError() : super("ProtocolError");

  /// On incoming ProtocolError log the error so the malformed message can be
  /// detected and fixed
  ///
  /// [fcpMessageHandler] the handling instance
  /// [msg] the incoming ProtocolError message
  /// [fcpConnection] the connection to the freenet
  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    fcpMessageHandler.logger.e(msg.toString());
  }
}