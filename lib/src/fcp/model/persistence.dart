import 'package:free_chat/src/fcp/fcp.dart';

/// Enumaration of the differens persistence types used in [FcpClientGet] and
/// [FcpClientPut]
///
/// Check * https://github.com/freenet/wiki/wiki/FCPv2#Persistence-and-the-Global-Queue
/// For more information
///
/// Connection = Data stays uploaded while node is connected
/// Reboot = Data gets uploaded evereytime the node gets rebooted
/// Forever = Data never leaves the Freenet
enum Persistence {
  connection,
  reboot,
  forever
}

/// Extends the Persistence enumartion with the function [toShortString]
/// Format the name of the enumartion to fit the message requirements
///
/// Eg. Persistence.connection.toString() -> Persistence.connection
/// Persistence.connection.toShortString() -> connection
extension PersistenceShortString on Persistence {
  String toShortString() {
    return this.toString().split('.').last;
  }
}