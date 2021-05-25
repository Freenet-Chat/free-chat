import 'package:free_chat/src/fcp/rules/rules.dart';

import '../fcp.dart';

/// Implements a Rule which gets handled by the [FcpMessageHandler]
///
/// Extends [Rule] to have a Key and an [act] function which gets called by the
/// message handler on incoming message
///
/// Handles incoming PersistentPut Message
/// https://github.com/freenet/wiki/wiki/FCPv2-PersistentPut
class RulePersistentPut extends Rule {
  RulePersistentPut() : super("PersistentPut");

  /// On incoming PersistentPut do nothing, this is an entry point for future
  /// persistence Checks
  ///
  /// [fcpMessageHandler] the handling instance
  /// [msg] the incoming PersistentPut message
  /// [fcpConnection] the connection to the freenet
  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection) {
    return null;
  }
}