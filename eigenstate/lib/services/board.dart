import 'dart:collection';

import 'dart:math';
import 'dart:core';
import 'package:rxdart/rxdart.dart';

import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/services/piece.dart';
import 'package:eigenstate/services/sound.dart';
import 'package:eigenstate/services/coord.dart';

final soundService = locator<SoundService>();

enum Player { P1, P2 }
enum BoardState { EndGame, Play }
enum GameMode { Solo, Online, TwoPlayers }
enum Difficulty { Easy, Medium, Hard }
enum Phase {
  ChoosePieceToMove,
  Destination,
  ChoosePieceToPin,
  ChoosePins,
  Done
}

class BoardService {
  static const size = 6;

  BehaviorSubject<List<List<PieceService>>> _board$;
  BehaviorSubject<List<List<PieceService>>> get board$ => _board$;

  BehaviorSubject<MapEntry<int, Player>> _rounds$;
  BehaviorSubject<MapEntry<int, Player>> get rounds$ => _rounds$;

  BehaviorSubject<MapEntry<BoardState, Player>> _boardState$;
  BehaviorSubject<MapEntry<BoardState, Player>> get boardState$ => _boardState$;

  BehaviorSubject<GameMode> _gameMode$;
  BehaviorSubject<GameMode> get gameMode$ => _gameMode$;

  BehaviorSubject<Difficulty> _gameDifficulty$;
  BehaviorSubject<Difficulty> get gameDifficulty$ => _gameDifficulty$;

  BehaviorSubject<MapEntry<int, int>> _score$;
  BehaviorSubject<MapEntry<int, int>> get score$ => _score$;

  BehaviorSubject<bool> _thirdDimension$;
  BehaviorSubject<bool> get thirdDimension$ => _thirdDimension$;

  Player _start;
  Player _second;

  Phase turnPhase;

  Coordinate piece;
  int pinsSelected;

  bool inGame;

  final random = Random();

  HashMap<MapEntry<int, int>, PieceService> _p1Pieces;
  HashMap<MapEntry<int, int>, PieceService> _p2Pieces;

  BoardService() {
    _initStreams();
  }

  String getGameDifficulty() {
    switch (_gameDifficulty$.value) {
      case Difficulty.Easy:
        return "Easy";
      case Difficulty.Medium:
        return "Medium";
      case Difficulty.Hard:
        return "Hard";
      default:
        return "ERROR";
    }
  }

  void setGameDifficulty(Difficulty difficulty) {
    _gameDifficulty$.add(difficulty);
  }

  void setGameMode(GameMode gm) {
    _gameMode$.add(gm);
  }

  void setPlayerStart() {
    if (_start == Player.P1) {
      _start = Player.P2;
      _second = Player.P1;
    } else {
      _start = Player.P1;
      _second = Player.P2;
    }
  }

  Player getPlaying() {
    return _rounds$.value.value;
  }

  GameMode getGameMode() {
    return _gameMode$.value;
  }

  Player checkWinner() {
    // Primary Goal
    // // reduce oponnent to one piece remaining
    int nP1 = 0, nP2 = 0;
    _board$.value.forEach((line) => line.forEach((piece) =>
        piece.own$.value == Player.P1
            ? nP1++
            : piece.own$.value == Player.P2 ? nP2++ : null));

    print(nP1.toString() + " " + nP2.toString());
    if (nP1 == 1)
      return Player.P2;
    else if (nP2 == 1) return Player.P1;

    // Secondary Goal
    // // both players with exactly 2 pieces:
    // // // wins the first one to fill all pins in a remaining piece
    Player winner;
    if (nP1 == 2 && nP2 == 2) {
      _board$.value.forEach((line) => line.forEach((piece) =>
          piece.own$.value != null
              ? piece.checkFullPin() ? winner = piece.own$.value : null
              : null));
    }

    return winner;
  }

