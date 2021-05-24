import 'package:free_chat/src/fcp/rules/rules.dart';
import 'package:uuid/uuid.dart';

import '../fcp.dart';

class RuleSubscribedUSKUpdate extends Rule {
  RuleSubscribedUSKUpdate() : super("SubscribedUSKUpdate");

  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    var identifier = Uuid().v4() + "-chat";
    fcpMessageHandler.logger.i("SubscribedUpdate $identifier + ${msg.getField("URI")}");

    FcpClientGet fcpClienteGet = FcpClientGet(msg.getField("URI"),
        identifier: identifier, maxRetries: -1, realTimeFlag: true);

    fcpMessageHandler.identifierToUri[identifier] = msg.getField("URI");

    Future.delayed(Duration(seconds: 10), () => fcpConnection.sendFcpMessage(fcpClienteGet));
  }
}