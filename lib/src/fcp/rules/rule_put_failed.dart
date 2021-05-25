import 'package:free_chat/src/fcp/rules/rules.dart';

import '../fcp.dart';
/// Implements a Rule which gets handled by the [FcpMessageHandler]
///
/// Extends [Rule] to have a Key and an [act] function which gets called by the
/// message handler on incoming message
///
/// Handles incoming PutFailed Message
/// https://github.com/freenet/wiki/wiki/FCPv2-PutFailed
class RulePutFailed extends Rule {
  RulePutFailed() : super("PutFailed");

  /// On incoming PutFailed log the error
  ///
  /// [fcpMessageHandler] the handling instance
  /// [msg] the incoming PutFailed message
  /// [fcpConnection] the connection to the freenet
  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    fcpMessageHandler.logger.e(msg.toString());
  }
}