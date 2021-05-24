import 'package:free_chat/src/fcp/rules/rules.dart';
import 'package:free_chat/src/utils/toast.dart';

import '../fcp.dart';

class RulePutSuccessful extends Rule {
  RulePutSuccessful() : super("PutSuccessful");

  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    FreeToast.showToast("Upload of one message finished!");
    fcpMessageHandler.identifiers.add(msg.getField('Identifier'));
    fcpMessageHandler.logger.i(msg.toString());
  }
}