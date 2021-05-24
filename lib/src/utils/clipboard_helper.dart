import 'package:flutter/services.dart';
import 'package:free_chat/src/utils/toast.dart';

import '../model.dart';

class ClipboardHelper {
  static void copyToClipboard({InitialInvite invite, InitialInviteResponse inviteResponse}) {
    if(invite != null) {
    }
    else {
      Clipboard.setData(new ClipboardData(text: inviteResponse.toBase64()));
    }
    FreeToast.showToast("Copied to clipboard");
  }
}