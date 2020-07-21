import 'package:eigenstate/components/board.dart';
import 'package:eigenstate/components/piece.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: StreamBuilder<
                MapEntry<MapEntry<int, int>, MapEntry<int, Player>>>(
          stream: Rx.combineLatest2(boardService.score$, boardService.rounds$,
              (a, b) => MapEntry(a, b)),
          builder: (context,
              AsyncSnapshot<MapEntry<MapEntry<int, int>, MapEntry<int, Player>>>
                  snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            final int p1Score = snapshot.data.key.key;
            final int p2Score = snapshot.data.key.value;
//                final String mode = boardService.getGameDifficulty();
            final int round = snapshot.data.value.key;
            final int onPlayerSwitch = snapshot.data.value.value.index + 1;
//            final int angleCondition = snapshot.data.value.value.index;
            final String playing = snapshot.data.value.value == Player.P1
                ? "Your turn"
                : "AI turn";

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
              )),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                      child: Text(
                                        "Player 1",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                    AnimatedSwitcher(
                                      duration: Duration(seconds: 1),
                                      transitionBuilder: (Widget child,
                                              Animation<double> animation) =>
                                          RotationTransition(
                                              turns: animation, child: child),
                                      child: Container(
                                        key: ValueKey<int>(p1Score + 1),
                                        child: Piece.scorePiece(50, 50,
                                            Themes.p1Grey, p1Score, Player.P2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 15),
                                        child: Text(
                                          "Turn",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                      AnimatedSwitcher(
                                        duration: Duration(seconds: 1),
                                        transitionBuilder: (Widget child,
                                                Animation<double> animation) =>
                                            RotationTransition(
                                                turns: animation, child: child),
                                        child: (round ~/ 10 == 0
                                            ? Container(
                                                key: ValueKey<int>(round),
                                                child: Piece.scorePiece(
                                                    50,
                                                    50,
                                                    Themes.p1Grey,
                                                    round,
                                                    Player.P2),
                                              )
                                            : Row(
                                                key: ValueKey<int>(round),
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Piece.scorePiece(
                                                      40,
                                                      50,
                                                      Themes.p1Grey,
                                                      round ~/ 10,
                                                      Player.P2),
                                                  SizedBox(width: 10),
                                                  Piece.scorePiece(
                                                      40,
                                                      50,
                                                      Themes.p1Grey,
                                                      round % 10,
                                                      Player.P2),
                                                ],
                                              )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                      child: Text(
                                        "Player 2",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                    AnimatedSwitcher(
                                      duration: Duration(seconds: 1),
                                      transitionBuilder: (Widget child,
                                              Animation<double> animation) =>
                                          RotationTransition(
                                              turns: animation, child: child),
                                      child: Container(
                                        key: ValueKey<int>(p2Score + 1),
                                        child: Piece.scorePiece(50, 50,
                                            Themes.p1Grey, p2Score, Player.P2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 750),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) =>
                                  SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(0.0, 4.0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child),
                          child: Container(
                            key: ValueKey<int>(onPlayerSwitch),
                            child: Text(
                              playing,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
//                        AnimatedSwitcher(
//                          duration: Duration(seconds: 1),
//                          transitionBuilder: (Widget child, Animation<double> animation ) =>
//                            RotatedBox(
//                              quarterTurns: 2 * angleCondition,
//                              child: child
//                            ),
//                          child:
                        Container(
//                          key: ValueKey<int>(onPlayerSwitch),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Board()],
                          ),
                        ),
//                        ),
                        Container(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        )),
      ),
    );
  }
}
