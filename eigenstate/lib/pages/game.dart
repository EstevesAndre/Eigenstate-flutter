import 'package:admob_flutter/admob_flutter.dart';
import 'package:eigenstate/components/board.dart';
import 'package:eigenstate/components/piece.dart';
import 'package:eigenstate/services/alert.dart';
import 'package:eigenstate/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/services/admob.dart';

class GamePage extends StatefulWidget {
  @override
  GameState createState() => GameState();
}

class GameState extends State<GamePage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  final debugMode = false;
  final boardService = locator<BoardService>();
  final alertService = locator<AlertService>();
  final adMobService = locator<AdMobService>();

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
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
            final GameMode gameMode = boardService.getGameMode();
            final int round = snapshot.data.value.key;
            final int onPlayerSwitch = snapshot.data.value.value.index + 1;
            final String playing = snapshot.data.value.value == Player.P1
                ? "Your turn"
                : "AI turn";
            final Player pPlaying = snapshot.data.value.value;

            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 1],
                colors: [
                  Themes.p1Purple,
                  Themes.p1Blue,
                ],
              )),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: gameMode == GameMode.TwoPlayers
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          )
                        : Row(
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
                                        "AI",
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
                    duration: Duration(
                        milliseconds:
                            gameMode == GameMode.TwoPlayers ? 400 : 750),
                    transitionBuilder: (Widget child,
                            Animation<double> animation) =>
                        SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0.0,
                                  gameMode == GameMode.TwoPlayers ? 1.0 : 4.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                      key: ValueKey<int>(onPlayerSwitch),
                      child: Text(
                        pPlaying == Player.P1
                            ? "Your turn"
                            : gameMode == GameMode.TwoPlayers
                                ? "Oponnent turn"
                                : playing,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Board()],
                    ),
                  ),
                  gameMode == GameMode.TwoPlayers
                      ? RotationTransition(
                          turns: AlwaysStoppedAnimation(180 / 360),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 15),
                                        child: Text(
                                          "Player 2",
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
                                        child: Container(
                                          key: ValueKey<int>(p2Score + 1),
                                          child: Piece.scorePiece(
                                              50,
                                              50,
                                              Themes.p1Grey,
                                              p2Score,
                                              Player.P2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: Duration(
                                    milliseconds:
                                        gameMode == GameMode.TwoPlayers
                                            ? 400
                                            : 750),
                                transitionBuilder: (Widget child,
                                        Animation<double> animation) =>
                                    SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(
                                              0.0,
                                              gameMode == GameMode.TwoPlayers
                                                  ? 1.0
                                                  : 4.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                                  key: ValueKey<int>(onPlayerSwitch),
                                  child: Text(
                                    pPlaying == Player.P2
                                        ? "Your turn"
                                        : gameMode == GameMode.TwoPlayers
                                            ? "Oponnent turn"
                                            : playing,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          child: AdmobBanner(
                          adUnitId: adMobService.getBannerAdId(),
                          adSize: AdmobBannerSize.FULL_BANNER,
                          listener: debugMode
                              ? (AdmobAdEvent event,
                                  Map<String, dynamic> args) {
                                  handleEvent(event, args, 'Banner');
                                }
                              : null,
                        )),
                ],
              ),
            );
          },
        )),
      ),
    );
  }
}
