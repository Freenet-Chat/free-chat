import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/network/database_handler.dart';
import 'package:free_chat/src/network/invite.dart';
import 'package:free_chat/src/network/networking.dart';
import 'package:free_chat/src/utils/logger.dart';
import 'package:free_chat/src/utils/toast.dart';
import 'package:free_chat/src/view.dart';

class HomeJoinController {
  static final HomeJoinController _homeJoinController =
      HomeJoinController._internal();

  final Logger _logger = Logger("HomeInviteController");

  factory HomeJoinController() {
    return _homeJoinController;
  }


  HomeJoinController._internal();

  Future<void> inviteAccepted(
      InitialInviteResponse invite, BuildContext context) async {

  }
}
