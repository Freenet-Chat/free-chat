import 'package:free_chat/src/fcp/rules/rules.dart';

import '../fcp.dart';

/// Implements a Rule which gets handled by the [FcpMessageHandler]
///
/// Extends [Rule] to have a Key and an [act] function which gets called by the
/// message handler on incoming message
///
/// Handles incoming PersistentGet Message
/// https://github.com/freenet/wiki/wiki/FCPv2-PersistentGet
class RulePersistentGet extends Rule {
  RulePersistentGet() : super("PersistentGet");

  /// On incoming PersistentGet do nothing, this is an entry point for future
  /// persistence Checks
  ///
  /// [fcpMessageHandler] the handling instance
  /// [msg] the incoming PersistentGet message
  /// [fcpConnection] the connection to the freenet
  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection) {
    return null;
  }
}