import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/sound.dart';
import 'package:eigenstate/services/alert.dart';
import 'package:eigenstate/services/admob.dart';

import 'package:eigenstate/components/Btn.dart';

import 'package:eigenstate/pages/game.dart';
import 'package:eigenstate/theme/theme.dart';

import 'package:admob_flutter/admob_flutter.dart';

class GameType extends StatefulWidget {
  _GameTypeState createState() => _GameTypeState();
}

class _GameTypeState extends State<GameType> {
  final boardService = locator<BoardService>();
  final soundService = locator<SoundService>();
  final alertService = locator<AlertService>();
  final adMobService = locator<AdMobService>();
  final theme = locator<Themes>();
  AdmobInterstitial interstitialAd;

  @override
  void initState() {
    super.initState();

    interstitialAd = AdmobInterstitial(
        adUnitId: adMobService.getInterstitialAdId(),
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.closed) interstitialAd.load();
        })
      ..load();
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool inGame = boardService.checkGameInProgress();

    final h1FontSize = MediaQuery.of(context).size.width / 8;
    final h3FontSize = MediaQuery.of(context).size.width / 13;
    final h5FontSize = MediaQuery.of(context).size.width / 25;

    final btnWidth = MediaQuery.of(context).size.width / 1.8;
    final btnHeight = MediaQuery.of(context).size.height / 15;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: theme.getGameTypePageBackgroundColor(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                child: Text(
                  "Game Type",
                  style: TextStyle(
                      color: theme.getgameTypePageTitleColor(),
                      fontWeight: FontWeight.w700,
                      fontSize: h1FontSize,
                      fontFamily: 'DancingScript'),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                      child: Text(
                        "AI",
                        style: TextStyle(
                            color: theme.getgameTypePageTitleColor(),
                            fontWeight: FontWeight.w500,
                            fontSize: h3FontSize,
                            fontFamily: 'DancingScript'),
                      ),
                    ),
                    Btn(
                      onTap: () {
                        if (inGame) {
                          showInGamePopUp("Easy");
                        } else {
                          boardService.setInGame(true);
                          boardService.setGameMode(GameMode.Solo);
                          boardService.setGameDifficulty(Difficulty.Easy);
                          soundService.playSound('sounds/click');

                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => GamePage(),
                            ),
                          );
                        }
                      },
                      height: btnHeight,
                      width: btnWidth,
                      borderRadius: 200,
                      gradient: [
                        theme.getDefaultButtonGradientColor1(),
                        theme.getDefaultButtonGradientColor2()
                      ],
                      child: Text(
                        "Easy".toUpperCase(),
                        style: TextStyle(
                            color: theme.getDefaultButtonTextColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: h5FontSize),
                      ),
                    ),
                    SizedBox(height: 25),
                    Btn(
                      onTap: () {
                        if (inGame) {
                          showInGamePopUp("Medium");
                        } else {
                          boardService.setInGame(true);
                          boardService.setGameMode(GameMode.Solo);
                          boardService.setGameDifficulty(Difficulty.Medium);
                          soundService.playSound('sounds/click');

                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => GamePage(),
                            ),
                          );
                        }
                      },
                      height: btnHeight,
                      width: btnWidth,
                      borderRadius: 200,
                      gradient: [
                        theme.getDefaultButtonGradientColor1(),
                        theme.getDefaultButtonGradientColor2()
                      ],
                      child: Text(
                        "Medium".toUpperCase(),
                        style: TextStyle(
                            color: theme.getDefaultButtonTextColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: h5FontSize),
                      ),
                    ),
                    SizedBox(height: 25),
                    Btn(
                      onTap: () {
                        if (inGame) {
                          showInGamePopUp("Hard");
                        } else {
                          boardService.setInGame(true);
                          boardService.setGameMode(GameMode.Solo);
                          boardService.setGameDifficulty(Difficulty.Hard);
                          soundService.playSound('sounds/click');

                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => GamePage(),
                            ),
                          );
                        }
                      },
                      height: btnHeight,
                      width: btnWidth,
                      borderRadius: 200,
                      gradient: [
                        theme.getDefaultButtonGradientColor1(),
                        theme.getDefaultButtonGradientColor2()
                      ],
                      child: Text(
                        "Hard".toUpperCase(),
                        style: TextStyle(
                            color: theme.getDefaultButtonTextColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: h5FontSize),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 40, 30, 20),
                      child: Text(
                        "Play with friends",
                        style: TextStyle(
                            color: theme.getgameTypePageTitleColor(),
                            fontWeight: FontWeight.w500,
                            fontSize: h3FontSize,
                            fontFamily: 'DancingScript'),
                      ),
                    ),
                    Btn(
                      onTap: () {
                        if (inGame) {
                          showInGamePopUp("TwoPlayers");
                        } else {
                          boardService.setInGame(true);
                          boardService.setGameMode(GameMode.TwoPlayers);
                          soundService.playSound('sounds/click');

                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => GamePage(),
                            ),
                          );
                        }
                      },
                      height: btnHeight,
                      width: btnWidth,
                      borderRadius: 200,
                      gradient: [
                        theme.getDefaultButtonGradientColor1(),
                        theme.getDefaultButtonGradientColor2()
                      ],
                      child: Text(
                        "2 Players".toUpperCase(),
                        style: TextStyle(
                            color: theme.getDefaultButtonTextColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: h5FontSize),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: AdmobBanner(
                  adUnitId: adMobService.getBannerAdId(),
                  adSize: AdmobBannerSize.FULL_BANNER,
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
            style: TextStyle(
                color: theme.getDefaultButtonTextColor(),
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                0.1,
                0.8
              ],
              colors: [
                theme.getDefaultButtonGradientColor1(),
                theme.getDefaultButtonGradientColor2()
              ]),
          radius: BorderRadius.circular(200),
          onPressed: () {
            boardService.setGameMode(GameMode.Solo);

            if (gameType == "Easy")
              boardService.setGameDifficulty(Difficulty.Easy);
            else if (gameType == "Medium")
              boardService.setGameDifficulty(Difficulty.Medium);
            else if (gameType == "Hard")
              boardService.setGameDifficulty(Difficulty.Hard);
            else if (gameType == "TwoPlayers")
              boardService.setGameMode(GameMode.TwoPlayers);

            boardService.newGame(true);
            soundService.playSound('sounds/click');

            interstitialAd.show();

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
            style: TextStyle(
                color: theme.getDefaultButtonTextColor(),
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.1, 0.8],
            colors: [
              theme.getDefaultButtonGradientColor1(),
              theme.getDefaultButtonGradientColor2()
            ],
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
        padding: EdgeInsets.fromLTRB(15, 30, 15, 15),
        child: Text(
          "Do you want to continue?",
          style: TextStyle(
              color: theme.getDefaultPopupTextColor(),
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
      ),
    ).show();
  }
}
