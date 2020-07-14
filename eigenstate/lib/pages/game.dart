import 'package:flutter/material.dart';

import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/provider.dart';

class GamePage extends StatefulWidget {
  @override
  GameState createState() => GameState();
}

class GameState extends State<GamePage> {
  final boardService = locator<BoardService>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        boardService.newGame();
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Text(
              "TOCTOC",
            ),
          ),
        ),
      ),
    );
  }
}