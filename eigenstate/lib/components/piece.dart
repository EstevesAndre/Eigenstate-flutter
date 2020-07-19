import 'package:flutter/material.dart';
import 'package:eigenstate/theme/theme.dart';

import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/piece.dart';

class Piece extends StatelessWidget {
  final double size;
  final Color color;

  final PieceService item;

  Piece(this.size, this.color, this.item);

  @override
  Widget build(BuildContext context) {
    return createPieceWidget(size, color, item, true);
  }

  static Widget _buildPin(int i, int j, Player p, Pin pin) {
    double size = 4;

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

  static Widget createPieceWidget(double size, Color color, PieceService item, bool isBoard) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
        gradient: RadialGradient(
          radius: isBoard ? 0.05 : 0,
          colors: [Colors.transparent, color],
          stops: [1, 1],
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(4),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: item.piece$.value
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
                      (j, it) => MapEntry(
                    j,
                    i == 2 && j == 2 && isBoard
                        ? Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Themes.p1Orange,
                      ),
                    )
                        : !isBoard && it == Pin.Disable ? Container(width: 4, height: 4) : _buildPin(i, j, item.own$.value, it),
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

  static Widget scorePiece(double size, Color color, int number, Player p) {
    PieceService ps = PieceService.number(number, p);
    return createPieceWidget(size, color, ps, false);
  }
}
