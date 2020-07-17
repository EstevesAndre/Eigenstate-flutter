import 'package:eigenstate/components/piece.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/alert.dart';
import 'package:eigenstate/services/piece.dart';

import 'package:eigenstate/theme/theme.dart';

class Board extends StatefulWidget {
  Board({Key key}) : super(key: key);

  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final boardService = locator<BoardService>();
  final alertService = locator<AlertService>();

  @override
  Widget build(BuildContext context) {
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

          if (state.key == BoardState.EndGame) {
            boardService.resetBoard();

            String title = 'Winner';

            if (state.value == null) {
              title = "Draw";
            }
          }

          final bool hasTransform = boardService.thirdDimension$.value;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, hasTransform ? 0.07 : 0.0)
              ..rotateX(hasTransform ? -0.01 : 0.0),
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
                                        soundService.playSound('slide');
                                      } else {
                                        soundService.playSound('click');
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

    return Container(
      decoration: BoxDecoration(
        color: Themes.p1Orange,
        border: border,
      ),
      height: size,
      width: size,
      child: Center(
        child: item.own$.value == null
            ? null
            : Piece(
                size * 5 / 6,
                item.own$.value == Player.P1 ? Themes.p1Blue : Themes.p1Grey,
                item),
      ),
    );
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
}
