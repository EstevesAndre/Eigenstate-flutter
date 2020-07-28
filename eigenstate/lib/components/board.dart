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
import 'package:eigenstate/services/admob.dart';

import 'package:eigenstate/theme/theme.dart';

class Board extends StatefulWidget {
  Board({Key key}) : super(key: key);

  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  final debugMode = true;
  final boardService = locator<BoardService>();
  final alertService = locator<AlertService>();
  final adMobService = locator<AdMobService>();
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
      case AdmobAdEvent.rewarded:
        print("HEREEE");
        // TODO add coins to "store"
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
    final bool hasTransform = boardService.thirdDimension$.value;
    final GameMode gameMode = boardService.getGameMode();
    bool waitingForAnswer = false;

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

          if (state.key == BoardState.EndGame && !waitingForAnswer) {
            waitingForAnswer = true;
            WidgetsBinding.instance.addPostFrameCallback((_) => Future.delayed(
                const Duration(seconds: 1),
                () => Alert(
                      context: context,
                      title: state.value == Player.P1
                          ? "Player 1 Won!"
                          : "Player 2 Won!",
                      style: alertService.resultAlertStyle,
                      type: AlertType.success,
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Continue".toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              stops: [0.1, 0.8],
                              colors: [Themes.p1Grey, Themes.p1Blue]),
                          radius: BorderRadius.circular(200),
                          onPressed: () {
                            Navigator.pop(context);
                            showRewardDialog();
                          },
                        )
                      ],
                      content: Padding(
                        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                        child: Text(
                          "Congratulations",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ).show()));
          }

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, hasTransform && gameMode != GameMode.TwoPlayers ? 0.07 : 0.0)
              ..rotateX(hasTransform && gameMode != GameMode.TwoPlayers ? -0.01 : 0.0),
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
                                        showPiecePopUp(i, j, item);
                                      }
                                    },
                                    child: _buildBox(i, j, item),
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

  Widget _buildBox(int i, int j, PieceService item) {
    BoxBorder border = Border();
    BorderSide borderStyle = BorderSide(width: 3, color: Colors.black26);
    double size = 50;

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
          color: (i + j) % 2 == 0 ? Themes.p1Orange : Themes.p1Orange2,
          border: border,
        ),
        height: size,
        width: size,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 750),
          color: item.toAnimate$.value
              ? Colors.lightGreenAccent
              : Colors.transparent,
          curve: Curves.ease,
          child: Center(
            child: item.own$.value == null
                ? null
                : Piece(
                    size * 5 / 6,
                    item.own$.value == Player.P1
                        ? Themes.p1Blue
                        : Themes.p1Grey,
                    item),
          ),
        ),
      ),
    );
  }

  Widget _buildPin(int i, int j, double size, Player p, Pin pin) {
    return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: p == Player.P1
              ? (pin == Pin.Active ? Themes.p1PinSelected : Themes.p1PinEmpty)
              : (pin == Pin.Active ? Themes.p2PinSelected : Themes.p2PinEmpty),
        ));
  }

  showPiecePopUp(int i, int j, PieceService item) async {
    Player p = item.own$.value;
    double size = 20;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        contentPadding: EdgeInsets.all(0),
        content: Container(
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
            gradient: RadialGradient(
              radius: 0.0,
              colors: [
                Colors.transparent,
                p == Player.P1 ? Themes.p1Blue : Themes.p1Grey
              ],
              stops: [1, 1],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: p == Player.P2 ? Themes.p1Blue : Themes.p1Grey,
                  spreadRadius: 5.0,
                  offset: Offset(5.0, 5.0))
            ],
          ),
          child: Container(
            margin: EdgeInsets.all(25),
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
                                      showPiecePopUp(i, j, item);
                                    }
                                  },
                                  child: i == 2 && j == 2
                                      ? Container(
                                          width: size,
                                          height: size,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Themes.p1Orange,
                                          ),
                                        )
                                      : _buildPin(i, j, size, p, pin),
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

  showRewardDialog() async {
    Alert(
      context: context,
      title: "Nice job",
      type: AlertType.success,
      style: alertService.resultAlertStyle,
      buttons: [
        DialogButton(
          child: Text(
            "+ 40",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.1, 0.8],
              colors: [Themes.p1Grey, Themes.p1Blue]),
          radius: BorderRadius.circular(200),
          onPressed: () async {
            soundService.playSound('sounds/click');
            Navigator.pop(context);

            if (await interstitialAd.isLoaded) {
              interstitialAd.show();
              showEndGamePopUp();
            } else {
              showSnackBar("Interstitial ad is still loading...");
            }
          },
        ),
        DialogButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.ondemand_video, color: Colors.white),
              Text(
                "+ 120",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.1, 0.8],
              colors: [Themes.p1Grey, Themes.p1Blue]),
          radius: BorderRadius.circular(200),
          onPressed: () async {
            soundService.playSound('sounds/click');
            Navigator.pop(context);

            if (await rewardAd.isLoaded) {
              rewardAd.show();
              showEndGamePopUp();
            } else {
              showSnackBar("Reward ad is still loading...");
            }
          },
        ),
      ],
      content: Padding(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Text(
          "Get a reward",
          style: TextStyle(
              color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500),
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
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.1, 0.8],
              colors: [Themes.p1Grey, Themes.p1Blue]),
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
            boardService.resetBoard(true);
            Navigator.pop(context);
          },
        ),
      ],
    ).show();
  }
}
