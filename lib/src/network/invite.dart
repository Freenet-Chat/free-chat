import 'dart:async';
import 'package:free_chat/src/config.dart';
import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/model/initial_invite_response.dart';
import 'package:free_chat/src/network/networking.dart';
import 'package:free_chat/src/repositories/chat_repository.dart';
import 'package:free_chat/src/utils/logger.dart';
import 'package:free_chat/src/view.dart';


/// Handle all incoming and outgoing [InitialInvite] and [InitialInviteResponse]
class Invite {

  /// Initialize Invite as a singleton
  static final Invite _invite = Invite._internal();

  factory Invite() {
    return _invite;
  }

  Invite._internal();
  ///

  static final Logger _logger = Logger(Invite().toString());

  Networking networking = Networking();

  /// Get a ChatRepository instance to uploads chats to
  ChatRepository chatRepository = ChatRepository();

  /// Create an initialInvite by a given [identifier]
  ///
  /// Set all fields of [InitialInvite] accordingly
  /// Upload an empty chat to the Freenet and prepare the InitialInvite
  /// to get shared via QR in [HomeInvitePopup]
  Future<InitialInvite> createInitialInvitation(String identifier) async {

    var _sskKey = await networking.getKeys();

    String _unique = Uuid().v4();

    String _requestUri = _sskKey.getAsUskRequestUri() + "chat/0";

    String _insertUri = _sskKey.getAsUskInsertUri() + "chat/0";

    String _listeningUri = "KSK@" + _unique;

    String _name = Config.clientName;

    String _encrypt = Uuid().v4();

    String _sharedId = Uuid().v4();

    InitialInvite initialInvite = new InitialInvite(_requestUri, _listeningUri, _name, _encrypt, _insertUri, _sharedId);

    Chat chat = Chat(_insertUri, "", _encrypt, [], _name, _sharedId);

    _logger.i("Created Initial invite: ${initialInvite.toString()}");

    _logger.i("Created Initial chat: $chat");

    await networking.sendMessage(_insertUri, chat.toString(), identifier);

    return initialInvite;
  }

  /// Handle an incoming [initialInvite] from the [HomeJoin] view and use three
  /// identifiers:
  /// [identifierHandshake]
  /// [identifierInsert]
  /// [identifierRequest]
  ///
  /// To display a progress
  /// eg. (Success / Total)
  ///
  /// Upload an empty chat to the insertUri and a response to the handshakeUri
  /// Download the Chat object uploaded from the other user and passed in the
  /// initialInvite
  ///
  /// Generates and returns an [InitialInviteResponse] which gets passed to the
  /// other user
  Future<InitialInviteResponse> handleInvitation(InitialInvite initialInvite, String identifierHandshake, String identifierInsert, String identifierRequest) async {
    var _sskKey = await networking.getKeys();

    var _insertUri = _sskKey.getAsUskInsertUri() + "chat/0/";

    var _requestUri = _sskKey.getAsUskRequestUri() + "chat/0/";

    _logger.i("InitialInvite12 => $initialInvite");

    Chat chat = Chat(_insertUri, initialInvite.getRequestUri(), initialInvite.encryptKey, [], initialInvite.getName(), initialInvite.sharedId);

    InitialInviteResponse initialInviteResponse = InitialInviteResponse(_requestUri, Config.clientName);


    try {
      await Future.wait([
        networking.sendMessage(_insertUri, chat.toString(), identifierInsert),
        networking.getMessage(initialInvite.getRequestUri(), identifierRequest)
      ]);
    }
    catch(e) {
      _logger.e("Upload failed ${e.toString()}");
      return null;
    }

    FcpSubscribeUSK fcpSubscribeUSK = FcpSubscribeUSK(initialInvite.getRequestUri(), Uuid().v4());

    networking.fcpConnection.sendFcpMessage(fcpSubscribeUSK);

    ChatDTO dto = ChatDTO.fromChat(chat);

    _logger.i("dto => $dto");

    await chatRepository.upsert(dto);
    return initialInviteResponse;
  }

  /// Handle an accepted invite
  ///
  /// User A -> Uploads [initialInvite]
  /// User B -> Reads [initialInvite] and uploads [response]
  /// User A -> Read [response] and handles the answer in [inviteAccepted]
  ///
  /// Creates the finished Chat with all information and saves it in the local
  /// database
  Future<bool> inviteAccepted(InitialInvite initialInvite, InitialInviteResponse response) async {
    FcpMessage fcpChat;

    try {
      fcpChat = await networking.getMessage(initialInvite.getRequestUri(), Uuid().v4());
    }
    catch(e) {
      _logger.e(e.toString());
      return false;
    }

    _logger.i(fcpChat.toString());

    ChatDTO chatDTO = ChatDTO();
    chatDTO.insertUri = initialInvite.insertUri;
    chatDTO.encryptKey = initialInvite.encryptKey;
    chatDTO.requestUri = response.requestUri;
    chatDTO.name = response.name;
    chatDTO.sharedId = initialInvite.sharedId;

    _logger.i(chatDTO.toMap().toString());

    FcpSubscribeUSK fcpSubscribeUSK = FcpSubscribeUSK(response.requestUri, Uuid().v4());

    networking.fcpConnection.sendFcpMessage(fcpSubscribeUSK);

    await chatRepository.upsert(chatDTO);

    return true;
  }
}
