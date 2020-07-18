import 'package:eigenstate/theme/theme.dart';
import 'package:flutter/material.dart';

class HowToPlayPage extends StatefulWidget {
  @override
  HowToPlayState createState() => HowToPlayState();
}

class HowToPlayState extends State<HowToPlayPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.65],
            colors: [
              Themes.p1Grey,
              Themes.p1Blue,
            ],
          )),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      alignment: Alignment.center,
                      child: Text(
                        "How to play",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 55,
                            fontWeight: FontWeight.w700,
                            fontFamily: "DancingScript"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Text(
                        "      Eigenstate is a two-player abstract strategy game with incredibly simple rules that grows in complexity as you play.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Rules",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Setup",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Text(
                        "      Each player have sic pieces and each one has twenty five pins. Every piece starts with two pin in it: pin in the center represents its position on the board, and one additional allowing the piece to move one space forward.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(50, 0, 50, 30),
                      child: Image.asset('assets/images/board.png'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Gameplay",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Text(
                        "      On a player's turn, in this order, if possible, they must:\n  1.  Firstly, move one of their pieces.\n  2. Then place two pins in any of their pieces.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Piece Movement",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                      child: Text(
                        "      All pins in a piece other than the center pins represent the possible moves that piece can take, relative to its position on the board, (represented by its center pin).",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: Text(
                        "      For example, the board below, the black player has taken their first turn. He moved piece (1), and then added a pin to that piece, as well as in another piece (2). In subsequent turns, that piece (1) can now potentially move to spaces (a) and (b), and piece (2) to spaces (c), and (d).",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(50, 0, 50, 30),
                      child: Image.asset('assets/images/movement.png'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Constraints",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                      child: Text(
                        "      - Pins are never removed from a piece, so each piece will always be able to move one space forward throughout the game.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                      child: Text(
                        "      - Pieces can jump over other pieces.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                      child: Text(
                        "      - Pieces cannot move off the game board.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                      child: Text(
                        "      - Pieces do not rotate.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                      child: Text(
                        "      - A piece cannot move backwards unless there is a pin behind the piece's center pin.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: Text(
                        "      - When a piece is moved onto another piece, the other piece is removed from the game. Yes, it is possible to capture your own pieces. Though it's probably a bad idea.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pin Placement",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                      child: Text(
                        "      Pins have to be placed into empty holes in your own pieces, and only into pieces that have not yet been captured.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                      child: Text(
                        "      - You can place your two pins on different pieces on the same turn.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: Text(
                        "      - You do not need to place either of the pins on the piece you just moved.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Goal",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                      child: Text(
                        "      If you reduce your opponent to just one piece remaining, you win the game.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 50),
                      child: Text(
                        "      Secondary goal: In a game where both players have exactly two pieces remaining, a player may instead win the game by filling one of their remaining pieces with pins.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
