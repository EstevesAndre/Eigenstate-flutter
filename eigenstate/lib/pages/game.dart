import 'package:eigenstate/components/board.dart';
import 'package:eigenstate/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

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
            child: StreamBuilder<MapEntry<MapEntry<int, int>, MapEntry<int, Player>>>(
              stream: Rx.combineLatest2(boardService.score$, boardService.rounds$, (a, b) => MapEntry(a, b)),
              builder: (context, AsyncSnapshot<MapEntry<MapEntry<int, int>, MapEntry<int, Player>>> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final int p1Score = snapshot.data.key.key;
                final int p2Score = snapshot.data.key.value;
//                final String mode = boardService.getGameDifficulty();
                final int round = snapshot.data.value.key;
                final String playing = snapshot.data.value.value == Player.P1 ? "Player 1" : "Player 2";

                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1, 0.65],
                        colors: [
                          Themes.p1Purple,
                          Themes.p1Blue,
                        ],
                      )
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      "Player 1\n      $p1Score",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        "Turn\n$round",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      "Player 2\n      $p2Score",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Text(
                                playing,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20
                                ),
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[Board()],
                              )
                            ),
                            Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ),
        ),
      ),
    );
  }
}