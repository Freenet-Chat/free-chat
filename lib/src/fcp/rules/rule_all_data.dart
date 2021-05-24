import 'package:free_chat/src/fcp/rules/rules.dart';
import 'package:free_chat/src/utils/toast.dart';

import '../fcp.dart';

class RuleAllDate extends Rule {
  RuleAllDate() : super("AllData");

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