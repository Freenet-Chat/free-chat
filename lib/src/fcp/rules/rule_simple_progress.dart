import 'package:free_chat/src/fcp/rules/rules.dart';

import '../fcp.dart';

/// Implements a Rule which gets handled by the [FcpMessageHandler]
///
/// Extends [Rule] to have a Key and an [act] function which gets called by the
/// message handler on incoming message
///
/// Handles incoming SimpleProgress Message
/// https://github.com/freenet/wiki/wiki/FCPv2-SimpleProgress
class RuleSimpleProgress extends Rule {
  RuleSimpleProgress() : super("SimpleProgress");

  /// On incoming SimpleProgress update all loading indicators which are connected
  /// to a progress and resend an [FcpGetRequestStatus] message every 10 seconds
  ///
  /// [fcpMessageHandler] the handling instance
  /// [msg] the incoming SimpleProgress message
  /// [fcpConnection] the connection to the freenet
  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    var ident = msg.getField('Identifier');
    fcpMessageHandler.progress[ident] = {
      "Total": msg.getField("Total"),
      "Succeeded": msg.getField("Succeeded")
    };
    if(fcpMessageHandler.allData.contains(ident) || fcpMessageHandler.identifiers.contains(ident)) {
      return;
    }
    Future.delayed(const Duration(seconds: 10), () => fcpConnection.sendFcpMessage(FcpGetRequestStatus(ident, global: true)));
    fcpMessageHandler.notify();
  }
}