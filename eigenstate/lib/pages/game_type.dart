import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/services/sound.dart';

import 'package:eigenstate/components/Btn.dart';

import 'package:eigenstate/pages/game.dart';
import 'package:eigenstate/theme/theme.dart';

class GameType extends StatefulWidget {
  _GameTypeState createState() => _GameTypeState();
}

class _GameTypeState extends State<GameType> {
  final boardService = locator<BoardService>();
  final soundService = locator<SoundService>();

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
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text("Game in progress"),
              content: Text("Do you want to continue?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("No"),
                  onPressed: () {
                    if (gameType == "Easy")
                      boardService.setGameDifficulty(Difficulty.Easy);
                    else if (gameType == "Medium")
                      boardService.setGameDifficulty(Difficulty.Medium);
                    else if (gameType == "Hard")
                      boardService.setGameDifficulty(Difficulty.Hard);

                    boardService.resetBoard();
                    soundService.playSound('sounds/click');

                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => GamePage(),
                      ),
                    );
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Yes"),
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
            ));
  }
}
