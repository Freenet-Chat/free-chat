import 'package:flutter/cupertino.dart';
import 'package:free_chat/src/model.dart';

class HomeJoinController {
  static final HomeJoinController _homeJoinController =
      HomeJoinController._internal();


  factory HomeJoinController() {
    return _homeJoinController;
  }


  HomeJoinController._internal();

  Future<void> inviteAccepted(
      InitialInviteResponse invite, BuildContext context) async {

  }
}
