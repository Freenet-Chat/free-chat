import 'package:free_chat/src/fcp/rules/rules.dart';

import '../fcp.dart';

/// Implements a Rule which gets handled by the [FcpMessageHandler]
///
/// Extends [Rule] to have a Key and an [act] function which gets called by the
/// message handler on incoming message
///
/// Handles incoming DataFound Message
/// https://github.com/freenet/wiki/wiki/FCPv2-DataFound
class RuleDataFound extends Rule {
  RuleDataFound() : super("DataFound");

  /// On incoming DataFound send an [FcpGetRequestStatus] to check if the data
  /// which was found is available to download
  ///
  /// [fcpMessageHandler] the handling instance
  /// [msg] the incoming DataFound message
  /// [fcpConnection] the connection to the freenet
  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    var ident = msg.getField('Identifier');

    if (fcpMessageHandler.identifiers.contains(ident)) return;
    fcpConnection.sendFcpMessage(FcpGetRequestStatus(ident, global: true));
    fcpMessageHandler.identifiers.add(ident);
  }
}