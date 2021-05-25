import 'dart:convert';

import 'package:free_chat/src/utils/converter.dart';

/// An InitialInvite contains all of the information needed for User B to create
/// a chat
class InitialInvite {
  /// Uri to listen to for a response by User B
  String _handshakeUri;

  String _publicKey;

  /// Public URI used to download chats
  String _requestUri;

  /// Name of this client
  String _name;

  /// Encryption key
  String _encryptKey;

  get insertUri => _insertUri;
  String _insertUri;

  get sharedId => _sharedId;
  String _sharedId;

  InitialInvite(this._requestUri, this._handshakeUri, this._name, this._encryptKey, this._insertUri, this._sharedId);

  factory InitialInvite.fromJson(dynamic json) {
    return InitialInvite(json["requestUri"], json["handshakeUri"], json["name"], json["encryptKey"], "", json["sharedId"]);
  }

  /// Convert the context of the invite to base64
  String toBase64() {
    return Converter.stringToBase64.encode(toString());
  }

  /// Read an incoming Base encoded String [base64] convert it to a json string
  /// and create an InitialInvite form it
  factory InitialInvite.fromBase64(String base64) {
    return InitialInvite.fromJson(jsonDecode(Converter.stringToBase64.decode(base64)));
  }

  /// Transform the Object data to a json string
  ///
  /// {
  ///   "sharedId": [_sharedId],
  ///   "requestUri": [_requestUri],
  ///   "handshakeUri": [_handshakeUri],
  ///   "name": [name],
  ///   "encryptKey": [encryptKey]
  /// }
  @override
  String toString() {
    return """
      {"sharedId": "$_sharedId", "requestUri": "$_requestUri", "handshakeUri": "$_handshakeUri", "name": "$_name", "encryptKey": "$_encryptKey"}
    """.trim();
  }

  String getRequestUri() {
    return _requestUri;
  }

  String getPublicKey() {
    return _publicKey;
  }

  String getHandshakeUri() {
    return _handshakeUri;
  }

  String getName() {
    return _name;
  }

  String getIdentifier() {
    return _requestUri.split("/")[1];
  }

  get encryptKey => _encryptKey;


}