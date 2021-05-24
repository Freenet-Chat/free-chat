import 'package:free_chat/src/fcp/fcp.dart';

class Rule {
  String _key;

  Rule(String key) {
    this._key = key;
  }

  String getKey() {
    return this._key;
  }

  void act(FcpMessageHandler fcpMessageHandler, FcpMessage msg, FcpConnection fcpConnection){
    // No action
  }
}