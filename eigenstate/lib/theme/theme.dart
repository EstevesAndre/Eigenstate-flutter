import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Update each theme colors

class Theme1 {
  // 3 basics default
  static final Color p1Grey = Color(0xff3f5363);
  static final Color p1Blue = Color(0xff498c9c);
  static final Color p1Purple = Color(0xff2d2b53);

  // Game Type Page
  static final Color gameTypePageTitleColor = Colors.black;
  static final Color gameTypePageBackgroundColor = Colors.white;

  // Home Page
  static final Color homePageTitleColor = Colors.white;
  static final Color homePageButtonColor = Colors.white;
  static final Color homePageButtonIconColor = p1Grey;

  // Game Page
  static final Color gamePageBackgroundGradientColor1 = p1Purple;
  static final Color gamePageBackgroundGradientColor2 = p1Blue;
  static final Color gamePageConcurrencyColor = Colors.redAccent;
  static final Color gamePageEasyModeColor = Colors.lightGreenAccent;
  static final Color gamePageMediumModeColor = Colors.yellowAccent;
  static final Color gamePageHardModeColor = Colors.redAccent;

  // Board & Pieces
  static final Color boardEmptyCellColor1 = Color(0xffe38250);
  static final Color boardEmptyCellColor2 = Color(0xffe38f50);
  static final Color boardP1PieceColor = p1Blue;
  static final Color boardP2PieceColor = p1Grey;
  static final Color boardP1PegColor = Color(0xff14de21);
  static final Color boardP2PegColor = Color(0xff0fdba8);
  static final Color boardP1EmptyPegColor = Color(0xffebebeb);
  static final Color boardP2EmptyPegColor = Color(0xffc8d1be);
  static final Color boardP1CenterColor = Color(0xffe38250);
  static final Color boardP2CenterColor = Color(0xffe38250);
  static final Color boardBorderColor = Colors.black26;
  static final Color pieceNumberColor = p1Grey;
  static final Color pieceNumberPegColor = Colors.yellowAccent;
  static final Color boardP1PieceHighlightColor1 = Colors.lightGreenAccent;
  static final Color boardP1PieceHighlightColor2 = Colors.transparent;
  static final Color boardP2PieceHighlightColor1 = Colors.lightGreenAccent;
  static final Color boardP2PieceHighlightColor2 = Colors.transparent;

  // Default
  static final Color defaultBackgroundGradientColor1 = p1Grey;
  static final Color defaultBackgroundGradientColor2 = p1Blue;
  static final Color defaultPopupTextColor = Colors.black87;
  static final Color defaultButtonTextColor = Colors.white;
  static final Color defaultButtonGradientColor1 = p1Grey;
  static final Color defaultButtonGradientColor2 = p1Blue;
  static final Color defaultTextColor = Colors.white;
}

class Theme2 {
  // 3 basics default
  static final Color p1Grey = Color(0xff3f5363);
  static final Color p1Blue = Color(0xff498c9c);
  static final Color p1Purple = Color(0xff2d2b53);

  // Game Type Page
  static final Color gameTypePageTitleColor = Colors.black;
  static final Color gameTypePageBackgroundColor = Colors.white;

  // Home Page
  static final Color homePageTitleColor = Colors.white;
  static final Color homePageButtonColor = Colors.white;
  static final Color homePageButtonIconColor = p1Grey;

  // Game Page
  static final Color gamePageBackgroundGradientColor1 = p1Purple;
  static final Color gamePageBackgroundGradientColor2 = p1Blue;
  static final Color gamePageConcurrencyColor = Colors.redAccent;
  static final Color gamePageEasyModeColor = Colors.lightGreenAccent;
  static final Color gamePageMediumModeColor = Colors.yellowAccent;
  static final Color gamePageHardModeColor = Colors.redAccent;

