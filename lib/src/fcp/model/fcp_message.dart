import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// The base of every incoming and outgoing FCP message
/// * https://github.com/freenet/wiki/wiki/FCPv2#basic-protocol-syntax
/// Equals an FCPMessage build after the basic protocol syntax.
class FcpMessage {
  /// The name of the message which gets send refer to the wiki
  String _name;

  /// The map of fields which get set individually for each message refer to the
  /// wiki
  Map<String, dynamic> _fields = Map();

  /// Data which gets appended for specific messages like ClientPut
  String data = "";

  /// Constructor of the FcpMessage
  FcpMessage(this._name);

  /// Return the name
  get name => this._name;

  /// Read in a String [content] formatted like
  /// MessageName
  /// Field1=Value1
  /// Field2=Value2
  /// ...
  /// EndMessage
  /// And generate an FCPMessage from it
  FcpMessage.fromString(String content) {
    var contents = content.split("\n");
    this._name = contents.first;
    contents.removeAt(0);
    bool hasData = false;

    for(var con in contents) {
      if(con == "EndMessage") break;
      else if(con == "Data") {
        hasData = true;
        continue;
      }
      else if(hasData) {
        data = con;
        break;
      }
      int idx = con.indexOf('=');
      this.setField(con.substring(0, idx), con.substring(idx+1));
    }
  }

  /// Set a given field [key] with the dynamic [value]
  ///
  /// Return null if no [value] is given
  void setField(String key, dynamic value) {
    if(value == null) return;
    _fields[key] = value;
  }

  /// Return value at [field]
  dynamic getField(String field) {
    return _fields[field];
  }

  /// Format the given [FcpMessage] to look like
  /// MessageName
  /// Field1=Value1
  /// Field2=Value2
  /// ...
  /// EndMessage
  ///
  /// So it can be read by the FCP
  @override toString() {
    String message =
        "$_name\n";
    _fields.forEach((key, value) {
      message = message + "$key=$value\n";
    });
    message +=  data.isEmpty ? "EndMessage\n" : "Data\n$data";

    return message;
  }

  /// Generate a json of the [FcpMessage]
  Map<String, dynamic> toJson() => {
    'name': _name,
    for(var key in _fields.keys)
      key: _fields[key]
  };

  @override
  bool operator == (Object other) {
    return other is FcpMessage &&
    other._name == _name &&
    other.data == data &&
    mapEquals(other._fields, _fields);
  }
  
  @override
  int get hashCode => hashValues(_name, _fields, data);
}