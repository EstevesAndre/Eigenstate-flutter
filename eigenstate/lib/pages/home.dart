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
  final theme = locator<Themes>();

  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final btnSize = MediaQuery.of(context).size.width / 5;
    final size8 = MediaQuery.of(context).size.width / 8;
    final size20 = MediaQuery.of(context).size.width / 20;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
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
                theme.getDefaultBackgroundGradientColor1(),
                theme.getDefaultBackgroundGradientColor2(),
              ],
            )),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Eigenstate",
                        style: TextStyle(
                            color: theme.getHomePageTitleColor(),
                            fontSize: MediaQuery.of(context).size.width / 7,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'DancingScript'),
                      ),
                      Text(
                        "Give it a try",
                        style: TextStyle(
                            color: theme.getHomePageTitleColor(),
                            fontSize: MediaQuery.of(context).size.width / 17,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'DancingScript'),
                      ),
                      SizedBox(height: 30),
                      Logo(),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(height: 50),
                      Btn(
                        onTap: () {
                          boardService.gameMode$.add(GameMode.Solo);
                          soundService.playSound('sounds/click');

                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => GameType(),
                            ),
                          );
                        },
                        height: btnSize,
                        width: btnSize,
                        borderRadius: 100,
                        color: theme.getHomePageButtonColor(),
                        child: Icon(
                          Icons.play_arrow,
                          size: size8,
                          color: theme.getHomePageButtonIconColor(),
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: size20),
                            child: Btn(
                              onTap: () {
                                boardService.gameMode$.add(GameMode.Solo);
                                soundService.playSound('sounds/click');

                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => SettingsPage(),
                                  ),
                                );
                              },
                              color: theme.getHomePageButtonColor(),
                              height: size8,
                              width: size8,
                              borderRadius: 100,
                              child: Icon(
                                Icons.settings,
                                size: MediaQuery.of(context).size.width / 14,
                                color: theme.getHomePageButtonIconColor(),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: size20),
                            child: Btn(
                              onTap: () {
                                boardService.gameMode$.add(GameMode.Solo);
                                soundService.playSound('sounds/click');

                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => HowToPlayPage(),
                                  ),
                                );
                              },
                              color: theme.getHomePageButtonColor(),
                              height: size8,
                              width: size8,
                              borderRadius: 100,
                              child: Icon(
                                Icons.help_outline,
                                size: MediaQuery.of(context).size.width / 12,
                                color: theme.getHomePageButtonIconColor(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
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
