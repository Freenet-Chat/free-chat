import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrAlertPopup extends StatefulWidget {
  var invite;
  @override
  _QrAlertPopupState createState() => _QrAlertPopupState();

  QrAlertPopup({this.invite});
}

class _QrAlertPopupState extends State<QrAlertPopup> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Container(
              height: 300,
              width: 300,
              child:
              QrImage(
                data: widget.invite.toBase64(),
                version: QrVersions.auto,
                size: 300,
              )
          )
        ],
      ),
    );
  }
}
