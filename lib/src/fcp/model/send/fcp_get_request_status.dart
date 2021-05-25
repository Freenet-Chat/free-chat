import 'package:free_chat/src/fcp/fcp.dart';
/// Implements GetRequestStatus Message of the FCP
/// * https://github.com/freenet/wiki/wiki/FCPv2-GetRequestStatus
///
/// Extends [FcpMessage] and takes all the fields mentioned in the wiki.
/// Defaults the non set fields to the defaults value of the message
/// Sets the [fields] and the [name] accordingly.
///
/// Requires an [identifier] to check the status of
class FcpGetRequestStatus extends FcpMessage {
  FcpGetRequestStatus(String identifier, {bool global, bool onlyData}) : super("GetRequestStatus") {
    super.setField('Identifier', identifier);
    super.setField("Global", global ?? false);
    super.setField("OnlyData", onlyData ?? false);
  }
}