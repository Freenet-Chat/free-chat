import '../../fcp.dart';
/// Implements GenerateSSK Message of the FCP
/// * https://github.com/freenet/wiki/wiki/FCPv2-GenerateSSK
///
/// Extends [FcpMessage] and takes all the fields mentioned in the wiki.
/// Defaults the non set fields to the defaults value of the message
/// Sets the [fields] and the [name] accordingly.
class FcpGenerateSSK extends FcpMessage {
  FcpGenerateSSK({String identifier}) : super("GenerateSSK") {
    super.setField("Identifier", identifier);
  }
}