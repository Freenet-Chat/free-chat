import 'package:free_chat/src/fcp/fcp.dart';
/// Implements WatchGlobal Message of the FCP
/// * https://github.com/freenet/wiki/wiki/FCPv2-WatchGlobal
///
/// Extends [FcpMessage] and takes all the fields mentioned in the wiki.
/// Defaults the non set fields to the defaults value of the message
/// Sets the [fields] and the [name] accordingly.
class FcpWatchGlobal extends FcpMessage{
  FcpWatchGlobal({bool enabled, int verbosityMask}) : super("WatchGlobal") {
    super.setField("Enabled", enabled);
    super.setField("VerbosityMask", verbosityMask);
  }
}