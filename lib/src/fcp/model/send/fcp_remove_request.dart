import '../../fcp.dart';
/// Implements RemoveRequest Message of the FCP
/// * https://github.com/freenet/wiki/wiki/FCPv2-RemoveRequest
///
/// Extends [FcpMessage] and takes all the fields mentioned in the wiki.
/// Defaults the non set fields to the defaults value of the message
/// Sets the [fields] and the [name] accordingly.
///
/// Requires an [identifier] to remove the request at
class FcpRemoveRequest extends FcpMessage {
  FcpRemoveRequest(String identifier, {bool global}) : super("RemoveRequest") {
    super.setField("Identifier", identifier);
    super.setField("Global", global ?? false);
  }
}
