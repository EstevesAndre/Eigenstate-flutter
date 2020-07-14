import 'package:flutter/material.dart';
import 'package:eigenstate/theme/theme.dart';

import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/piece.dart';

class Piece extends StatelessWidget {

  final double size;
  final Color color;

  final PieceService item;

  Piece(this.size, this.color, this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
        gradient: RadialGradient(
          radius: 0.05,
          colors: [Colors.transparent, color],
          stops: [1, 1],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: size/2 - 3,
            top: size/2 - 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.1, 0.8],
                  colors: [
                    Colors.white,
                    Colors.green
                  ],
                ),
              ),
              height: 5,
              width: 5,
            ),
          ),
          Text(
            item.id$.value.toString()
          )
        ],
      ),
    );
  }
}