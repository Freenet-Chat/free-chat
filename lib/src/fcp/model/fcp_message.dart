import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FcpMessage {
  String _name;

  Map<String, dynamic> _fields = Map();

  String data = "";

  FcpMessage(this._name);

  get name => this._name;

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

  void setField(String key, dynamic value) {
    if(value == null) return;
    _fields[key] = value;
  }

  dynamic getField(String field) {
    return _fields[field];
  }

  @override toString() {
    String message =
        "$_name\n";
    _fields.forEach((key, value) {
      message = message + "$key=$value\n";
    });
    message +=  data.isEmpty ? "EndMessage\n" : "Data\n$data";

    return message;
  }

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