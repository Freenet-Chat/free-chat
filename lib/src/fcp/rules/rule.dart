import 'package:free_chat/src/fcp/fcp.dart';

/// [Rule] defines how an incoming message gets handled by the [FcpMessageHandler]
///
/// This is the base class for all following Rules
class Rule {

  /// The key of the rule also the name of the incoming message which gets
  /// covered by this [Rule]
  String _key;

  /// Set the name of the rule by initializing to [key]
  Rule(String key) {
    this._key = key;
  }

  /// Return the current [_key] of the rule
  String getKey() {
    return this._key;
  }

  /// Performs the given action should be implemented by class which extends
  /// [Rule]
  ///
  /// Takes the [fcpMessageHandler], the incoming [msg] and the [fpcConnection]
  ///
  /// Throws Not Implemented if act gets called on a Rule without this function
  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    throw Exception("Not Implemented");
  }
}