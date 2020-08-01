import 'package:eigenstate/services/provider.dart';
import 'package:flutter/material.dart';
import 'package:eigenstate/theme/theme.dart';

import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/piece.dart';

class Piece extends StatelessWidget {
  final double size;
  final double pinSize;
  final Color color;

  final PieceService item;

  static final theme = locator<Themes>();

  Piece(this.size, this.pinSize, this.color, this.item);

  @override
  Widget build(BuildContext context) {
    return createPieceWidget(
        size, size, pinSize, color, Colors.transparent, item, true);
  }

  static Widget buildPin(
      int i, int j, double size, Color color, Player p, Pin pin) {
    return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: p == Player.P1
              ? (pin == Pin.Active
                  ? (color == Colors.transparent
                      ? theme.getBoardP1PegColor()
                      : color)
                  : theme.getBoardP1EmptyPegColor())
              : (pin == Pin.Active
                  ? (color == Colors.transparent
                      ? theme.getBoardP2PegColor()
                      : color)
                  : theme.getBoardP2EmptyPegColor()),
        ));
  }

  static Widget createPieceWidget(double width, double height, double pinSize,
      Color color, Color pegColor, PieceService item, bool isBoard) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
          color: color,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: item.own$.value == Player.P2
                    ? theme.getBoardP1PieceColor()
                    : theme.getBoardP2PieceColor(),
                spreadRadius: 1.0,
                offset: Offset(1.0, 1.0))
          ]),
      child: Container(
        margin: EdgeInsets.all(pinSize / 1.5),
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
                                      borderRadius:
                                          BorderRadius.circular(pinSize),
                                      color: item.own$.value == Player.P1
                                          ? theme.getBoardP1CenterColor()
                                          : theme.getBoardP2CenterColor(),
                                    ),
                                  )
                                : !isBoard && it == Pin.Disable
                                    ? Container(width: pinSize, height: pinSize)
                                    : buildPin(i, j, pinSize, pegColor,
                                        item.own$.value, it),
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
      Color pieceColor, Color pegColor, int number, Player p) {
    PieceService ps = PieceService.number(number, p);
    return createPieceWidget(
        width, height, pinSize, pieceColor, pegColor, ps, false);
  }
}
