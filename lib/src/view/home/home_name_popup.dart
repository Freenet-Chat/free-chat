import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config.dart';

class HomeNamePopup {


  final inputFieldController = TextEditingController();
  SharedPreferences sharedPreferences;

  Widget buildPopupDialog(BuildContext context, SharedPreferences sharedPreferences) {
    inputFieldController.text = "default";

    return new AlertDialog(
      title: Text('Set your client name'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Container(
                  child: TextField(
                    controller: inputFieldController,
                    decoration: InputDecoration(
                        hintText: "Set your name: ",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        ElevatedButton(onPressed: () async {
          Config.clientName = inputFieldController.text;
          await sharedPreferences.setString("clientName", Config.clientName);
          Navigator.pop(context);
        }, child: Text("Done"), style: ElevatedButton.styleFrom(

        )
        ),
      ],
    );
  }

  static build(BuildContext context, SharedPreferences sharedPreferences) {
    showDialog(
      context: context,
      builder: (BuildContext context) => HomeNamePopup().buildPopupDialog(context, sharedPreferences),
    );
  }
}