  // Board & Pieces
  static final Color boardEmptyCellColor1 = Color(0xffe38250);
  static final Color boardEmptyCellColor2 = Color(0xffe38f50);
  static final Color boardP1PieceColor = p1Blue;
  static final Color boardP2PieceColor = p1Grey;
  static final Color boardP1PegColor = Color(0xff14de21);
  static final Color boardP2PegColor = Color(0xff0fdba8);
  static final Color boardP1EmptyPegColor = Color(0xffebebeb);
  static final Color boardP2EmptyPegColor = Color(0xffc8d1be);
  static final Color boardP1CenterColor = Color(0xffe38250);
  static final Color boardP2CenterColor = Color(0xffe38250);
  static final Color boardBorderColor = Colors.black26;
  static final Color pieceNumberColor = p1Grey;
  static final Color pieceNumberPegColor = Colors.yellowAccent;
  static final Color boardP1PieceHighlightColor1 = Colors.lightGreenAccent;
  static final Color boardP1PieceHighlightColor2 = Colors.transparent;
  static final Color boardP2PieceHighlightColor1 = Colors.lightGreenAccent;
  static final Color boardP2PieceHighlightColor2 = Colors.transparent;

  // Default
  static final Color defaultBackgroundGradientColor1 = p1Grey;
  static final Color defaultBackgroundGradientColor2 = p1Blue;
  static final Color defaultPopupTextColor = Colors.black87;
  static final Color defaultButtonTextColor = Colors.white;
  static final Color defaultButtonGradientColor1 = p1Grey;
  static final Color defaultButtonGradientColor2 = p1Blue;
  static final Color defaultTextColor = Colors.white;
}

class Theme3 {
  // 3 basics default
  static final Color p1Grey = Color(0xff3f5363);
  static final Color p1Blue = Color(0xff498c9c);
  static final Color p1Purple = Color(0xff2d2b53);

  // Game Type Page
  static final Color gameTypePageTitleColor = Colors.black;
  static final Color gameTypePageBackgroundColor = Colors.white;

  // Home Page
  static final Color homePageTitleColor = Colors.white;
  static final Color homePageButtonColor = Colors.white;
  static final Color homePageButtonIconColor = p1Grey;

  // Game Page
  static final Color gamePageBackgroundGradientColor1 = p1Purple;
  static final Color gamePageBackgroundGradientColor2 = p1Blue;
  static final Color gamePageConcurrencyColor = Colors.redAccent;
  static final Color gamePageEasyModeColor = Colors.lightGreenAccent;
  static final Color gamePageMediumModeColor = Colors.yellowAccent;
  static final Color gamePageHardModeColor = Colors.redAccent;

  // Board & Pieces
  static final Color boardEmptyCellColor1 = Color(0xffe38250);
  static final Color boardEmptyCellColor2 = Color(0xffe38f50);
  static final Color boardP1PieceColor = p1Blue;
  static final Color boardP2PieceColor = p1Grey;
  static final Color boardP1PegColor = Color(0xff14de21);
  static final Color boardP2PegColor = Color(0xff0fdba8);
  static final Color boardP1EmptyPegColor = Color(0xffebebeb);
  static final Color boardP2EmptyPegColor = Color(0xffc8d1be);
  static final Color boardP1CenterColor = Color(0xffe38250);
  static final Color boardP2CenterColor = Color(0xffe38250);
  static final Color boardBorderColor = Colors.black26;
  static final Color pieceNumberColor = p1Grey;
  static final Color pieceNumberPegColor = Colors.yellowAccent;
  static final Color boardP1PieceHighlightColor1 = Colors.lightGreenAccent;
  static final Color boardP1PieceHighlightColor2 = Colors.transparent;
  static final Color boardP2PieceHighlightColor1 = Colors.lightGreenAccent;
  static final Color boardP2PieceHighlightColor2 = Colors.transparent;

  // Default
  static final Color defaultBackgroundGradientColor1 = p1Grey;
  static final Color defaultBackgroundGradientColor2 = p1Blue;
  static final Color defaultPopupTextColor = Colors.black87;
  static final Color defaultButtonTextColor = Colors.white;
  static final Color defaultButtonGradientColor1 = p1Grey;
  static final Color defaultButtonGradientColor2 = p1Blue;
  static final Color defaultTextColor = Colors.white;
}

class Theme4 {
  // 3 basics default
  static final Color p1Grey = Color(0xff3f5363);
  static final Color p1Blue = Color(0xff498c9c);
  static final Color p1Purple = Color(0xff2d2b53);

  // Game Type Page
  static final Color gameTypePageTitleColor = Colors.black;
  static final Color gameTypePageBackgroundColor = Colors.white;

