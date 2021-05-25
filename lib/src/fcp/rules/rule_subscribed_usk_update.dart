import 'package:free_chat/src/fcp/rules/rules.dart';
import 'package:uuid/uuid.dart';

import '../fcp.dart';

/// Implements a Rule which gets handled by the [FcpMessageHandler]
///
/// Extends [Rule] to have a Key and an [act] function which gets called by the
/// message handler on incoming message
///
/// Handles incoming SubscribedUSKUpdate Message
/// https://github.com/freenet/wiki/wiki/FCPv2-SubscribedUSKUpdate
class RuleSubscribedUSKUpdate extends Rule {
  RuleSubscribedUSKUpdate() : super("SubscribedUSKUpdate");

  /// On incoming SubscribedUSKUpdate get the newst data of the USk key
  ///
  /// [fcpMessageHandler] the handling instance
  /// [msg] the incoming SubscribedUSKUpdate message
  /// [fcpConnection] the connection to the freenet
  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    var identifier = Uuid().v4() + "-chat";
    fcpMessageHandler.logger.i("SubscribedUpdate $identifier + ${msg.getField("URI")}");

    FcpClientGet fcpClienteGet = FcpClientGet(msg.getField("URI"),
        identifier: identifier, maxRetries: -1, realTimeFlag: true);

    fcpMessageHandler.identifierToUri[identifier] = msg.getField("URI");

    Future.delayed(Duration(seconds: 10), () => fcpConnection.sendFcpMessage(fcpClienteGet));
  }
}