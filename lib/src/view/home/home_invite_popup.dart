import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_chat/src/controller/home_invite_controller.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/utils/clipboard_helper.dart';
import 'package:free_chat/src/view/utils/qr_alert_popup.dart';
import 'package:qr_flutter/qr_flutter.dart';
class HomeInvitePopup {

  HomeInviteController _homeInviteController = HomeInviteController();

  Widget buildPopupDialog(BuildContext context, InitialInvite invite) {
    return new AlertDialog(
      title: Text('Invite a FreeChat user to chat with you'),
      content: QrAlertPopup(invite: invite),
      actions: <Widget>[
        ElevatedButton(onPressed: () async => { ClipboardHelper.copyToClipboard(invite: invite) }, child: Text("Copy invite code"), style: ElevatedButton.styleFrom()
        ),
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        ElevatedButton(onPressed: () async => { await _homeInviteController.inviteAccepted(invite, context) }, child: Text("Done"), style: ElevatedButton.styleFrom()
        ),
      ],
    );
  }

  static build(BuildContext context, InitialInvite invite) {
    showDialog(
      context: context,
      builder: (BuildContext context) => HomeInvitePopup().buildPopupDialog(context, invite),
    );
  }
}
