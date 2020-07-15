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

          bool hasTransform = false;

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
//                          if (board[i][j].own$.value == null) return;
//                          if (board[i][j].own$.value != boardService.getPlaying()) return;

                                      print("Clicked on piece " +
                                          i.toString() +
                                          " " +
                                          j.toString());
                                      int ret = boardService.handleClick(i, j);
                                      if (ret == 1) {
                                        showPiecePopUp(i, j);
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

  showPiecePopUp(int i, int j) async {
    List<List<Pin>> pins = boardService.getPiecePins(i, j);

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
              radius: 0.05,
              colors: [Colors.transparent, Colors.red],
              stops: [1, 1],
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 200 / 2 - 3,
                top: 200 / 2 - 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.1, 0.8],
                      colors: [Colors.white, Colors.green],
                    ),
                  ),
                  height: 5,
                  width: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((val) {
      boardService.popUpClosed();
    });
  }
}
