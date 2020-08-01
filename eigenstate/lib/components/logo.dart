import 'package:eigenstate/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:eigenstate/services/piece.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PieceService piece = PieceService.logo();
    final double pinSize = MediaQuery.of(context).size.height / 50;
    final double containerSize = MediaQuery.of(context).size.height / 4;
    final double borderRadius = MediaQuery.of(context).size.width / 80;

    Widget _buildPin(int i, int j, Pin pin) {
      return Container(
        height: pinSize,
        width: pinSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.65],
            colors: [
              Themes.p1Grey,
              Themes.p1Blue,
            ],
          ),
        ),
      );
    }

    return Container(
      height: containerSize,
      width: containerSize,
      child: RotationTransition(
        turns: AlwaysStoppedAnimation(45 / 360),
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.elliptical(borderRadius, borderRadius)),
            gradient: RadialGradient(
              radius: 0.04,
              colors: [Colors.transparent, Colors.white],
              stops: [1, 1],
            ),
          ),
          margin: EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: piece.piece$.value
                .asMap()
                .map(
                  (i, row) => MapEntry(
                    i,
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: row
                          .asMap()
                          .map(
                            (j, it) => MapEntry(
                              j,
                              i == 2 && j == 2
                                  ? Container(
                                      height: pinSize,
                                      width: pinSize,
                                    )
                                  : it == Pin.Disable
                                      ? Container(
                                          width: pinSize, height: pinSize)
                                      : _buildPin(i, j, it),
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
    );
  }
}
