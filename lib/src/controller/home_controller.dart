import 'package:flutter/material.dart';
import 'package:free_chat/src/network/invite.dart';
import 'package:free_chat/src/network/networking.dart';
import 'package:free_chat/src/repositories/chat_repository.dart';
import 'package:free_chat/src/utils/logger.dart';
import 'package:free_chat/src/view.dart';

import '../model.dart';

/// A controller for the home view
/// Should only be used in [Home]
class HomeController {
  /// Return the [HomeController] as a singleton
  static final HomeController _homeController = HomeController._internal();

  factory HomeController() {
    return _homeController;
  }

  HomeController._internal();
  ///

  /// The [Logger] of the HomeController
  final Logger _logger = Logger("HomeController");

  /// The currently connected Node
  Node _currentNode;

  /// The [Networking] instance used to connect to the Freenet
  Networking networking = new Networking();

  /// Initializes and connecting to the Freenet Node and setting the
  /// [_currentNode] to it
  ///
  /// Gets every [ChatDTO] out of the [ChatRepository] to check if new message
  /// have arrived while the app was closed
  Future<void> initNode() async {
    _currentNode = await networking.connectClient();

    ChatRepository().fetchAllChats().then((value) => {
      for(ChatDTO chat in value) {
        networking.update(chat)
      }
    });
  }

  /// Creates a [HomeInvitePopup] with a QR code containing the information of
  /// an [InitialInvite] so another user can connect to it
  Future<void> invite(BuildContext context) async {
    Invite invite = Invite();

    String identifier = Uuid().v4();

    LoadingPopupWithProgressCall.build(context, "Creating chat room, this can take up to a couple minutes", [identifier]);

    InitialInvite inv = await invite.createInitialInvitation(identifier);

    Navigator.pop(context);

    HomeInvitePopup.build(context, inv);

  }

  /// Navigates to the [HomeJoin] view which contains a QR-Code Scanner by using
  /// the current [context]
  ///
  /// Tries to read an [InitialInvite] out of the scanned QR-Code and returns
  /// null if it fails
  ///
  /// Handles the invite and replies with [InitialInviteResponse] if the
  /// connection succeeds.
  ///
  /// The [InitialInviteResponse] gets displayed in a [HomeJoinPopup] if success
  /// or an [ErrorPopup] if failure
  Future<void> join(BuildContext context) async {
    var i = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeJoin()),
    );
    InitialInvite initialInvite;

    try {
      initialInvite = InitialInvite.fromBase64(i);
    }
    catch(e) {
      return null;
    }

    String identifier1 = Uuid().v4();
    String identifier2 = Uuid().v4();
    String identifier3 = Uuid().v4();

    LoadingPopupWithProgressCall.build(context, "Joining chat with ${initialInvite.getName()} this can take up to a couple minutes", [identifier1, identifier2, identifier3]);

    var invitationResponse = await Invite().handleInvitation(initialInvite, identifier1, identifier2, identifier3);

    _logger.i(invitationResponse.toString());

    Navigator.pop(context);
    if(invitationResponse != null) {
      HomeJoinPopup.build(context, invitationResponse);
    }
    else {
      ErrorPopup.build(context, "An error occured while trying to join the chat room, please try again later");
    }
  }

  /// Fetches the description of the [_currentNode] and returns it to get
  /// displayed in the [Home] view
  ///
  /// Returns a String [text] containing different information of the node
  String getNodeDescription() {
    if(_currentNode == null) {
      return "Not connected to Node";
    }
    String text = "Name: ${_currentNode.getNodeName()}"
        "\nVersion: ${_currentNode.getVersion()}"
        "\nFcpVersion: ${_currentNode.getFcpVersion()}"
        "\nBuild: ${_currentNode.getBuild()}\n"
        "Connected: ${_currentNode.isConnected()}";
    return text;

  }
}