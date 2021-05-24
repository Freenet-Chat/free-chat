import 'package:free_chat/src/fcp/rules/rules.dart';

import '../fcp.dart';

class RuleDataFound extends Rule {
  RuleDataFound() : super("DataFound");

  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    var ident = msg.getField('Identifier');

    if (fcpMessageHandler.identifiers.contains(ident)) return;
    fcpConnection.sendFcpMessage(FcpGetRequestStatus(ident, global: true));
    fcpMessageHandler.identifiers.add(ident);
  }
}