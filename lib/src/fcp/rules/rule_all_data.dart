import 'package:free_chat/src/fcp/rules/rules.dart';
import 'package:free_chat/src/utils/toast.dart';

import '../fcp.dart';

/// Implements a Rule which gets handled by the [FcpMessageHandler]
///
/// Extends [Rule] to have a Key and an [act] function which gets called by the
/// message handler on incoming message
///
/// Handles incoming AllData Message
/// https://github.com/freenet/wiki/wiki/FCPv2-AllData
class RuleAllDate extends Rule {
  RuleAllDate() : super("AllData");

  /// On incoming AllData update the Information of the FcpMessageHandler and
  /// show a Toast message of a newly received message
  ///
  /// [fcpMessageHandler] the handling instance
  /// [msg] the incoming AllData message
  /// [fcpConnection] the connection to the freenet
  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    if(fcpMessageHandler.allData.contains(msg.data))
      return;
    fcpMessageHandler.allData.add(msg.data);
    if (msg.getField("Identifier").contains("-chat")) {
      FreeToast.showToast("New message has arrived!");
      fcpMessageHandler.messaging.updateChat(
          msg, fcpMessageHandler.identifierToUri[msg.getField("Identifier")]);
    }
    fcpMessageHandler.identifiers.add(msg.getField('Identifier'));
  }
}