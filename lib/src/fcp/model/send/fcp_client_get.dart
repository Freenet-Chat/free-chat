import 'package:free_chat/src/fcp/fcp.dart';
/// Implements a ClientGet Message of the FCP
/// * https://github.com/freenet/wiki/wiki/FCPv2-ClientGet
///
/// Extends [FcpMessage] and takes all the fields mentioned in the wiki.
/// Defaults the non set fields to the defaults value of the message
/// Sets the [fields] and the [name] accordingly.
///
/// Requires an [uri]
class FcpClientGet extends FcpMessage {
  FcpClientGet(String uri, {bool ignoreDs, bool dsOnly, String identifier,
                 int verbosity, int maxSize, int maxTempSize, int maxRetries,
                 int priorityClass, Persistence persistence, String clientToken,
                 bool global, ReturnType returnType, bool binaryBlob, bool filterData, bool realTimeFlag
                 }) : super('ClientGet') {
    super.setField("URI", uri);
    super.setField("IgnoreDS", ignoreDs ?? false);
    super.setField("DSonly", dsOnly ?? false);
    super.setField("Identifier", identifier);
    super.setField("Verbosity", verbosity);
    super.setField("MaxSize", maxSize);
    super.setField("MaxTempSize", maxTempSize);
    super.setField("MaxRetries", maxRetries);
    super.setField("PriorityClass", priorityClass);
    super.setField("Persistence", persistence?.toShortString() ?? Persistence.connection.toShortString());
    super.setField("ClientToken", clientToken);
    super.setField("Global", global ?? false);
    super.setField("ReturnType", returnType?.toShortString() ?? ReturnType.direct.toShortString());
    super.setField("BinaryBlob", binaryBlob ?? false);
    super.setField("FilterData", filterData ?? false);
    super.setField("RealTimeFlag", realTimeFlag ?? false);
  }
}