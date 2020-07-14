import 'package:eigenstate/components/piece.dart';
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
    return StreamBuilder<MapEntry<List<List<PieceService>>, MapEntry<BoardState, Player>>>(
      stream: Rx.combineLatest2(boardService.board$, boardService.boardState$, (a, b) => MapEntry(a, b)),
      builder:(
          context,
          AsyncSnapshot<MapEntry<List<List<PieceService>>, MapEntry<BoardState, Player>>> snapshot)
      {
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

//          Widget body = state.value == 'X'
//              ? X(50, 20)
//              : (state.value == "O"
//              ? O(50, MyTheme.green)
//              : Row(
//            children: <Widget>[X(50, 20), O(50, MyTheme.green)],
//          ));

//          WidgetsBinding.instance.addPostFrameCallback((_) => {
//            Alert(
//              context: context,
//              title: title,
//              style: alertService.resultAlertStyle,
//              buttons: [],
//              content: Row(
//                  mainAxisSize: MainAxisSize.max,
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[body]),
//            ).show()
//          });
        }

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.07)
            ..rotateX(-0.01),
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
  //                          if (board[i][j] != ' ') return;
  //                          boardService.newMove(i, j);
                          print("CLICKED " + i.toString() + " " + j.toString() + "\n");
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
      }
    );
  }

  Widget _buildBox(int i, int j, PieceService item) {
    BoxBorder border = Border();
    BorderSide borderStyle = BorderSide(width: 3, color: Colors.black26);
    double size = 50;

    border = Border(
      top: i == 0 ? borderStyle : BorderSide.none,
      bottom: borderStyle,
      left: j == 0 ? borderStyle : BorderSide.none,
      right: borderStyle
    );

    return Container(
      decoration: BoxDecoration(
        color: Themes.p1Orange,
        border: border,
      ),
      height: size,
      width: size,
      child: Center(
        child:
          item.own$.value == Owner.Empty ? null : Piece(size * 5/6, item.own$.value == Owner.P1 ? Themes.p1Blue : Themes.p1Grey, item),
      ),
    );
  }
}