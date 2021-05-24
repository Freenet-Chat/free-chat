import 'package:free_chat/src/fcp/rules/rules.dart';

import '../fcp.dart';

class RuleProtocolError extends Rule {
  RuleProtocolError() : super("ProtocolError");

  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    fcpMessageHandler.logger.e(msg.toString());
  }
}