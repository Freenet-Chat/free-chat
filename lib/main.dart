/// 25.05.2021
/// The Free-Chat application was an for the DHBW developed Chat application
/// which should be a showcase of Freenets ability to be used as a backend for
/// a chat application
///
/// Make sure to check out multiple sources first:
/// * https://github.com/freenet/wiki/wiki/FCPv2
/// * https://github.com/freenet?page=2
/// * https://freenetproject.org/index.html
/// * https://github.com/Freenet-Chat/free-chat
/// * https://youtu.be/BP_sBDDAPgU
/// * https://www.reddit.com/r/darknetplan/comments/n6gi4y/i_build_a_chat_application_running_over_the/
///
/// Feel free to contact Dennis (dennis.rein@outlook.com) for any questions.
///
/// This application also implements a FCP wrapper libarary [src/fcp] written in Dart, which
/// will be outsourced and made usable for public soon.
///
/// Please create issues when encountering bugs or for feature requests
/// * https://github.com/Freenet-Chat/free-chat
///
/// This is an early and unstable state (Alpha), which
/// will be improved in the near future.

import 'package:free_chat/src/view.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: HomeTheme.getTheme(),
    home: Home()
    );}
}