import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/network/invite.dart';
import 'package:free_chat/src/utils/logger.dart';
import 'package:free_chat/src/view.dart';

/// A controller for the home invite popup view
/// Should only be used in [HomeInvitePopup]
class HomeInviteController {
  /// Return the [HomeInviteController] as a singleton
  static final HomeInviteController _homeInviteController = HomeInviteController._internal();

  factory HomeInviteController() {
    return _homeInviteController;
  }

  HomeInviteController._internal();
  ///

  /// The [Invite] instance used to handle invites
  Invite _invite = Invite();

  /// User A generated an [InitialInvite] User B scanned the Invite, created
  /// and replied with an [InitialInviteResponse]. User A pressed accept to
  /// handle the incoming [InitialInviteResponse]
  ///
  /// Opens the [HomeJoin] view to scan in the [InitialInviteResponse]
  ///
  /// Handle the incoming [InitialInviteResponse] in the [_invite] class
  /// Join chat if success else show [ErrorPopup]
  Future<void> inviteAccepted(InitialInvite invite, BuildContext context) async {

    var i = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeJoin()),
    );

    LoadingPopup.build(context, "Joining Chatroom this can take up to a couple minutes");

    Navigator.pop(context);
    Navigator.pop(context);
    if(!(await _invite.inviteAccepted(invite, InitialInviteResponse.fromBase64(i)))) {
      ErrorPopup.build(context, "An error occured while trying to join the chat room, please try again later");
    }
  }
}