  void updatePlayersPieces() {
    _p1Pieces.clear();
    _p2Pieces.clear();

    List<List<PieceService>> currentBoard = _board$.value;

    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        PieceService p = currentBoard[i][j];
        if (p.own$.value == Player.P1) {
          _p1Pieces[MapEntry(i, j)] = p;
        } else if (p.own$.value == Player.P2) {
          _p2Pieces[MapEntry(i, j)] = p;
        }
      }
    }
  }

  void nextTurn() {
    Player p = checkWinner();

    if (p != null && inGame) {
      print("GANHOUU");
      print(p);

      if (p == Player.P1)
        _score$.add(MapEntry(score$.value.key + 1, score$.value.value));
      else
        _score$.add(MapEntry(score$.value.key, score$.value.value + 1));

      _boardState$.add(MapEntry(BoardState.EndGame, p));
      inGame = false;
      return;
    }

    print("New Turn");

    int round = _rounds$.value.key;
    Player actual = getPlaying();

    if (_start == actual) {
      _rounds$.add(MapEntry(round, _second));
    } else {
      _rounds$.add(MapEntry(round + 1, _start));
    }

    turnPhase = Phase.ChoosePieceToMove;
    piece.clean();
    pinsSelected = 0;

    if (!(gameMode$.value != GameMode.TwoPlayers &&
        getPlaying() == Player.P2)) {
      swapPieceAnimation();
    } else {
      performAITurn();
    }
  }

  void performAITurn() {
    // Move piece
    updatePlayersPieces();
    moveAIPiece();

    // Choose two pins
    updatePlayersPieces();
    chooseAITwoPins();

    nextTurn();
  }

  void moveAIPiece() {
    switch (gameDifficulty$.value) {
      case Difficulty.Easy:
        if (captureMove(false)) return;
        randomAIMove();
        break;
      case Difficulty.Medium:
        if (captureMove(true)) return;
        if (moveDangerousPieces()) return;
        if (carefulMove()) return;
        lessDangerousMove();
        break;
      case Difficulty.Hard:
        if (captureMove(true)) return;
        if (moveDangerousPieces()) return;
        if (moveToCounter()) return;
        if (carefulMove()) return;
        lessDangerousMove();
        break;
      default:
    }
  }

  bool captureMove(bool precation) {
    for (MapEntry<int, int> pieceEntry in _p2Pieces.keys) {
      PieceService p = _board$.value[pieceEntry.key][pieceEntry.value];

      for (MapEntry<int, int> entry in _p1Pieces.keys) {
        if (p.checkDestinationReachable(
            pieceEntry.key, pieceEntry.value, entry.key, entry.value)) {
          if (precation) {
            if (!(checkPositionDangerous(entry.key, entry.value, Player.P2))) {
            } else {
              if (!checkPositionDangerous(
                  pieceEntry.key, pieceEntry.value, Player.P1)) {
                continue;
              }
            }
          }

          print("Capture: Piece " +
              pieceEntry.key.toString() +
              ":" +
              pieceEntry.value.toString() +
              " to " +
              entry.key.toString() +
              ":" +
              entry.value.toString());
          piece.setCoordinates(pieceEntry.key, pieceEntry.value);
          executeMove(entry.key, entry.value);
          return true;
        }
      }
    }

    return false;
  }

  bool checkPositionDangerous(int k, int l, Player p) {
    HashMap<MapEntry<int, int>, PieceService> pPieces =
        HashMap<MapEntry<int, int>, PieceService>();

    if (p == Player.P1) {
      ;
      pPieces.addAll(_p1Pieces);
    } else if (p == Player.P2) {
      pPieces.addAll(_p2Pieces);
    }

    for (MapEntry<MapEntry<int, int>, PieceService> pieceEntry
        in pPieces.entries) {
      if (pieceEntry.value.checkDestinationReachable(
          pieceEntry.key.key, pieceEntry.key.value, k, l)) return true;
    }

    return false;
  }

  bool moveDangerousPieces() {
    for (MapEntry<MapEntry<int, int>, PieceService> pieceEntry
        in _p2Pieces.entries) {
      if (pieceEntry.value.hasPossibleMovements(
              pieceEntry.key.key, pieceEntry.key.value, size) &&
          checkPositionDangerous(
              pieceEntry.key.key, pieceEntry.key.value, Player.P1)) {
        piece.setCoordinates(pieceEntry.key.key, pieceEntry.key.value);
        if (moveToSafety()) return true;
      }
    }

    return false;
  }

  bool moveToSafety() {
    List<List<PieceService>> currentBoard = _board$.value;
    PieceService p = currentBoard[piece.getI()][piece.getJ()];

    for (var i = 0; i < size; i++) {
      if (random.nextBool()) {
        for (var j = 0; j < size; j++) {
          if (currentBoard[i][j].own$.value != Player.P2 &&
              p.checkDestinationReachable(piece.getI(), piece.getJ(), i, j) &&
              !checkPositionDangerous(i, j, Player.P1)) {
            print("Move to safety " +
                piece.getI().toString() +
                ":" +
                piece.getJ().toString() +
                " to " +
                i.toString() +
                ":" +
                j.toString());
            executeMove(i, j);
            return true;
          }
        }
      } else {
        for (var j = size - 1; j >= 0; j--) {
          if (currentBoard[i][j].own$.value != Player.P2 &&
              p.checkDestinationReachable(piece.getI(), piece.getJ(), i, j) &&
              !checkPositionDangerous(i, j, Player.P1)) {
            print("Move to safety " +
                piece.getI().toString() +
                ":" +
                piece.getJ().toString() +
                " to " +
                i.toString() +
                ":" +
                j.toString());
            executeMove(i, j);
            return true;
          }
        }
      }
    }

    return false;
  }

  bool moveToCounter() {
    for (MapEntry<MapEntry<int, int>, PieceService> pieceEntry
        in _p2Pieces.entries) {
      if (checkPositionDangerous(
          pieceEntry.key.key, pieceEntry.key.value, Player.P1)) {
        for (MapEntry<MapEntry<int, int>, PieceService> piece2Entry
            in _p2Pieces.entries) {
          if (pieceEntry.value.id$.value != piece2Entry.value.id$.value) {
            for (var i = 0; i < size; i++) {
              for (var j = 0; j < size; j++) {
                if (pieceEntry.key.key != i &&
                    pieceEntry.key.value != j &&
                    piece2Entry.value.checkDestinationReachable(
                        piece2Entry.key.key, piece2Entry.key.value, i, j) &&
                    piece2Entry.value.checkDestinationReachable(
                        i, j, pieceEntry.key.key, pieceEntry.key.value)) {
                  piece.setCoordinates(
                      piece2Entry.key.key, piece2Entry.key.value);
                  print("Move to counter" +
                      piece2Entry.key.key.toString() +
                      ":" +
                      piece2Entry.key.value.toString() +
                      " to " +
                      i.toString() +
                      ":" +
                      j.toString());
                  executeMove(i, j);
                  return true;
                }
              }
            }
          }
        }
      }
    }

    return false;
  }

  bool carefulMove() {
    for (MapEntry<MapEntry<int, int>, PieceService> pieceEntry
        in _p2Pieces.entries) {
      if (pieceEntry.value.hasPossibleMovements(
              pieceEntry.key.key, pieceEntry.key.value, size) &&
          !checkPositionDangerous(
              pieceEntry.key.key, pieceEntry.key.value, Player.P1)) {
        piece.setCoordinates(pieceEntry.key.key, pieceEntry.key.value);
        if (moveToSafety()) return true;
      }
    }

    return false;
  }

  void randomAIMove() {
    int count = 0;

    for (MapEntry<MapEntry<int, int>, PieceService> pieceEntry
        in _p2Pieces.entries) {
      if (pieceEntry.value.hasPossibleMovements(
          pieceEntry.key.key, pieceEntry.key.value, size)) count++;
    }

    int pieceIndex = random.nextInt(count);
    count = 0;

    for (MapEntry<MapEntry<int, int>, PieceService> pieceEntry
        in _p2Pieces.entries) {
      if (pieceEntry.value.hasPossibleMovements(
          pieceEntry.key.key, pieceEntry.key.value, size)) {
        if (count == pieceIndex) {
          piece.setCoordinates(pieceEntry.key.key, pieceEntry.key.value);
          randomAIPieceMove();
          return;
        } else {
          count++;
        }
      }
    }
  }

  void lessDangerousMove() {
    List<List<PieceService>> currentBoard = _board$.value;

    for (var i = 0; i < size; i++) {
      if (random.nextBool()) {
        for (var j = 0; j < size; j++) {
          PieceService p = currentBoard[i][j];
          if (p.own$.value == Player.P2) {
            for (var k = 0; k < size; k++) {
              if (random.nextBool()) {
                for (var l = 0; l < size; l++) {
                  if (currentBoard[k][l].own$.value != Player.P2 &&
                      p.checkDestinationReachable(i, j, k, l)) {
                    piece.setCoordinates(i, j);
                    print("Move dangerously " +
                        piece.getI().toString() +
                        ":" +
                        piece.getJ().toString() +
                        " to " +
                        k.toString() +
                        ":" +
                        l.toString());
                    executeMove(k, l);
                    return;
                  }
                }
              } else {
                for (var l = size - 1; l >= 0; l++) {
                  if (currentBoard[k][l].own$.value != Player.P2 &&
                      p.checkDestinationReachable(i, j, k, l)) {
                    piece.setCoordinates(i, j);
                    print("Move dangerously " +
                        piece.getI().toString() +
                        ":" +
                        piece.getJ().toString() +
                        " to " +
                        k.toString() +
                        ":" +
                        l.toString());
                    executeMove(k, l);
                    return;
                  }
                }
              }
            }
          }
        }
      } else {
        for (var j = size - 1; j >= 0; j--) {
          PieceService p = currentBoard[i][j];
          if (p.own$.value == Player.P2) {
            for (var k = 0; k < size; k++) {
              if (random.nextBool()) {
                for (var l = 0; l < size; l++) {
                  if (currentBoard[k][l].own$.value != Player.P2 &&
                      p.checkDestinationReachable(i, j, k, l)) {
                    piece.setCoordinates(i, j);
                    print("Move dangerously " +
                        piece.getI().toString() +
                        ":" +
                        piece.getJ().toString() +
                        " to " +
                        k.toString() +
                        ":" +
                        l.toString());
                    executeMove(k, l);
                    return;
                  }
                }
              } else {
                for (var l = size - 1; l >= 0; l++) {
                  if (currentBoard[k][l].own$.value != Player.P2 &&
                      p.checkDestinationReachable(i, j, k, l)) {
                    piece.setCoordinates(i, j);
                    print("Move dangerously " +
                        piece.getI().toString() +
                        ":" +
                        piece.getJ().toString() +
                        " to " +
                        k.toString() +
                        ":" +
                        l.toString());
                    executeMove(k, l);
                    return;
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  void randomAIPieceMove() {
    List<List<PieceService>> currentBoard = _board$.value;
    PieceService p = currentBoard[piece.getI()][piece.getJ()];

    if (piece.getI() < 3) {
      for (var i = piece.getI() + 1; i < size; i++) {
        if (random.nextBool()) {
          for (var j = 0; j < size; j++) {
//          print("Checking " + i.toString() + ":" + j.toString());
            if (currentBoard[i][j].own$.value != Player.P2 &&
                p.checkDestinationReachable(piece.getI(), piece.getJ(), i, j)) {
              print("Random move " +
                  piece.getI().toString() +
                  ":" +
                  piece.getJ().toString() +
                  " to " +
                  i.toString() +
                  ":" +
                  j.toString());
              executeMove(i, j);
              return;
            }
          }
        } else {
          for (var j = size - 1; j >= 0; j--) {
//          print("Checking " + i.toString() + ":" + j.toString());
            if (currentBoard[i][j].own$.value != Player.P2 &&
                p.checkDestinationReachable(piece.getI(), piece.getJ(), i, j)) {
              print("Random move " +
                  piece.getI().toString() +
                  ":" +
                  piece.getJ().toString() +
                  " to " +
                  i.toString() +
                  ":" +
                  j.toString());
              executeMove(i, j);
              return;
            }
          }
        }
      }
    } else {
      for (var i = size - 1; i >= 0; i--) {
        if (random.nextBool()) {
          for (var j = 0; j < size; j++) {
//          print("Checking " + i.toString() + ":" + j.toString());
            if (currentBoard[i][j].own$.value != Player.P2 &&
                p.checkDestinationReachable(piece.getI(), piece.getJ(), i, j)) {
//            print("Random move " + piece.getI().toString() + ":" + piece.getJ().toString() + " to " + i.toString() + ":" + j.toString());
              executeMove(i, j);
              return;
            }
          }
        } else {
          for (var j = size - 1; j >= 0; j--) {
//          print("Checking " + i.toString() + ":" + j.toString());
            if (currentBoard[i][j].own$.value != Player.P2 &&
                p.checkDestinationReachable(piece.getI(), piece.getJ(), i, j)) {
//            print("Random move " + piece.getI().toString() + ":" + piece.getJ().toString() + " to " + i.toString() + ":" + j.toString());
              executeMove(i, j);
              return;
            }
          }
        }
      }
    }
  }

  void chooseAITwoPins() {
    pinsSelected = 0;

    switch (gameDifficulty$.value) {
      case Difficulty.Easy:
        while (pinsSelected < 2) {
          if (insertPinToGetPiece()) {
          } else if (_p2Pieces.length <= 3 &&
              _p1Pieces.length >= 3 &&
              rounds$.value.key > 8)
            insertRandomPiecePin(true);
          else
            insertRandomPiecePin(false);
        }
        break;
      case Difficulty.Medium:
        while (pinsSelected < 2) {
          if (insertPinToGetPiece()) {
          } else if (!checkProtectionPinNeed()) {
            insertRandomPiecePin(false);
          }
        }
        break;
      case Difficulty.Hard:
        while (pinsSelected < 2) {
          if (insertPinToGetPiece()) {
          } else if (!checkProtectionPinNeed()) {
            insertRandomPiecePin(false);
          }
        }
        break;
      default:
    }
  }

  bool hasPieceToGet(int i, int j, PieceService p) {
    HashMap<MapEntry<int, int>, PieceService> pPieces =
        HashMap<MapEntry<int, int>, PieceService>();

    if (p.own$.value == Player.P1) {
      pPieces.addAll(_p2Pieces);
    } else if (p.own$.value == Player.P2) {
      pPieces.addAll(_p1Pieces);
    }

    for (MapEntry<int, int> pieceEntry in pPieces.keys) {
      if (p.checkDestinationReachable(i, j, pieceEntry.key, pieceEntry.value)) {
        return true;
      }
    }
    return false;
  }

  bool putPinToGetPieceIfPossible(int i, int j, int k, int l) {
    int offsetI = k - i;
    int offsetJ = l - j;

    if (offsetI < -2 || offsetJ < -2 || offsetI > 2 || offsetJ > 2)
      return false;

    if (checkAddPin(i, j, offsetI, offsetJ)) return true;

    return false;
  }

  bool insertPinToGetPiece() {
    for (MapEntry<MapEntry<int, int>, PieceService> pieceEntry
        in _p2Pieces.entries) {
      for (MapEntry<int, int> pieceToGet in _p1Pieces.keys) {
        if (!hasPieceToGet(
                pieceEntry.key.key, pieceEntry.key.value, pieceEntry.value) &&
            putPinToGetPieceIfPossible(pieceEntry.key.key, pieceEntry.key.value,
                pieceToGet.key, pieceToGet.value)) return true;
      }
    }

    print("No Piece to get Caught");
    return false;
  }

  bool checkAddPin(int i, int j, int offsetI, int offsetJ) {
    List<List<PieceService>> currentBoard = _board$.value;

    if (currentBoard[i][j].checkPin(offsetI, offsetJ)) {
      pinsSelected++;
      currentBoard[i][j].addPin(offsetI, offsetJ);
      _board$.add(currentBoard);
      print("Added pin to Piece[" +
          currentBoard[i][j].id$.value.toString() +
          "] In " +
          offsetI.toString() +
          ":" +
          offsetJ.toString());
      return true;
    }

    print("Failed to checkAdd Pin");

    return false;
  }

  bool addForwardPin(int i, int j) {
    int rand = random.nextInt(4);
    int row;

    if (rand < 3)
      row = 3;
    else
      row = 4;

    if (random.nextBool())
      for (var k = 2; k < 5; k++) {
        if (checkAddPin(i, j, row, k)) return true;
      }
    else
      for (var k = 2; k >= 0; k--) {
        if (checkAddPin(i, j, row, k)) return true;
      }

    print("Failed to add Pin Forward");

    return false;
  }

  bool addProtectionPin(int i, int j) {
    int rand = random.nextInt(5);
    int row;

    if (i == 0)
      row = 2;
    else if (i == 1) {
      if (rand < 3)
        row = 2;
      else
        row = 1;
    } else if (rand < 3)
      row = 1;
    else if (rand < 4)
      row = 0;
    else
      row = 2;

    if (j < 3)
      for (var k = (row == 2 ? 3 : 2); k < 5; k++) {
        if (checkAddPin(i, j, row, k)) return true;
      }
    else
      for (var k = (row == 2 ? 3 : 1); k >= 0; k--) {
        if (checkAddPin(i, j, row, k)) return true;
      }

    print("Failed to add Pin Backwards");

    return false;
  }

  void insertRandomPiecePin(bool protection) {
    int count = 0;
    int index = 0;

    while (true) {
      index = random.nextInt(_p2Pieces.length);
      count = 0;
      for (MapEntry<int, int> pieceEntry in _p2Pieces.keys) {
        if (index == count) {
          if (protection) {
            if (addProtectionPin(pieceEntry.key, pieceEntry.value)) return;
          } else {
            if (addForwardPin(pieceEntry.key, pieceEntry.value)) return;
          }
        } else {
          count++;
        }
      }
    }
  }

  bool checkProtectionPinNeed() {
    for (MapEntry<int, int> piece in _p2Pieces.keys) {
      for (MapEntry<int, int> p in _p1Pieces.keys) {
        int difKey =
            (piece.key - p.key) < 0 ? (p.key - piece.key) : (piece.key - p.key);
        int difValue = (piece.value - p.value) < 0
            ? (p.value - piece.value)
            : (piece.value - p.value);
        if (difKey <= 2 && difValue <= 2 && piece.key != 0) {
          if (addProtectionPin(piece.key, piece.value)) return true;
        }
      }
    }

    return false;
  }

  void swapPieceAnimation() {
    Player p = getPlaying();

    List<List<PieceService>> currentBoard = _board$.value;

    currentBoard.forEach((line) => line.forEach((piece) => piece.own$.value == p
        ? piece.toAnimate$.add(!piece.toAnimate$.value)
        : null));

    _board$.add(currentBoard);
  }

  void changePossiblePieceDestinations(bool toValue) {
    List<List<PieceService>> currentBoard = _board$.value;

    PieceService p = currentBoard[piece.getI()][piece.getJ()];

    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        if (p.checkDestinationReachable(piece.getI(), piece.getJ(), i, j))
          currentBoard[i][j].toAnimate$.add(toValue);
      }
    }

    _board$.add(currentBoard);
  }

  void disablePieceMove() {
    List<List<PieceService>> currentBoard = _board$.value;

    currentBoard.forEach(
        (line) => line.forEach((piece) => piece.pieceMoved$.value = false));

    _board$.add(currentBoard);
  }

  int handleClick(int i, int j) {
    if (!inGame) return 0;

    if (checkWinner() != null) {
      nextTurn();
    }

    if (gameMode$.value != GameMode.TwoPlayers && getPlaying() == Player.P2) {
      print("Not your move");
      return 0;
    }

    print(turnPhase);

    switch (turnPhase) {
      case Phase.ChoosePieceToMove:
        if (checkPiece(i, j)) {
          turnPhase = Phase.Destination;
          piece.setCoordinates(i, j);
          swapPieceAnimation(); // remove
          changePossiblePieceDestinations(true);
        }
        break;
      case Phase.Destination:
        if (checkDestination(i, j)) {
          changePossiblePieceDestinations(false);
          executeMove(i, j);
          turnPhase = Phase.ChoosePieceToPin;

          if (checkWinner() != null) {
            nextTurn();
          }

          swapPieceAnimation(); // put
        } else if (_board$.value[i][j].own$.value != getPlaying()) {
          changePossiblePieceDestinations(false);
          piece.clean();
          turnPhase = Phase.ChoosePieceToMove;
          swapPieceAnimation();
        }
        break;
      case Phase.ChoosePieceToPin:
        disablePieceMove();
        if (checkPiece(i, j)) {
          turnPhase = Phase.ChoosePins;
          piece.setCoordinates(i, j);
          soundService.playSound('sounds/slide');
          return 1;
        }
        break;
      case Phase.ChoosePins:
        List<List<PieceService>> currentBoard = _board$.value;
        if (currentBoard[piece.getI()][piece.getJ()].checkPin(i, j)) {
          pinsSelected++;
          currentBoard[piece.getI()][piece.getJ()].addPin(i, j);
          _board$.add(currentBoard);

          if (pinsSelected == 2) {
            swapPieceAnimation(); // remove
            return 2; // finish phase
          } else
            return 3; // alert dialog change
        }
        break;
      default:
    }

    if (turnPhase == Phase.Done) nextTurn();

    return 0;
  }

  bool checkPiece(int i, int j) {
    if (handleInput(i, j)) return false;

    List<List<PieceService>> currentBoard = _board$.value;

    return currentBoard[i][j].own$.value == getPlaying();
  }

  bool checkDestination(int i, int j) {
    if (handleInput(i, j)) return false;

    List<List<PieceService>> currentBoard = _board$.value;

    if (currentBoard[i][j].own$.value == getPlaying()) {
      changePossiblePieceDestinations(false);
      piece.setCoordinates(i, j);
      changePossiblePieceDestinations(true);
      return false;
    }

    return currentBoard[piece.getI()][piece.getJ()]
        .checkDestinationReachable(piece.getI(), piece.getJ(), i, j);
  }

  void executeMove(int i, int j) {
    List<List<PieceService>> currentBoard = _board$.value;

    currentBoard[i][j] = currentBoard[piece.getI()][piece.getJ()];
    currentBoard[i][j].pieceMoved$.add(true);
    currentBoard[piece.getI()][piece.getJ()] = PieceService.empty();
    currentBoard[piece.getI()][piece.getJ()].pieceMoved$.add(true);

    _board$.add(currentBoard);

    piece.clean();
  }

  bool handleInput(int i, int j) {
    return i >= size || j >= size || i < 0 || j < 0;
  }

  void popUpClosed() {
    if (pinsSelected == 2) {
      turnPhase = Phase.Done;

      nextTurn();
      return;
    }

    turnPhase = Phase.ChoosePieceToPin;
  }

  void popUpOpened() {
    turnPhase = Phase.ChoosePins;
  }

  void resetBoard(bool start) {
    print("Reset Board\n");

    setPlayerStart();
    _rounds$.add(MapEntry(1, _start));

    _board$.add([
      [
        PieceService(6, Player.P2, Player.P2 == _start),
        PieceService(5, Player.P2, Player.P2 == _start),
        PieceService(4, Player.P2, Player.P2 == _start),
        PieceService(3, Player.P2, Player.P2 == _start),
        PieceService(2, Player.P2, Player.P2 == _start),
        PieceService(1, Player.P2, Player.P2 == _start)
      ],
      [
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty()
      ],
      [
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty()
      ],
      [
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty()
      ],
      [
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty()
      ],
      [
        PieceService(1, Player.P1, Player.P1 == _start),
        PieceService(2, Player.P1, Player.P1 == _start),
        PieceService(3, Player.P1, Player.P1 == _start),
        PieceService(4, Player.P1, Player.P1 == _start),
        PieceService(5, Player.P1, Player.P1 == _start),
        PieceService(6, Player.P1, Player.P1 == _start)
      ]
    ]);

    _boardState$.add(MapEntry(BoardState.Play, null));

    turnPhase = Phase.ChoosePieceToMove;
    piece = Coordinate.origin();
    pinsSelected = 0;
    inGame = start;

    if (gameMode$.value != GameMode.TwoPlayers && _start == Player.P2) {
      swapPieceAnimation();
      performAITurn();
    }
  }

  void newGame(bool start) {
    resetBoard(start);
    _score$.add(MapEntry(0, 0));
  }

  bool checkGameInProgress() {
    return inGame;
  }

  void setInGame(bool b) {
    inGame = b;
  }

  void _initStreams() {
    print("Initiate Streams\n");

    _p1Pieces = new HashMap<MapEntry<int, int>, PieceService>();
    _p2Pieces = new HashMap<MapEntry<int, int>, PieceService>();

    _start = Player.P1;
    _second = Player.P2;

    _board$ = BehaviorSubject<List<List<PieceService>>>.seeded([
      [
        PieceService(6, Player.P2, Player.P2 == _start),
        PieceService(5, Player.P2, Player.P2 == _start),
        PieceService(4, Player.P2, Player.P2 == _start),
        PieceService(3, Player.P2, Player.P2 == _start),
        PieceService(2, Player.P2, Player.P2 == _start),
        PieceService(1, Player.P2, Player.P2 == _start)
      ],
      [
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty()
      ],
      [
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty()
      ],
      [
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty()
      ],
      [
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty()
      ],
      [
        PieceService(1, Player.P1, Player.P1 == _start),
        PieceService(2, Player.P1, Player.P1 == _start),
        PieceService(3, Player.P1, Player.P1 == _start),
        PieceService(4, Player.P1, Player.P1 == _start),
        PieceService(5, Player.P1, Player.P1 == _start),
        PieceService(6, Player.P1, Player.P1 == _start)
      ]
    ]);

    _rounds$ =
        BehaviorSubject<MapEntry<int, Player>>.seeded(MapEntry(1, Player.P1));

    _boardState$ = BehaviorSubject<MapEntry<BoardState, Player>>.seeded(
        MapEntry(BoardState.Play, null));

    _gameMode$ = BehaviorSubject<GameMode>.seeded(GameMode.Solo);

    _gameDifficulty$ = BehaviorSubject<Difficulty>.seeded(Difficulty.Easy);

    _score$ = BehaviorSubject<MapEntry<int, int>>.seeded(MapEntry(0, 0));

    _thirdDimension$ = BehaviorSubject<bool>.seeded(true);

    turnPhase = Phase.ChoosePieceToMove;
    piece = Coordinate.origin();
    pinsSelected = 0;
    inGame = false;

    updatePlayersPieces();
  }
}
