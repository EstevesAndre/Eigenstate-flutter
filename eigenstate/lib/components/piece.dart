import 'package:flutter/material.dart';
import 'package:eigenstate/theme/theme.dart';

import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/piece.dart';

class Piece extends StatelessWidget {
  final double size;
  final double pinSize;
  final Color color;

  final PieceService item;

  Piece(this.size, this.pinSize, this.color, this.item);

  @override
  Widget build(BuildContext context) {
    return createPieceWidget(size, size, pinSize, color, item, true);
  }

  static Widget buildPin(int i, int j, double size, Player p, Pin pin) {
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

  static Widget createPieceWidget(double width, double height, double pinSize,
      Color color, PieceService item, bool isBoard) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
          gradient: RadialGradient(
            radius: isBoard ? 0.05 : 0,
            colors: [Colors.transparent, color],
            stops: [1, 1],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: color == Themes.p1Blue ? Themes.p1Grey : Themes.p1Blue,
                spreadRadius: 1.0,
                offset: Offset(1.0, 1.0))
          ]),
      child: Container(
        margin: EdgeInsets.all(pinSize),
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
                                    height: pinSize,
                                    width: pinSize,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Themes.p1Orange,
                                    ),
                                  )
                                : !isBoard && it == Pin.Disable
                                    ? Container(width: pinSize, height: pinSize)
                                    : buildPin(
                                        i, j, pinSize, item.own$.value, it),
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

  static Widget scorePiece(double width, double height, double pinSize,
      Color color, int number, Player p) {
    PieceService ps = PieceService.number(number, p);
    return createPieceWidget(width, height, pinSize, color, ps, false);
  }
}
