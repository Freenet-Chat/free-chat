import 'package:free_chat/src/fcp/rules/rules.dart';

import '../fcp.dart';

class RulePutFailed extends Rule {
  RulePutFailed() : super("PutFailed");

  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    fcpMessageHandler.logger.e(msg.toString());
  }
}