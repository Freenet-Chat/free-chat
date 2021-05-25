
import 'package:free_chat/src/fcp/fcp.dart';

/// A SSKKey is a response to a [FcpGenerateSSK]
class SSKKey {

  /// The insert uri used to upload data to
  ///
  /// eg. SSK@abcdfghijk/insertExtra
  String _insertUri;

  /// The request uri used to download data which is shared to someone else
  ///
  /// eg. SSK@abcdfghijk
  String _requestUri;

  SSKKey(this._insertUri, this._requestUri);

  factory SSKKey.fromJson(dynamic json) {
    return SSKKey(json["InsertURI"], json["RequestURI"]);
  }

  String getInsertUri(){
    return _insertUri;
  }

  /// Format the [_insertUri] to an USK key
  ///
  /// USK@abcdfghijk/insertExtra
  String getAsUskInsertUri() {
    return "USK@${_insertUri.split("@")[1]}";
  }

  /// Format the [_requestUri] to an USK key
  ///
  /// USK@abcdfghijk
  String getAsUskRequestUri() {
    return "USK@${_requestUri.split("@")[1]}";
  }

  String getRequestUri() {
    return _requestUri;
  }

}