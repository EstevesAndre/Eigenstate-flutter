import 'package:eigenstate/pages/game_type.dart';
import 'package:eigenstate/pages/how_to_play.dart';
import 'package:eigenstate/pages/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:eigenstate/services/alert.dart';
import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/services/sound.dart';

import 'package:eigenstate/components/Btn.dart';
import 'package:eigenstate/components/Logo.dart';

import 'package:eigenstate/theme/theme.dart';

class HomePage extends StatelessWidget {
  final boardService = locator<BoardService>();
  final soundService = locator<SoundService>();
  final alertService = locator<AlertService>();

  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.65],
                colors: [
                  Themes.p1Grey,
                  Themes.p1Blue,
                ],
              )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Eigenstate",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 65,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'DancingScript'),
                      ),
                      Text(
                        "Give it a try",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'DancingScript'),
                      ),
                      SizedBox(height: 30),
                      Logo(),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 50),
                      Btn(
                        onTap: () {
                          boardService.gameMode$.add(GameMode.Solo);

                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => GameType(),
                            ),
                          );
                        },
                        height: 130,
                        width: 130,
                        borderRadius: 250,
                        color: Colors.white,
                        child: Icon(
                          Icons.play_arrow,
                          size: 70.0,
                          color: Themes.p1Grey,
                        ),
                      ),
                      SizedBox(height: 80),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Btn(
                            onTap: () {
                              boardService.gameMode$.add(GameMode.Solo);

                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => SettingsPage(),
                                ),
                              );
                            },
                            color: Colors.white,
                            height: 50,
                            width: 50,
                            borderRadius: 25,
                            child: Icon(
                              Icons.settings,
                              color: Themes.p1Grey,
                            ),
                          ),
                          SizedBox(width: 150),
                          Btn(
                            onTap: () {
                              boardService.gameMode$.add(GameMode.Solo);

                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => HowToPlayPage(),
                                ),
                              );
                            },
                            color: Colors.white,
                            height: 50,
                            width: 50,
                            borderRadius: 25,
                            child: Icon(
                                Icons.ac_unit,
                              color: Themes.p1Grey
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}