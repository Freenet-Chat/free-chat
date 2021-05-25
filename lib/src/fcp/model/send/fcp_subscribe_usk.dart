import 'package:free_chat/src/fcp/fcp.dart';
/// Implements SubscribeUSK Message of the FCP
/// * https://github.com/freenet/wiki/wiki/FCPv2-SubscribeUSK
///
/// Extends [FcpMessage] and takes all the fields mentioned in the wiki.
/// Defaults the non set fields to the defaults value of the message
/// Sets the [fields] and the [name] accordingly.
///
/// Requires an [uri] (USK) to subscribe to and an [identifier]
class FcpSubscribeUSK extends FcpMessage {
  FcpSubscribeUSK(String uri, String identifier, {bool dontPool, int priorityClass,
    int priorityClassProgress, bool realTimeFlag, bool sparsePoll, bool ignoreUSKDatehints}) : super("SubscribeUSK") {

    super.setField('URI', uri);
    super.setField('Identifier', identifier);
    super.setField("DontPoll", dontPool ?? false);
    super.setField("PriorityClass", priorityClass);
    super.setField("PriorityClassProgress", priorityClassProgress);
    super.setField("SparsePoll", sparsePoll ?? false);
    super.setField("IgnoreUSKDatehints", ignoreUSKDatehints ?? false);
  }
}