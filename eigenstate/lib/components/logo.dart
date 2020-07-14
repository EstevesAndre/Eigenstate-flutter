import 'package:eigenstate/theme/theme.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Mudar isto depois
    return Stack(
      children: <Widget>[
        Container(
          height: 200,
          width: 200,
          child: Stack(
            fit: StackFit.loose,
            overflow: Overflow.clip,
            children: <Widget>[
              Positioned(
                left: 25,
                right: 25,
                top: 25,
                bottom: 25,
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(45 / 360),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
                      color: Colors.white.withOpacity(1),
                    ),
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.center,
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(45 / 360),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Themes.p1Purple.withOpacity(.9),
                      ),
                      height: 15,
                      width: 15,
                    ),
                  ),
                ),
              ),
//              Positioned(
//                bottom: 94,
//                left: 15,
//                child: Container(
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(100),
//                    color: Colors.orange.withOpacity(.8),
//                  ),
//                  height: 12,
//                  width: 12,
//                ),
//              ),
//              Positioned(
//                bottom: 94,
//                right: 15,
//                child: Container(
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(100),
//                    color: Colors.orange.withOpacity(.8),
//                  ),
//                  height: 12,
//                  width: 12,
//                ),
//              ),
//              Positioned(
//                bottom: 75,
//                right: 35,
//                child: Container(
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(100),
//                    color: Colors.orange.withOpacity(.8),
//                  ),
//                  height: 12,
//                  width: 12,
//                ),
//              ),
            ],
          ),
        )
      ],
    );
  }
}
