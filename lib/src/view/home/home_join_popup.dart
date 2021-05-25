import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/utils/clipboard_helper.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeJoinPopup {

  Widget buildPopupDialog(BuildContext context, InitialInviteResponse invite) {
    return new AlertDialog(
      title: Text('Invite a FreeChat user to chat with you'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Container(
                height: 300,
                width: 300,
                child:
                QrImage(
                  data: invite.toBase64(),
                  version: QrVersions.auto,
                  size: 300,
                )
            )
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(onPressed: () async => { ClipboardHelper.copyToClipboard(inviteResponse: invite) }, child: Text("Copy invite code"), style: ElevatedButton.styleFrom()
        ),
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        ElevatedButton(onPressed: () async => { Navigator.of(context).pop() }, child: Text("Done"), style: ElevatedButton.styleFrom()
        ),
      ],
    );
  }

  static build(BuildContext context, InitialInviteResponse invite) {
    showDialog(
      context: context,
      builder: (BuildContext context) => HomeJoinPopup().buildPopupDialog(context, invite),
    );
  }
}


