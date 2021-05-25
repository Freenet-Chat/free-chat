/// Enumaration of the differens return types used in [FcpClientGet] or UploadFrom
/// in [FcpClientPut]
///
/// Check * https://github.com/freenet/wiki/wiki/FCPv2-ClientPut
/// For more information
///
/// Direct = Data is directly appended or gets returned in the response
/// None = No Data appended or returned
/// Disk = Data is uploaded via file path or downloaded extra
enum ReturnType {
  direct,
  none,
  disk
}

/// Extends the ReturnType enumartion with the function [toShortString]
/// Format the name of the enumartion to fit the message requirements
///
/// Eg. ReturnType.direct.toString() -> ReturnType.direct
/// ReturnType.direct.toShortString() -> direct
extension ShortString on ReturnType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}