import 'package:free_chat/src/fcp/rules/rules.dart';

import '../fcp.dart';

class RuleSimpleProgress extends Rule {
  RuleSimpleProgress() : super("SimpleProgress");

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
    fcpMessageHandler.notifyListeners();
  }
}