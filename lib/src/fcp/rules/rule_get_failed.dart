import 'package:free_chat/src/fcp/rules/rules.dart';

import '../fcp.dart';

class RuleGetFailed extends Rule {
  RuleGetFailed() : super("GetFailed");

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