  // Home Page
  static final Color homePageTitleColor = Colors.white;
  static final Color homePageButtonColor = Colors.white;
  static final Color homePageButtonIconColor = p1Grey;

  // Game Page
  static final Color gamePageBackgroundGradientColor1 = p1Purple;
  static final Color gamePageBackgroundGradientColor2 = p1Blue;
  static final Color gamePageConcurrencyColor = Colors.redAccent;
  static final Color gamePageEasyModeColor = Colors.lightGreenAccent;
  static final Color gamePageMediumModeColor = Colors.yellowAccent;
  static final Color gamePageHardModeColor = Colors.redAccent;

  // Board & Pieces
  static final Color boardEmptyCellColor1 = Color(0xffe38250);
  static final Color boardEmptyCellColor2 = Color(0xffe38f50);
  static final Color boardP1PieceColor = p1Blue;
  static final Color boardP2PieceColor = p1Grey;
  static final Color boardP1PegColor = Color(0xff14de21);
  static final Color boardP2PegColor = Color(0xff0fdba8);
  static final Color boardP1EmptyPegColor = Color(0xffebebeb);
  static final Color boardP2EmptyPegColor = Color(0xffc8d1be);
  static final Color boardP1CenterColor = Color(0xffe38250);
  static final Color boardP2CenterColor = Color(0xffe38250);
  static final Color boardBorderColor = Colors.black26;
  static final Color pieceNumberColor = p1Grey;
  static final Color pieceNumberPegColor = Colors.yellowAccent;
  static final Color boardP1PieceHighlightColor1 = Colors.lightGreenAccent;
  static final Color boardP1PieceHighlightColor2 = Colors.transparent;
  static final Color boardP2PieceHighlightColor1 = Colors.lightGreenAccent;
  static final Color boardP2PieceHighlightColor2 = Colors.transparent;

  // Default
  static final Color defaultBackgroundGradientColor1 = p1Grey;
  static final Color defaultBackgroundGradientColor2 = p1Blue;
  static final Color defaultPopupTextColor = Colors.black87;
  static final Color defaultButtonTextColor = Colors.white;
  static final Color defaultButtonGradientColor1 = p1Grey;
  static final Color defaultButtonGradientColor2 = p1Blue;
  static final Color defaultTextColor = Colors.white;
}

class Theme5 {
  // 3 basics default
  static final Color p1Grey = Color(0xff3f5363);
  static final Color p1Blue = Color(0xff498c9c);
  static final Color p1Purple = Color(0xff2d2b53);

  // Game Type Page
  static final Color gameTypePageTitleColor = Colors.black;
  static final Color gameTypePageBackgroundColor = Colors.white;

  // Home Page
  static final Color homePageTitleColor = Colors.white;
  static final Color homePageButtonColor = Colors.white;
  static final Color homePageButtonIconColor = p1Grey;

  // Game Page
  static final Color gamePageBackgroundGradientColor1 = p1Purple;
  static final Color gamePageBackgroundGradientColor2 = p1Blue;
  static final Color gamePageConcurrencyColor = Colors.redAccent;
  static final Color gamePageEasyModeColor = Colors.lightGreenAccent;
  static final Color gamePageMediumModeColor = Colors.yellowAccent;
  static final Color gamePageHardModeColor = Colors.redAccent;

  // Board & Pieces
  static final Color boardEmptyCellColor1 = Color(0xffe38250);
  static final Color boardEmptyCellColor2 = Color(0xffe38f50);
  static final Color boardP1PieceColor = p1Blue;
  static final Color boardP2PieceColor = p1Grey;
  static final Color boardP1PegColor = Color(0xff14de21);
  static final Color boardP2PegColor = Color(0xff0fdba8);
  static final Color boardP1EmptyPegColor = Color(0xffebebeb);
  static final Color boardP2EmptyPegColor = Color(0xffc8d1be);
  static final Color boardP1CenterColor = Color(0xffe38250);
  static final Color boardP2CenterColor = Color(0xffe38250);
  static final Color boardBorderColor = Colors.black26;
  static final Color pieceNumberColor = p1Grey;
  static final Color pieceNumberPegColor = Colors.yellowAccent;
  static final Color boardP1PieceHighlightColor1 = Colors.lightGreenAccent;
  static final Color boardP1PieceHighlightColor2 = Colors.transparent;
  static final Color boardP2PieceHighlightColor1 = Colors.lightGreenAccent;
  static final Color boardP2PieceHighlightColor2 = Colors.transparent;

