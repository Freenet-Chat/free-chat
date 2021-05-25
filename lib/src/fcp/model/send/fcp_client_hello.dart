import 'package:free_chat/src/fcp/model/fcp_message.dart';
/// Implements a ClientHello Message of the FCP
/// * https://github.com/freenet/wiki/wiki/FCPv2-ClientHello
///
/// Extends [FcpMessage] and takes all the fields mentioned in the wiki.
/// Defaults the non set fields to the defaults value of the message
/// Sets the [fields] and the [name] accordingly.
///
/// Requires a [name]
class FcpClientHello extends FcpMessage {
  FcpClientHello(String name, {String version}) : super("ClientHello") {
    super.setField("Name", name);
    super.setField("ExpectedVersion", version ?? "2.0");
  }
}