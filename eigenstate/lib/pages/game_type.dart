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
//                  BasicTheme.p1Grey,
//                  BasicTheme.p1Blue,
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
                      fontFamily: 'DancingScript'
                  ),
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
                        boardService.resetBoard();
                        boardService.setGameDifficulty(Difficulty.Easy);
//                        soundService.playSound('click');

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => GamePage(),
                          ),
                        );
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
                        boardService.resetBoard();
                        boardService.setGameDifficulty(Difficulty.Medium);
//                        soundService.playSound('click');

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => GamePage(),
                          ),
                        );
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
                        boardService.resetBoard();
                        boardService.setGameDifficulty(Difficulty.Hard);
//                        soundService.playSound('click');

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => GamePage(),
                          ),
                        );
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
}

