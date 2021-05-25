import 'package:free_chat/src/fcp/rules/rules.dart';
import 'package:free_chat/src/utils/toast.dart';

import '../fcp.dart';
/// Implements a Rule which gets handled by the [FcpMessageHandler]
///
/// Extends [Rule] to have a Key and an [act] function which gets called by the
/// message handler on incoming message
///
/// Handles incoming PutSuccessful Message
/// https://github.com/freenet/wiki/wiki/FCPv2-PutSuccessful
class RulePutSuccessful extends Rule {
  RulePutSuccessful() : super("PutSuccessful");

  /// On incoming PutSuccessful notify the user about the successfully send
  /// message and save it
  ///
  /// [fcpMessageHandler] the handling instance
  /// [msg] the incoming PutSuccessful message
  /// [fcpConnection] the connection to the freenet
  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    FreeToast.showToast("Upload of one message finished!");
    fcpMessageHandler.identifiers.add(msg.getField('Identifier'));
    fcpMessageHandler.logger.i(msg.toString());
  }
}