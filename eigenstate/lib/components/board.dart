import 'package:admob_flutter/admob_flutter.dart';
import 'package:eigenstate/components/piece.dart';
import 'package:eigenstate/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/alert.dart';
import 'package:eigenstate/services/piece.dart';
import 'package:eigenstate/services/store.dart';
import 'package:eigenstate/services/admob.dart';

import 'package:eigenstate/theme/theme.dart';

class Board extends StatefulWidget {
  Board({Key key}) : super(key: key);

  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> with SingleTickerProviderStateMixin {
  final debugMode = true;
  final boardService = locator<BoardService>();
  final alertService = locator<AlertService>();
  final adMobService = locator<AdMobService>();
  final storeService = locator<StoreService>();
  final theme = locator<Themes>();

  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;

  @override
  void initState() {
    super.initState();

    interstitialAd = AdmobInterstitial(
        adUnitId: adMobService.getInterstitialAdId(),
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.closed) interstitialAd.load();
          if (debugMode) handleEvent(event, args, 'Interstitial');
        });

    rewardAd = AdmobReward(
        adUnitId: adMobService.getRewardAdId(),
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.closed) rewardAd.load();
          if (debugMode) handleEvent(event, args, 'Reward');
        });

    interstitialAd.load();
    rewardAd.load();
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    rewardAd.dispose();
    super.dispose();
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) async {
    print(event);
    switch (event) {
      case AdmobAdEvent.closed:
        if (adType == "Interstitial") {
          storeService.addRewardIntToSF("coins", "WinReward");
        } else if (adType == "Reward") {
          print("Reward closed");
          storeService.addRewardIntToSF("coins", "VideoReward");
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasTransform = !boardService.thirdDimension$.value;
    final GameMode gameMode = boardService.getGameMode();

    double pieceHeight = MediaQuery.of(context).size.width / 1.4;
    double piecePadding = MediaQuery.of(context).size.width / 15.7;
    double pieceViewSize = MediaQuery.of(context).size.width / 19.64;
    double pieceSize;
    double pinSize;

    if (MediaQuery.of(context).size.aspectRatio > 0.6) {
      pieceSize =
          MediaQuery.of(context).size.width / (9 + (hasTransform ? 2 : 0));
      pinSize = MediaQuery.of(context).size.width / 110;
    } else {
      pieceSize =
          MediaQuery.of(context).size.width / (8 + (hasTransform ? 1 : 0));
      pinSize = MediaQuery.of(context).size.width / 100;
    }

    return StreamBuilder<
            MapEntry<List<List<PieceService>>, MapEntry<BoardState, Player>>>(
        stream: Rx.combineLatest2(boardService.board$, boardService.boardState$,
            (a, b) => MapEntry(a, b)),
        builder: (context,
            AsyncSnapshot<
                    MapEntry<List<List<PieceService>>,
                        MapEntry<BoardState, Player>>>
                snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final List<List<PieceService>> board = snapshot.data.key;
          final MapEntry<BoardState, Player> state = snapshot.data.value;

          if (state.key == BoardState.EndGame &&
              !boardService.waitingForAnswer$.value) {
            boardService.waitingForAnswer$.add(true);
            WidgetsBinding.instance.addPostFrameCallback((_) => Future.delayed(
                const Duration(seconds: 1),
                () => showWinDialog(state, gameMode)));
          }

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2,
                  hasTransform && gameMode != GameMode.TwoPlayers ? 0.07 : 0.0)
              ..rotateX(hasTransform && gameMode != GameMode.TwoPlayers
                  ? -0.01
                  : 0.0),
            alignment: FractionalOffset.center,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: board
                    .asMap()
                    .map(
                      (i, row) => MapEntry(
                        i,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: row
                              .asMap()
                              .map(
                                (j, item) => MapEntry(
                                  j,
                                  GestureDetector(
                                    onTap: () {
                                      print("Clicked on piece " +
                                          i.toString() +
                                          " " +
                                          j.toString());

                                      int ret = boardService.handleClick(i, j);
                                      if (ret == 1) {
                                        showPiecePopUp(i, j, pieceHeight,
                                            piecePadding, pieceViewSize, item);
                                      } else if (ret == 4) {
                                        showWinDialog(state, gameMode);
                                      }
                                    },
                                    child: _buildBox(
                                        i, j, item, pieceSize, pinSize),
                                  ),
                                ),
                              )
                              .values
                              .toList(),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ),
          );
        });
  }

  Widget _buildBox(
      int i, int j, PieceService item, double pieceSize, double pinSize) {
    BoxBorder border = Border();
    BorderSide borderStyle =
        BorderSide(width: 2, color: theme.getBoardBorderColor());

    border = Border(
        top: i == 0 ? borderStyle : BorderSide.none,
        bottom: borderStyle,
        left: j == 0 ? borderStyle : BorderSide.none,
        right: borderStyle);

    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      child: Container(
        key: ValueKey<int>(
            item.pieceMoved$.value ? i * 6 + j * 2 + 1 : i * 6 + j),
        decoration: BoxDecoration(
          color: (i + j) % 2 == 0
              ? theme.getBoardEmptyCellColor1()
              : theme.getBoardEmptyCellColor2(),
          border: border,
        ),
        height: pieceSize,
        width: pieceSize,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 750),
          color: item.own$.value == Player.P1
              ? item.toAnimate$.value
                  ? theme.getBoardP1PieceHighlightColor1()
                  : theme.getBoardP1PieceHighlightColor2()
              : item.toAnimate$.value
                  ? theme.getBoardP2PieceHighlightColor1()
                  : theme.getBoardP2PieceHighlightColor2(),
          curve: Curves.ease,
          child: Center(
            child: item.own$.value == null
                ? null
                : Piece(
                    pieceSize * 5 / 6,
                    pinSize,
                    item.own$.value == Player.P1
                        ? theme.getBoardP1PieceColor()
                        : theme.getBoardP2PieceColor(),
                    item),
          ),
        ),
      ),
    );
  }

  Widget buildPin(int i, int j, double size, Player p, Pin pin) {
    return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: p == Player.P1
              ? (pin == Pin.Active
                  ? theme.getBoardP1PegColor()
                  : theme.getBoardP1EmptyPegColor())
              : (pin == Pin.Active
                  ? theme.getBoardP2PegColor()
                  : theme.getBoardP2EmptyPegColor()),
        ));
  }

  showPiecePopUp(int i, int j, double pieceHeight, double piecePadding,
      double pieceSize, PieceService item) async {
    Player p = item.own$.value;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        contentPadding: EdgeInsets.all(0),
        content: Container(
          height: pieceHeight,
          width: pieceHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
            color: p == Player.P1
                ? theme.getBoardP1PieceColor()
                : theme.getBoardP2PieceColor(),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: p == Player.P2
                      ? theme.getBoardP1PieceColor()
                      : theme.getBoardP2PieceColor(),
                  spreadRadius: 5.0,
                  offset: Offset(5.0, 5.0))
            ],
          ),
          child: Container(
            margin: EdgeInsets.all(piecePadding),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: item
                  .getPins()
                  .asMap()
                  .map(
                    (i, row) => MapEntry(
                      i,
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: row
                            .asMap()
                            .map(
                              (j, pin) => MapEntry(
                                j,
                                GestureDetector(
                                  onTap: () {
                                    print("Clicked on pin " +
                                        i.toString() +
                                        " " +
                                        j.toString());
                                    boardService.popUpOpened();
                                    int ret = boardService.handleClick(i, j);
                                    if (ret == 2)
                                      Navigator.pop(context);
                                    else if (ret == 3) {
                                      Navigator.pop(context);
                                      showPiecePopUp(i, j, pieceHeight,
                                          piecePadding, pieceSize, item);
                                    }
                                  },
                                  child: i == 2 && j == 2
                                      ? Container(
                                          width: pieceSize,
                                          height: pieceSize,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                pieceSize),
                                            color: p == Player.P1
                                                ? theme.getBoardP1CenterColor()
                                                : theme.getBoardP2CenterColor(),
                                          ),
                                        )
                                      : buildPin(i, j, pieceSize, p, pin),
                                ),
                              ),
                            )
                            .values
                            .toList(),
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          ),
        ),
      ),
    ).then((val) {
      boardService.popUpClosed();
    });
  }

  showWinDialog(MapEntry<BoardState, Player> state, GameMode gameMode) {
    String title, desc;

    if (gameMode == GameMode.TwoPlayers) {
      title = state.value == Player.P1 ? "Player 1 Won!" : "Player 2 Won!";
      desc = "Congratulations";
    } else {
      title = state.value == Player.P1 ? "You Won!" : "AI Won!";
      desc = state.value == Player.P1 ? "Congratulations" : "Defeat me now";
    }

    return Alert(
      context: context,
      title: title,
      style: alertService.resultAlertStyle,
      type: AlertType.success,
      buttons: [
        DialogButton(
          child: Text(
            "Continue".toUpperCase(),
            style: TextStyle(
                color: theme.getDefaultTextColor(),
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
            Navigator.pop(context);
            gameMode == GameMode.TwoPlayers
                ? showEndGamePopUp()
                : showRewardDialog();
          },
        )
      ],
      content: Padding(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Text(
          desc,
          style: TextStyle(
              color: theme.getDefaultPopupTextColor(),
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
      ),
    ).show();
  }

  showRewardDialog() async {
    int tries = 0;

    Alert(
      context: context,
      title: "Nice job",
      type: AlertType.success,
      style: alertService.resultAlertStyle,
      buttons: [
        DialogButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.toys,
                color: theme.getGamePageConcurrencyColor(),
              ),
              Text(
                " +" + storeService.endGameBonus.toString(),
                style: TextStyle(
                    color: theme.getDefaultButtonTextColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ],
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
          onPressed: () async {
            soundService.playSound('sounds/click');
            Navigator.pop(context);

            if (await interstitialAd.isLoaded) {
              interstitialAd.show();
              showEndGamePopUp();
            }
          },
        ),
        DialogButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.ondemand_video,
                color: theme.getDefaultButtonTextColor(),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.toys,
                    color: theme.getGamePageConcurrencyColor(),
                  ),
                  Text(
                    " +" + storeService.endGameBonus.toString(),
                    style: TextStyle(
                        color: theme.getDefaultButtonTextColor(),
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
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
          onPressed: () async {
            soundService.playSound('sounds/click');

            if (await rewardAd.isLoaded) {
              Navigator.pop(context);
              rewardAd.show();
              showEndGamePopUp();
            } else {
              tries++;
              print("Reward video is still loading... " + tries.toString());

              if (tries == 3) {
                Navigator.pop(context);
                interstitialAd.show();
                showEndGamePopUp();
              }
            }
          },
        ),
      ],
      content: Padding(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Text(
          "Get a reward",
          style: TextStyle(
              color: theme.getDefaultPopupTextColor(),
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
      ),
    ).show();
  }

  showEndGamePopUp() {
    Alert(
      context: context,
      title: "Nice job",
      desc: "Do you want to continue?",
      type: AlertType.info,
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
            boardService.newGame(false);
            soundService.playSound('sounds/click');
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => HomePage(),
                ));
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
            soundService.playSound('sounds/click');
            boardService.resetBoard(true);
            Navigator.pop(context);
          },
        ),
      ],
    ).show();
  }
}
