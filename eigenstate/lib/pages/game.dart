import 'package:eigenstate/components/board.dart';
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
            child: StreamBuilder<MapEntry<int, int>>(
              stream: boardService.score$,
              builder: (context, AsyncSnapshot<MapEntry<int, int>> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                final int p1Score = snapshot.data.key;
                final int p2Score = snapshot.data.value;

                return Container(
                  width: MediaQuery.of(context).size.width,
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
                              color: Colors.white,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Material(
                                      elevation: 5,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Center(
                                          child: Text(
                                            "$p1Score",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      "Player",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[Board()],
                              )),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.white,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      "Player",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Material(
                                      elevation: 5,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Center(
                                          child: Text(
                                            "$p2Score",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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