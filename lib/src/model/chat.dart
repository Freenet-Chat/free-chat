/*
            {
                "id": "xxx",
                "nextURI": "xxx",
                "users": [{
                    "name": "",
                    "public": ""
                }],
                "messages" : [{
                    "message": "",
                    "sendBy": "",
                    "timestamp": ""
                }]
            }
 */
import 'package:free_chat/src/model.dart';
import 'package:free_chat/src/view.dart';

/// The Chat modell used to display a chat in the applications [ChatsDetail] view
class Chat {

  /// The insertUri as a [String] to upload this users half of the chat
  get insertUri => _insertUri;
  String _insertUri;

  /// The requestUri as a [String] to get the other users half of the chat
  get requestUri => _requestUri;
  String _requestUri;

  /// The encryptKey as a [String] which can be used to encrypt the chats client
  /// side
  get encryptKey => _encryptKey;
  String _encryptKey;

  /// The name as a [String] of the chat partner
  get name => _with;
  String _with;

  /// The unique sharedId as a [String] to identify the chat uniquely for both users
  String sharedId;

  /// A list of all messages [Message] of the chat
  get messages => _messages;
  List<Message> _messages;



  Chat(this._insertUri, this._requestUri, this._encryptKey, this._messages, this._with, this.sharedId);

  /// Format a [ChatDTO] (loaded from the database) [dto] and a list of
  /// [messages] to a [Chat] object
  factory Chat.fromDTO(ChatDTO dto, List<Message> messages) {
    return Chat(dto.insertUri, dto.requestUri, dto.encryptKey, messages, dto.name, dto.sharedId);
  }

  /// Format an [json] object and a [requestUri] to a [Chat] object
  factory Chat.fromJson(dynamic json, String requestUri) {
    List messages = json["messages"];
    var parsedMessages = messages.map((e) => Message.fromJson(e)).toList();


    return Chat.onlyInfo(
      json["with"],
      parsedMessages,
      requestUri,
      json["sharedId"]
    );
  }

  /// Add a [message] to the list of messages in this chat
  void addMessage(Message message) {
    this._messages.add(message);
  }

  /// Add a List of [message] to the list of messages in this chat
  void addMessages(List<Message> msgs) {
    _messages.addAll(msgs);
  }

  /// Format the Chat to a map
  Map<String, dynamic> toMap() {
    return {
      'insertUri': _insertUri,
      'requestUri': _requestUri,
      'encryptKey': _encryptKey,
      'with': _with,
      'sharedId': sharedId
    };
  }

  Chat.onlyInfo(this._with, this._messages, this._requestUri, this.sharedId);

  List<Message> getMessages() {
    return this._messages;
  }

  String getNextUri() {
    return this.getNextUri();
  }

  /// Creates a JSON [String] of the Chat
  ///
  /// eg.
  /// {
  ///   "sharedId": [sharedId],
  ///   "with": [_with],
  ///   "messages": [
  ///     {[message]},
  ///     {[message]},
  ///     {[message]},
  ///     {[message]}
  ///   ]
  /// }
  @override
  String toString() {

    //String users = propertyToJsonListString(_users);
    String messages = propertyToJsonListString(_messages);


    return '{"sharedId": "$sharedId", "with": "$_with", "messages": $messages}';

  }

  /// Format all [messages] to a Json object
  /// [
  ///   {[message]},
  ///   {[message]},
  ///   {[message]},
  ///   {[message]}
  /// ]
  String propertyToJsonListString(List<dynamic> property) {
    if(property.length == 0) return "[]";
    String propertyString = "[";
    property.forEach((element) {
      propertyString = propertyString + element.toString() + ",";
    });
    if (propertyString != null && propertyString.length > 0) {
      propertyString = propertyString.substring(0, propertyString.length - 1);
    }
    propertyString = propertyString + "]";
    return propertyString;
  }
}
