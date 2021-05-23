
import 'package:free_chat/src/fcp/fcp.dart';
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/network/database_handler.dart';
import 'package:free_chat/src/network/networking.dart';
import 'package:free_chat/src/repositories/chat_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:free_chat/src/network/invite.dart';
import 'package:uuid/uuid.dart';

import 'invite_test.mocks.dart';

@GenerateMocks([Networking, Uuid, FcpConnection, ChatRepository])
void main() {
  group('Test invite creation, handling and acception', ()
  {
    Invite invite;
    ChatDTO temp;
    /**
     * This Test mocks multiple networking and databasehandler functions which are all tested at different places
     *
     */
    setUp(() {
      invite = Invite();
      invite.networking = MockNetworking();
      invite.chatRepository = MockChatRepository();

      MockFcpConnection mockFcpConnection = MockFcpConnection();

      when(invite.networking.fcpConnection).thenReturn(mockFcpConnection);


      when(invite.networking.getKeys()).thenAnswer((_) => Future(() => SSKKey("SSK@testInserUri", "SSK@testRequestUri")));

      when(invite.networking.sendMessage(any, any, any)).thenAnswer((
          realInvocation) => Future(() => FcpMessage("test")));

      when(invite.networking.getMessage(any, any)).thenAnswer((realInvocation) => Future(() => FcpMessage("test")));

      when(mockFcpConnection.sendFcpMessage(any)).thenAnswer((realInvocation) => null);

      when(invite.chatRepository.upsert(any)).thenAnswer((realInvocation) {
        temp = realInvocation.positionalArguments.first;
        return;
      });
    });

    test('Should create an initial invite with mock SSKKey', () async {
      InitialInvite initialInvite = await invite.createInitialInvitation(
          "test");

      expect(initialInvite.getRequestUri().contains("USK@testRequestUri"), true);
    });

    test('Should create invite response and update database', () async {
      InitialInvite initialInvite = await invite.createInitialInvitation(
          "test");

      InitialInviteResponse response = await invite.handleInvitation(initialInvite, "identifierHandshake", "identifierInsert", "identifierRequest");

      expect(response.requestUri.contains(temp.requestUri), true);
    });


    test('Should fail because of faulty network and return null on handle invitation', () async {
      when(invite.networking.getMessage(any, any)).thenThrow(Exception());
      InitialInvite initialInvite = await invite.createInitialInvitation(
          "test");

      InitialInviteResponse response = await invite.handleInvitation(initialInvite, "identifierHandshake", "identifierInsert", "identifierRequest");

      expect(response, null);

    });

    test('Should accept invite response and create chat object', () async {
      InitialInvite initialInvite = InitialInvite("_requestUri", "_handshakeUri", "_name", "_encryptKey", "_insertUri", "_sharedId");
      InitialInviteResponse initialInviteResponse = InitialInviteResponse("_requestUriResponse", "_nameResponse");

      bool accepted = await invite.inviteAccepted(initialInvite, initialInviteResponse);

      expect(accepted, true);
      expect(temp.requestUri, initialInviteResponse.requestUri);
      expect(temp.insertUri, initialInvite.insertUri);
    });

    test('Should fail because of faulty network and return false on accept invitation', () async {
      when(invite.networking.getMessage(any, any)).thenThrow(Exception());
      InitialInvite initialInvite = InitialInvite("_requestUri", "_handshakeUri", "_name", "_encryptKey", "_insertUri", "_sharedId");
      InitialInviteResponse initialInviteResponse = InitialInviteResponse("_requestUriResponse", "_nameResponse");

      bool accepted = await invite.inviteAccepted(initialInvite, initialInviteResponse);

      expect(accepted, false);
    });
  });
}