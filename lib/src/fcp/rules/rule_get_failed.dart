import 'package:free_chat/src/fcp/rules/rules.dart';

import '../fcp.dart';

/// Implements a Rule which gets handled by the [FcpMessageHandler]
///
/// Extends [Rule] to have a Key and an [act] function which gets called by the
/// message handler on incoming message
///
/// Handles incoming GetFailed Message
/// https://github.com/freenet/wiki/wiki/FCPv2-GetFailed
class RuleGetFailed extends Rule {
  RuleGetFailed() : super("GetFailed");

  /// On incoming GetFailed check for different error codes which can be the
  /// reason for a GetFailed
  ///
  /// * https://github.com/freenet/wiki/wiki/FCPv2-GetFailed#fetch-error-codes
  /// On Code 27 redirect to new url
  /// On Code 28 retry
  /// Else log error message
  ///
  /// [fcpMessageHandler] the handling instance
  /// [msg] the incoming GetFailed message
  /// [fcpConnection] the connection to the freenet
  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    fcpMessageHandler.logger.i(msg.getField("Code"));
    if(msg.getField("Code") == "27") {
      fcpMessageHandler.logger.i("Redirecting to new url");
      FcpClientGet clientGet = FcpClientGet(msg.getField("RedirectURI"), identifier: msg.getField("Identifier"), global: true, persistence: Persistence.forever, realTimeFlag: true);
      fcpConnection.sendFcpMessage(clientGet);
    }
    if(msg.getField("Code") == "28") {
      Future.delayed(const Duration(seconds: 10), () => fcpConnection.sendFcpMessage(FcpClientGet(fcpMessageHandler.identifierToUri[msg.getField("Identifier")],identifier: msg.getField("Identifier"), global: true, persistence: Persistence.forever, realTimeFlag: true)));
    }

    fcpMessageHandler.logger.e(msg.toString() + fcpMessageHandler.identifierToUri[msg.getField("Identifier")]);
  }
}