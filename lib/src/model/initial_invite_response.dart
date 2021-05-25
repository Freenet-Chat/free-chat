import 'dart:convert';

import 'package:free_chat/src/model/initial_invite.dart';
import 'package:free_chat/src/utils/converter.dart';

/// An InitialInviteResponse is the answer to a received InitialInvite and
/// contains the needed information for the other user to create the chat
///
/// Similiar functionalities to [InitialInvite]
class InitialInviteResponse {

  get requestUri => _requestUri;
  String _requestUri;

  get name => _name;
  String _name;

  InitialInviteResponse(this._requestUri, this._name);


  factory InitialInviteResponse.fromJson(dynamic json) {
    return InitialInviteResponse(json["requestUri"], json["name"]);
  }

  @override
  String toString() {
    return '{"requestUri": "$_requestUri", "name": "$_name"}';
  }

  String toBase64() {
    return Converter.stringToBase64.encode(toString());
  }
  factory InitialInviteResponse.fromBase64(String base64) {
    return InitialInviteResponse.fromJson(jsonDecode(Converter.stringToBase64.decode(base64)));
  }

}