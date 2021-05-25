import 'package:flutter/services.dart';
import 'package:free_chat/src/utils/toast.dart';

import '../model.dart';

/// Helper Class to handle to copy to clipboard functionalities
/// Can be extended to format and copy more data
/// Right now only works for [InitialInvite] and [InitialInviteResponse]
class ClipboardHelper {
  /// Takes in either an [InitialInvite] [invite] or an [InitialInviteResponse]
  /// [inviteResponse] and copies the content to the clipboard
  static void copyToClipboard({InitialInvite invite, InitialInviteResponse inviteResponse}) {
    if(invite != null) {
      Clipboard.setData(new ClipboardData(text: invite.toBase64()));
    }
    else {
      Clipboard.setData(new ClipboardData(text: inviteResponse.toBase64()));
    }
    FreeToast.showToast("Copied to clipboard");
  }
}