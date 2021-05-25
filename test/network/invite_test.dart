
import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/network/networking.dart';
import 'package:free_chat/src/repositories/chat_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:free_chat/src/network/invite.dart';
import 'package:uuid/uuid.dart';
import 'invite_test.mocks.dart';

/// Test the [Invite] class for all of its functionalitites

@GenerateMocks([Networking, Uuid, FcpConnection, ChatRepository])
void main() {
  group('Test invite creation, handling and acception', ()
  {
    Invite invite;
    ChatDTO temp;

    /// Set an [Invite] and [ChatDTO] used by every test
    setUp(() {
      invite = Invite();
      invite.networking = MockNetworking();
      invite.chatRepository = MockChatRepository();

      MockFcpConnection mockFcpConnection = MockFcpConnection();

      /// Instead of a real [FcpConnection] return a [MockFcpConnection]
      when(invite.networking.fcpConnection).thenReturn(mockFcpConnection);

      /// Instead of sending a real SSKKey request respond with mocked ones
      when(invite.networking.getKeys()).thenAnswer((_) => Future(() => SSKKey("SSK@testInserUri", "SSK@testRequestUri")));

      /// Instead of sending any message respond with mocked message
      when(invite.networking.sendMessage(any, any, any)).thenAnswer((
          realInvocation) => Future(() => FcpMessage("test")));

      /// Instead of fetching any message respond with mocked message
      when(invite.networking.getMessage(any, any)).thenAnswer((realInvocation) => Future(() => FcpMessage("test")));

      /// Instead of sending any message respond with mocked message
      when(mockFcpConnection.sendFcpMessage(any)).thenAnswer((realInvocation) => null);

      /// Instead of updating message in real databae update temp message
      when(invite.chatRepository.upsert(any)).thenAnswer((realInvocation) {
        temp = realInvocation.positionalArguments.first;
        return;
      });
    });

    test('Should create an initial invite with mock SSKKey', () async {
      /// given setUp is given

      /// when create initialInvite
      InitialInvite initialInvite = await invite.createInitialInvitation(
          "test");

      /// then initialInvite to contains mock data
      expect(initialInvite.getRequestUri().contains("USK@testRequestUri"), true);
    });

    test('Should create invite response and update database', () async {
      /// given setUp and initialInvite is given
      InitialInvite initialInvite = await invite.createInitialInvitation(
          "test");

      /// when should create initialInviteResponse
      InitialInviteResponse response = await invite.handleInvitation(initialInvite, "identifierHandshake", "identifierInsert", "identifierRequest");

      /// then response to be saved in fake database
      expect(response.requestUri.contains(temp.requestUri), true);
    });


    test('Should fail because of faulty network and return null on handle invitation', () async {
      /// given setUp and initialInvite is given and connection throws exception
      when(invite.networking.getMessage(any, any)).thenThrow(Exception());
      InitialInvite initialInvite = await invite.createInitialInvitation(
          "test");

      /// when Invite gets handled
      InitialInviteResponse response = await invite.handleInvitation(initialInvite, "identifierHandshake", "identifierInsert", "identifierRequest");

      /// then should respond with a null
      expect(response, null);

    });

    test('Should accept invite response and create chat object', () async {
      /// given initialInvite, initialInviteResponse
      InitialInvite initialInvite = InitialInvite("_requestUri", "_handshakeUri", "_name", "_encryptKey", "_insertUri", "_sharedId");
      InitialInviteResponse initialInviteResponse = InitialInviteResponse("_requestUriResponse", "_nameResponse");

      /// when invite is accepted
      bool accepted = await invite.inviteAccepted(initialInvite, initialInviteResponse);

      /// should create chat object
      expect(accepted, true);
      expect(temp.requestUri, initialInviteResponse.requestUri);
      expect(temp.insertUri, initialInvite.insertUri);
    });

    test('Should fail because of faulty network and return false on accept invitation', () async {
      /// given initialInvite, response and networkign throws exception
      when(invite.networking.getMessage(any, any)).thenThrow(Exception());
      InitialInvite initialInvite = InitialInvite("_requestUri", "_handshakeUri", "_name", "_encryptKey", "_insertUri", "_sharedId");
      InitialInviteResponse initialInviteResponse = InitialInviteResponse("_requestUriResponse", "_nameResponse");

      /// when invite gets accepted
      bool accepted = await invite.inviteAccepted(initialInvite, initialInviteResponse);

      /// then should return false because invite wasn't accepted successful
      expect(accepted, false);
    });
  });
}