  // Default
  static final Color defaultBackgroundGradientColor1 = p1Grey;
  static final Color defaultBackgroundGradientColor2 = p1Blue;
  static final Color defaultPopupTextColor = Colors.black87;
  static final Color defaultButtonTextColor = Colors.white;
  static final Color defaultButtonGradientColor1 = p1Grey;
  static final Color defaultButtonGradientColor2 = p1Blue;
  static final Color defaultTextColor = Colors.white;
}

class Themes {
  int index = 1;

  BehaviorSubject<int> _index$;
  BehaviorSubject<int> get index$ => _index$;

  Themes() {
    // Default value
    _index$ = BehaviorSubject<int>.seeded(1);
  }

  Future<void> _addIntToSF(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);

    if (key == "theme") _index$.add(value);
  }

  Future<int> _getIntValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key))
      return prefs.getInt(key);
    else
      _addIntToSF(key, 1);

    return 1;
  }

  Future<void> updateTheme(int value) async {
    if (value >= 1 && value <= 5) await _addIntToSF("theme", value);

    print("Theme out of range");
  }

  Future init() async {
    print("INIT Theme");
    _index$.add(await _getIntValuesSF("theme"));

    print(_index$.value);
  }

  static final Color defaultColor = Colors.white;

  Color getHomePageTitleColor() {
    switch (index) {
      case 1:
        return Theme1.homePageTitleColor;
        break;
      case 2:
        return Theme2.homePageTitleColor;
        break;
      case 3:
        return Theme3.homePageTitleColor;
        break;
      case 4:
        return Theme4.homePageTitleColor;
        break;
      case 5:
        return Theme5.homePageTitleColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getHomePageButtonColor() {
    switch (index) {
      case 1:
        return Theme1.homePageButtonColor;
        break;
      case 2:
        return Theme2.homePageButtonColor;
        break;
      case 3:
        return Theme3.homePageButtonColor;
        break;
      case 4:
        return Theme4.homePageButtonColor;
        break;
      case 5:
        return Theme5.homePageButtonColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getHomePageButtonIconColor() {
    switch (index) {
      case 1:
        return Theme1.homePageButtonIconColor;
        break;
      case 2:
        return Theme2.homePageButtonIconColor;
        break;
      case 3:
        return Theme3.homePageButtonIconColor;
        break;
      case 4:
        return Theme4.homePageButtonIconColor;
        break;
      case 5:
        return Theme5.homePageButtonIconColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getDefaultBackgroundGradientColor1() {
    switch (index) {
      case 1:
        return Theme1.defaultBackgroundGradientColor1;
        break;
      case 2:
        return Theme2.defaultBackgroundGradientColor1;
        break;
      case 3:
        return Theme3.defaultBackgroundGradientColor1;
        break;
      case 4:
        return Theme4.defaultBackgroundGradientColor1;
        break;
      case 5:
        return Theme5.defaultBackgroundGradientColor1;
        break;
      default:
        return defaultColor;
    }
  }

  Color getDefaultBackgroundGradientColor2() {
    switch (index) {
      case 1:
        return Theme1.defaultBackgroundGradientColor2;
        break;
      case 2:
        return Theme2.defaultBackgroundGradientColor2;
        break;
      case 3:
        return Theme3.defaultBackgroundGradientColor2;
        break;
      case 4:
        return Theme4.defaultBackgroundGradientColor2;
        break;
      case 5:
        return Theme5.defaultBackgroundGradientColor2;
        break;
      default:
        return defaultColor;
    }
  }

  Color getDefaultTextColor() {
    switch (index) {
      case 1:
        return Theme1.defaultTextColor;
        break;
      case 2:
        return Theme2.defaultTextColor;
        break;
      case 3:
        return Theme3.defaultTextColor;
        break;
      case 4:
        return Theme4.defaultTextColor;
        break;
      case 5:
        return Theme5.defaultTextColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getgameTypePageTitleColor() {
    switch (index) {
      case 1:
        return Theme1.gameTypePageTitleColor;
        break;
      case 2:
        return Theme2.gameTypePageTitleColor;
        break;
      case 3:
        return Theme3.gameTypePageTitleColor;
        break;
      case 4:
        return Theme4.gameTypePageTitleColor;
        break;
      case 5:
        return Theme5.gameTypePageTitleColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getGameTypePageBackgroundColor() {
    switch (index) {
      case 1:
        return Theme1.gameTypePageBackgroundColor;
        break;
      case 2:
        return Theme2.gameTypePageBackgroundColor;
        break;
      case 3:
        return Theme3.gameTypePageBackgroundColor;
        break;
      case 4:
        return Theme4.gameTypePageBackgroundColor;
        break;
      case 5:
        return Theme5.gameTypePageBackgroundColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getDefaultPopupTextColor() {
    switch (index) {
      case 1:
        return Theme1.defaultPopupTextColor;
        break;
      case 2:
        return Theme2.defaultPopupTextColor;
        break;
      case 3:
        return Theme3.defaultPopupTextColor;
        break;
      case 4:
        return Theme4.defaultPopupTextColor;
        break;
      case 5:
        return Theme5.defaultPopupTextColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getDefaultButtonTextColor() {
    switch (index) {
      case 1:
        return Theme1.defaultButtonTextColor;
        break;
      case 2:
        return Theme2.defaultButtonTextColor;
        break;
      case 3:
        return Theme3.defaultButtonTextColor;
        break;
      case 4:
        return Theme4.defaultButtonTextColor;
        break;
      case 5:
        return Theme5.defaultButtonTextColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getDefaultButtonGradientColor1() {
    switch (index) {
      case 1:
        return Theme1.defaultButtonGradientColor1;
        break;
      case 2:
        return Theme2.defaultButtonGradientColor1;
        break;
      case 3:
        return Theme3.defaultButtonGradientColor1;
        break;
      case 4:
        return Theme4.defaultButtonGradientColor1;
        break;
      case 5:
        return Theme5.defaultButtonGradientColor1;
        break;
      default:
        return defaultColor;
    }
  }

  Color getDefaultButtonGradientColor2() {
    switch (index) {
      case 1:
        return Theme1.defaultButtonGradientColor2;
        break;
      case 2:
        return Theme2.defaultButtonGradientColor2;
        break;
      case 3:
        return Theme3.defaultButtonGradientColor2;
        break;
      case 4:
        return Theme4.defaultButtonGradientColor2;
        break;
      case 5:
        return Theme5.defaultButtonGradientColor2;
        break;
      default:
        return defaultColor;
    }
  }

  Color getGamePageBackgroundGradientColor1() {
    switch (index) {
      case 1:
        return Theme1.gamePageBackgroundGradientColor1;
        break;
      case 2:
        return Theme2.gamePageBackgroundGradientColor1;
        break;
      case 3:
        return Theme3.gamePageBackgroundGradientColor1;
        break;
      case 4:
        return Theme4.gamePageBackgroundGradientColor1;
        break;
      case 5:
        return Theme5.gamePageBackgroundGradientColor1;
        break;
      default:
        return defaultColor;
    }
  }

  Color getGamePageBackgroundGradientColor2() {
    switch (index) {
      case 1:
        return Theme1.gamePageBackgroundGradientColor2;
        break;
      case 2:
        return Theme2.gamePageBackgroundGradientColor2;
        break;
      case 3:
        return Theme3.gamePageBackgroundGradientColor2;
        break;
      case 4:
        return Theme4.gamePageBackgroundGradientColor2;
        break;
      case 5:
        return Theme5.gamePageBackgroundGradientColor2;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardEmptyCellColor1() {
    switch (index) {
      case 1:
        return Theme1.boardEmptyCellColor1;
        break;
      case 2:
        return Theme2.boardEmptyCellColor1;
        break;
      case 3:
        return Theme3.boardEmptyCellColor1;
        break;
      case 4:
        return Theme4.boardEmptyCellColor1;
        break;
      case 5:
        return Theme5.boardEmptyCellColor1;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardEmptyCellColor2() {
    switch (index) {
      case 1:
        return Theme1.boardEmptyCellColor2;
        break;
      case 2:
        return Theme2.boardEmptyCellColor2;
        break;
      case 3:
        return Theme3.boardEmptyCellColor2;
        break;
      case 4:
        return Theme4.boardEmptyCellColor2;
        break;
      case 5:
        return Theme5.boardEmptyCellColor2;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardP1PieceColor() {
    switch (index) {
      case 1:
        return Theme1.boardP1PieceColor;
        break;
      case 2:
        return Theme2.boardP1PieceColor;
        break;
      case 3:
        return Theme3.boardP1PieceColor;
        break;
      case 4:
        return Theme4.boardP1PieceColor;
        break;
      case 5:
        return Theme5.boardP1PieceColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardP2PieceColor() {
    switch (index) {
      case 1:
        return Theme1.boardP2PieceColor;
        break;
      case 2:
        return Theme2.boardP2PieceColor;
        break;
      case 3:
        return Theme3.boardP2PieceColor;
        break;
      case 4:
        return Theme4.boardP2PieceColor;
        break;
      case 5:
        return Theme5.boardP2PieceColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getGamePageConcurrencyColor() {
    switch (index) {
      case 1:
        return Theme1.gamePageConcurrencyColor;
        break;
      case 2:
        return Theme2.gamePageConcurrencyColor;
        break;
      case 3:
        return Theme3.gamePageConcurrencyColor;
        break;
      case 4:
        return Theme4.gamePageConcurrencyColor;
        break;
      case 5:
        return Theme5.gamePageConcurrencyColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getGamePageEasyModeColor() {
    switch (index) {
      case 1:
        return Theme1.gamePageEasyModeColor;
        break;
      case 2:
        return Theme2.gamePageEasyModeColor;
        break;
      case 3:
        return Theme3.gamePageEasyModeColor;
        break;
      case 4:
        return Theme4.gamePageEasyModeColor;
        break;
      case 5:
        return Theme5.gamePageEasyModeColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getGamePageMediumModeColor() {
    switch (index) {
      case 1:
        return Theme1.gamePageMediumModeColor;
        break;
      case 2:
        return Theme2.gamePageMediumModeColor;
        break;
      case 3:
        return Theme3.gamePageMediumModeColor;
        break;
      case 4:
        return Theme4.gamePageMediumModeColor;
        break;
      case 5:
        return Theme5.gamePageMediumModeColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getGamePageHardModeColor() {
    switch (index) {
      case 1:
        return Theme1.gamePageHardModeColor;
        break;
      case 2:
        return Theme2.gamePageHardModeColor;
        break;
      case 3:
        return Theme3.gamePageHardModeColor;
        break;
      case 4:
        return Theme4.gamePageHardModeColor;
        break;
      case 5:
        return Theme5.gamePageHardModeColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getPieceNumberColor() {
    switch (index) {
      case 1:
        return Theme1.pieceNumberColor;
        break;
      case 2:
        return Theme2.pieceNumberColor;
        break;
      case 3:
        return Theme3.pieceNumberColor;
        break;
      case 4:
        return Theme4.pieceNumberColor;
        break;
      case 5:
        return Theme5.pieceNumberColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getPieceNumberPegColor() {
    switch (index) {
      case 1:
        return Theme1.pieceNumberPegColor;
        break;
      case 2:
        return Theme2.pieceNumberPegColor;
        break;
      case 3:
        return Theme3.pieceNumberPegColor;
        break;
      case 4:
        return Theme4.pieceNumberPegColor;
        break;
      case 5:
        return Theme5.pieceNumberPegColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardBorderColor() {
    switch (index) {
      case 1:
        return Theme1.boardBorderColor;
        break;
      case 2:
        return Theme2.boardBorderColor;
        break;
      case 3:
        return Theme3.boardBorderColor;
        break;
      case 4:
        return Theme4.boardBorderColor;
        break;
      case 5:
        return Theme5.boardBorderColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardP1PegColor() {
    switch (index) {
      case 1:
        return Theme1.boardP1PegColor;
        break;
      case 2:
        return Theme2.boardP1PegColor;
        break;
      case 3:
        return Theme3.boardP1PegColor;
        break;
      case 4:
        return Theme4.boardP1PegColor;
        break;
      case 5:
        return Theme5.boardP1PegColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardP2PegColor() {
    switch (index) {
      case 1:
        return Theme1.boardP2PegColor;
        break;
      case 2:
        return Theme2.boardP2PegColor;
        break;
      case 3:
        return Theme3.boardP2PegColor;
        break;
      case 4:
        return Theme4.boardP2PegColor;
        break;
      case 5:
        return Theme5.boardP2PegColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardP1EmptyPegColor() {
    switch (index) {
      case 1:
        return Theme1.boardP1EmptyPegColor;
        break;
      case 2:
        return Theme2.boardP1EmptyPegColor;
        break;
      case 3:
        return Theme3.boardP1EmptyPegColor;
        break;
      case 4:
        return Theme4.boardP1EmptyPegColor;
        break;
      case 5:
        return Theme5.boardP1EmptyPegColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardP2EmptyPegColor() {
    switch (index) {
      case 1:
        return Theme1.boardP2EmptyPegColor;
        break;
      case 2:
        return Theme2.boardP2EmptyPegColor;
        break;
      case 3:
        return Theme3.boardP2EmptyPegColor;
        break;
      case 4:
        return Theme4.boardP2EmptyPegColor;
        break;
      case 5:
        return Theme5.boardP2EmptyPegColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardP1PieceHighlightColor1() {
    switch (index) {
      case 1:
        return Theme1.boardP1PieceHighlightColor1;
        break;
      case 2:
        return Theme2.boardP1PieceHighlightColor1;
        break;
      case 3:
        return Theme3.boardP1PieceHighlightColor1;
        break;
      case 4:
        return Theme4.boardP1PieceHighlightColor1;
        break;
      case 5:
        return Theme5.boardP1PieceHighlightColor1;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardP1PieceHighlightColor2() {
    switch (index) {
      case 1:
        return Theme1.boardP1PieceHighlightColor2;
        break;
      case 2:
        return Theme2.boardP1PieceHighlightColor2;
        break;
      case 3:
        return Theme3.boardP1PieceHighlightColor2;
        break;
      case 4:
        return Theme4.boardP1PieceHighlightColor2;
        break;
      case 5:
        return Theme5.boardP1PieceHighlightColor2;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardP2PieceHighlightColor1() {
    switch (index) {
      case 1:
        return Theme1.boardP2PieceHighlightColor1;
        break;
      case 2:
        return Theme2.boardP2PieceHighlightColor1;
        break;
      case 3:
        return Theme3.boardP2PieceHighlightColor1;
        break;
      case 4:
        return Theme4.boardP2PieceHighlightColor1;
        break;
      case 5:
        return Theme5.boardP2PieceHighlightColor1;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardP2PieceHighlightColor2() {
    switch (index) {
      case 1:
        return Theme1.boardP2PieceHighlightColor2;
        break;
      case 2:
        return Theme2.boardP2PieceHighlightColor2;
        break;
      case 3:
        return Theme3.boardP2PieceHighlightColor2;
        break;
      case 4:
        return Theme4.boardP2PieceHighlightColor2;
        break;
      case 5:
        return Theme5.boardP2PieceHighlightColor2;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardP1CenterColor() {
    switch (index) {
      case 1:
        return Theme1.boardP1CenterColor;
        break;
      case 2:
        return Theme2.boardP1CenterColor;
        break;
      case 3:
        return Theme3.boardP1CenterColor;
        break;
      case 4:
        return Theme4.boardP1CenterColor;
        break;
      case 5:
        return Theme5.boardP1CenterColor;
        break;
      default:
        return defaultColor;
    }
  }

  Color getBoardP2CenterColor() {
    switch (index) {
      case 1:
        return Theme1.boardP2CenterColor;
        break;
      case 2:
        return Theme2.boardP2CenterColor;
        break;
      case 3:
        return Theme3.boardP2CenterColor;
        break;
      case 4:
        return Theme4.boardP2CenterColor;
        break;
      case 5:
        return Theme5.boardP2CenterColor;
        break;
      default:
        return defaultColor;
    }
  }
}
