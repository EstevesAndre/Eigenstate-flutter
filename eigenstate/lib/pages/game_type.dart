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
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  final debugMode = false;
  final boardService = locator<BoardService>();
  final soundService = locator<SoundService>();
  final alertService = locator<AlertService>();
  final adMobService = locator<AdMobService>();
  AdmobInterstitial interstitialAd;

  @override
  void initState() {
    super.initState();

    interstitialAd = AdmobInterstitial(
        adUnitId: adMobService.getInterstitialAdId(),
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.closed) interstitialAd.load();
          if (debugMode) handleEvent(event, args, "Interstitial");
        })..load();
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: 1500),
    ));
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool inGame = boardService.checkGameInProgress();
    print("In Game: " + inGame.toString());

    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                child: Text(
                  "Game Type",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
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
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
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
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 40, 30, 20),
                      child: Text(
                        "Play with friends",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
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
                      height: 40,
                      width: 220,
                      borderRadius: 200,
                      gradient: [Themes.p1Grey, Themes.p1Blue],
                      child: Text(
                        "2 Players".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: AdmobBanner(
                  adUnitId: adMobService.getBannerAdId(),
                  adSize: AdmobBannerSize.FULL_BANNER,
                  listener: debugMode ?
                      (AdmobAdEvent event, Map<String, dynamic> args) {
                    handleEvent(event, args, 'Banner');
                  } : null,
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
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.1, 0.8],
              colors: [Themes.p1Grey, Themes.p1Blue]),
          radius: BorderRadius.circular(200),
          onPressed: () {
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
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.1, 0.8],
              colors: [Themes.p1Grey, Themes.p1Blue]),
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
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Text(
          "Do you want to continue?",
          style: TextStyle(
              color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    ).show();
  }
}
