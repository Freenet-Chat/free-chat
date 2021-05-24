import 'package:flutter/material.dart';
import 'package:free_chat/src/repositories/chat_repository.dart';
import 'package:free_chat/src/view.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FreeChat'),
        ),
      body: Container(
        child: FutureBuilder(
          future: ChatRepository().fetchAllChats(),
          builder: (context, snapshot) {
            if(snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Loading'),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  /*leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      snapshot.data[index].image,
                    ),
                  ),*/
                  title: Text(snapshot.data[index].name.toString()),
                  //subtitle: Text(snapshot.data[index].type.join(' | ').toString().capitalizeAll()),
                  onTap: () async {
                    var chat = await ChatRepository().fetchChatAndMessages(snapshot.data[index].id);
                    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ChatsDetail(chat, snapshot.data[index])));
                  }
                );
              },
            );
          },
        ),
      ),
    );
  }
}
