import 'package:free_chat/src/fcp/model/fcp_message.dart';
/// Implements GetNode Message of the FCP
/// * https://github.com/freenet/wiki/wiki/FCPv2-GetNode
///
/// Extends [FcpMessage] and takes all the fields mentioned in the wiki.
/// Defaults the non set fields to the defaults value of the message
/// Sets the [fields] and the [name] accordingly.
class FcpGetNode extends FcpMessage {
  FcpGetNode({bool withPrivate, bool withVolatile}) : super('GetNode') {
    super.setField("WithPrivate", withPrivate?.toString() ?? false.toString());
    super.setField("WithVolatile", withVolatile?.toString() ?? false.toString());
  }
}