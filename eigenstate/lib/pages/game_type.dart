import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/services/sound.dart';
import 'package:eigenstate/services/alert.dart';

import 'package:eigenstate/components/Btn.dart';

import 'package:eigenstate/pages/game.dart';
import 'package:eigenstate/theme/theme.dart';

class GameType extends StatefulWidget {
  _GameTypeState createState() => _GameTypeState();
}

class _GameTypeState extends State<GameType> {
  final boardService = locator<BoardService>();
  final soundService = locator<SoundService>();
  final alertService = locator<AlertService>();

  @override
  Widget build(BuildContext context) {
    final bool inGame = boardService.checkGameInProgress();
    print(inGame);

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
//          decoration: BoxDecoration(
//              gradient: LinearGradient(
//                begin: Alignment.topCenter,
//                end: Alignment.bottomCenter,
//                stops: [0.1, 0.65],
//                colors: [
//                  Themes.p1Grey,
//                  Themes.p1Blue,
//                ],
//              )
//          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Text(
                  "Game Type",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                      fontFamily: 'DancingScript'),
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Btn(
                      onTap: () {
                        if (inGame) {
                          showInGamePopUp("Easy");
                        } else {
                          boardService.setInGame(true);
                          boardService.setGameDifficulty(Difficulty.Easy);
                          soundService.playSound('sounds/click');

                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => GamePage(),
                            ),
                          );
                        }
                      },
                      height: 40,
                      width: 220,
                      borderRadius: 200,
                      gradient: [Themes.p1Grey, Themes.p1Blue],
                      child: Text(
                        "Easy".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 30),
                    Btn(
                      onTap: () {
                        if (inGame) {
                          showInGamePopUp("Medium");
                        } else {
                          boardService.setInGame(true);
                          boardService.setGameDifficulty(Difficulty.Medium);
                          soundService.playSound('sounds/click');

                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => GamePage(),
                            ),
                          );
                        }
                      },
                      height: 40,
                      width: 220,
                      borderRadius: 200,
                      gradient: [Themes.p1Grey, Themes.p1Blue],
                      child: Text(
                        "Medium".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 30),
                    Btn(
                      onTap: () {
                        if (inGame) {
                          showInGamePopUp("Hard");
                        } else {
                          boardService.setInGame(true);
                          boardService.setGameDifficulty(Difficulty.Hard);
                          soundService.playSound('sounds/click');

                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => GamePage(),
                            ),
                          );
                        }
                      },
                      height: 40,
                      width: 220,
                      borderRadius: 200,
                      gradient: [Themes.p1Grey, Themes.p1Blue],
                      child: Text(
                        "Hard".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showInGamePopUp(String gameType) {
      Alert(
        context: context,
        title: "Game in progress",
        style: alertService.resultAlertStyle,
        buttons: [
          DialogButton(
            child: Text(
              "No",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.1, 0.8],
                colors: [Themes.p1Grey, Themes.p1Blue]
            ),
            radius: BorderRadius.circular(200),
            onPressed: () {
              if (gameType == "Easy")
                boardService.setGameDifficulty(Difficulty.Easy);
              else if (gameType == "Medium")
                boardService.setGameDifficulty(Difficulty.Medium);
              else if (gameType == "Hard")
                boardService.setGameDifficulty(Difficulty.Hard);

              boardService.newGame(true);
              soundService.playSound('sounds/click');

              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => GamePage(),
                ),
              );
            },
          ),
          DialogButton(
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.1, 0.8],
                colors: [Themes.p1Grey, Themes.p1Blue]
            ),
            radius: BorderRadius.circular(200),
            onPressed: () {
              soundService.playSound('sounds/click');

              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => GamePage(),
                ),
              );
            },
          ),
        ],
        content: Padding(
          padding:
          EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: Text(
            "Do you want to continue?",
            style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ).show();
  }
}
