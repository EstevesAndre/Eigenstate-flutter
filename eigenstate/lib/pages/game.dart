import 'package:admob_flutter/admob_flutter.dart';
import 'package:eigenstate/components/board.dart';
import 'package:eigenstate/components/piece.dart';
import 'package:eigenstate/pages/home.dart';
import 'package:eigenstate/services/alert.dart';
import 'package:eigenstate/services/store.dart';
import 'package:eigenstate/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/cupertino.dart';

import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/services/admob.dart';

class GamePage extends StatefulWidget {
  @override
  GameState createState() => GameState();
}

class GameState extends State<GamePage> {
  final debugMode = false;
  final boardService = locator<BoardService>();
  final alertService = locator<AlertService>();
  final adMobService = locator<AdMobService>();
  final storeService = locator<StoreService>();

  @override
  void initState() {
    super.initState();
    storeService.updateIntValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    final h5FontSize = MediaQuery.of(context).size.height / 35;
    final my3Size = MediaQuery.of(context).size.width / 40;
    final my4Size = MediaQuery.of(context).size.width / 35;

    double pieceSize;
    double pinSize;

    if (MediaQuery.of(context).size.aspectRatio > 0.6) {
      pieceSize = MediaQuery.of(context).size.height / 12;
      pinSize = MediaQuery.of(context).size.width / 110;
    } else {
      pieceSize = MediaQuery.of(context).size.height / 15;
      pinSize = MediaQuery.of(context).size.width / 100;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: StreamBuilder<
                MapEntry<
                    MapEntry<MapEntry<int, int>,
                        MapEntry<MapEntry<int, Player>, String>>,
                    int>>(
          stream: Rx.combineLatest3(boardService.score$, boardService.rounds$,
              storeService.coins$, (a, b, c) => MapEntry(MapEntry(a, b), c)),
          builder: (context,
              AsyncSnapshot<
                      MapEntry<
                          MapEntry<MapEntry<int, int>,
                              MapEntry<MapEntry<int, Player>, String>>,
                          int>>
                  snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final int p1Score = snapshot.data.key.key.key;
            final int p2Score = snapshot.data.key.key.value;
            final GameMode gameMode = boardService.getGameMode();
            final MapEntry<int, String> gameDifficulty =
                boardService.getGameDifficulty();
            final int round = snapshot.data.key.value.key.key;
            final int onPlayerSwitch =
                snapshot.data.key.value.key.value.index + 1;
            final Player playing = snapshot.data.key.value.key.value;
            final int coins = snapshot.data.value;
            final String roundTooltip = snapshot.data.key.value.value;

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
                    child: gameMode == GameMode.TwoPlayers
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                  child: Text(
                                    "Player 1",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: h5FontSize),
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
                                    child: Piece.scorePiece(
                                        pieceSize,
                                        pieceSize,
                                        pinSize,
                                        Themes.p1Grey,
                                        p1Score,
                                        Player.P2),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.fromLTRB(
                                    20, my3Size, 20, my3Size),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        size: h5FontSize,
                                      ),
                                      color: Colors.white,
                                      onPressed: () {
                                        soundService.playSound('sounds/click');

                                        Navigator.pushReplacement(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                        );
                                      },
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.toys,
                                          color: Colors.redAccent,
                                          size: h5FontSize,
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          coins.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: h5FontSize),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 15),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Mode: ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: h5FontSize),
                                        ),
                                        Text(
                                          gameDifficulty.value,
                                          style: TextStyle(
                                              color: gameDifficulty.key == 1
                                                  ? Colors.lightGreenAccent
                                                  : gameDifficulty.key == 2
                                                      ? Colors.yellowAccent
                                                      : Colors.redAccent,
                                              fontSize: h5FontSize),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(20, my4Size, 20, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 0, 15),
                                            child: Text(
                                              "You",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: h5FontSize),
                                            ),
                                          ),
                                          AnimatedSwitcher(
                                            duration: Duration(seconds: 1),
                                            transitionBuilder: (Widget child,
                                                    Animation<double>
                                                        animation) =>
                                                RotationTransition(
                                                    turns: animation,
                                                    child: child),
                                            child: Container(
                                              key: ValueKey<int>(p1Score + 1),
                                              child: Piece.scorePiece(
                                                  pieceSize,
                                                  pieceSize,
                                                  pinSize,
                                                  Themes.p1Grey,
                                                  p1Score,
                                                  Player.P2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 15),
                                              child: Text(
                                                "Turn",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: h5FontSize),
                                              ),
                                            ),
                                            AnimatedSwitcher(
                                              duration: Duration(seconds: 1),
                                              transitionBuilder: (Widget child,
                                                      Animation<double>
                                                          animation) =>
                                                  RotationTransition(
                                                      turns: animation,
                                                      child: child),
                                              child: (round ~/ 10 == 0
                                                  ? Container(
                                                      key: ValueKey<int>(round),
                                                      child: Piece.scorePiece(
                                                          pieceSize,
                                                          pieceSize,
                                                          pinSize,
                                                          Themes.p1Grey,
                                                          round,
                                                          Player.P2),
                                                    )
                                                  : Row(
                                                      key: ValueKey<int>(round),
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Piece.scorePiece(
                                                            pieceSize * 4 / 5,
                                                            pieceSize,
                                                            pinSize,
                                                            Themes.p1Grey,
                                                            round ~/ 10,
                                                            Player.P2),
                                                        SizedBox(width: 10),
                                                        Piece.scorePiece(
                                                            pieceSize * 4 / 5,
                                                            pieceSize,
                                                            pinSize,
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 0, 15),
                                            child: Text(
                                              "AI",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: h5FontSize),
                                            ),
                                          ),
                                          AnimatedSwitcher(
                                            duration: Duration(seconds: 1),
                                            transitionBuilder: (Widget child,
                                                    Animation<double>
                                                        animation) =>
                                                RotationTransition(
                                                    turns: animation,
                                                    child: child),
                                            child: Container(
                                              key: ValueKey<int>(p2Score + 1),
                                              child: Piece.scorePiece(
                                                  pieceSize,
                                                  pieceSize,
                                                  pinSize,
                                                  Themes.p1Grey,
                                                  p2Score,
                                                  Player.P2),
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
                  ),
                  gameMode == GameMode.TwoPlayers
                      ? AnimatedSwitcher(
                          duration: Duration(
                              milliseconds:
                                  gameMode == GameMode.TwoPlayers ? 400 : 600),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) =>
                                  FadeTransition(
                                      opacity: Tween(
                                        begin: 0.0,
                                        end: 1.0,
                                      ).animate(animation),
                                      child: child),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                            key: ValueKey<int>(onPlayerSwitch),
                            child: Text(
                              playing == Player.P1
                                  ? "Your turn"
                                  : "Oponnent turn",
                              style: TextStyle(
                                  color: Colors.white, fontSize: h5FontSize),
                            ),
                          ),
                        )
                      : AnimatedSwitcher(
                          duration: Duration(
                              milliseconds:
                                  gameMode == GameMode.TwoPlayers ? 400 : 1000),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) =>
                                  FadeTransition(
                                      opacity: Tween(
                                        begin: 0.0,
                                        end: 1.0,
                                      ).animate(animation),
                                      child: child),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                            key: ValueKey<int>(roundTooltip[0] == 'M' ? 1 : 2),
                            child: Text(
                              roundTooltip,
                              style: TextStyle(
                                  color: Colors.white, fontSize: h5FontSize),
                            ),
                          ),
                        ),
                  Expanded(
                    child: Board(),
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
                                              fontSize: h5FontSize),
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
                                              pieceSize,
                                              pieceSize,
                                              pinSize,
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
                                    playing == Player.P2
                                        ? "Your turn"
                                        : "Oponnent turn",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: h5FontSize),
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
