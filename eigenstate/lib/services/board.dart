import 'package:eigenstate/components/piece.dart';
import 'dart:math';
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
    moveAIPiece();
    // Choose two pins
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
        carefulMove();
        break;
      case Difficulty.Hard:
        // TODO predicts player move to play to counter
        if (captureMove(true)) return;
        if (moveDangerousPieces()) return;
        carefulMove();
        break;
      default:
    }
  }

  bool captureMove(bool precation) {
    if (random.nextBool()) {
      for (var i = 0; i < size; i++) {
        for (var j = 0; j < size; j++) {
          if (checkPossibleMoveAI(i, j, precation)) {
            return true;
          }
        }
      }
    } else {
      for (var i = size - 1; i >= 0; i--) {
        for (var j = size - 1; j >= 0; j--) {
          if (checkPossibleMoveAI(i, j, precation)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  bool checkPossibleMoveAI(int i, int j, bool precation) {
    List<List<PieceService>> currentBoard = _board$.value;
    Player player = getPlaying();
    PieceService p = currentBoard[i][j];

    if (p.own$.value == player) {
      for (var k = 0; k < size; k++) {
        for (var l = 0; l < size; l++) {
          if (currentBoard[k][l].own$.value == Player.P1 &&
              p.checkDestinationReachable(i, j, k, l)) {
            if (precation && !checkPositionDangerous(i, j, Player.P1)) {
              if (checkPositionDangerous(k, l, Player.P1)) {
                continue;
              }
            }
            print("Capture: Piece " +
                i.toString() +
                ":" +
                j.toString() +
                " to " +
                k.toString() +
                ":" +
                l.toString());
            piece.setCoordinates(i, j);
            executeMove(k, l);
            return true;
          }
        }
      }
    }

    return false;
  }

  bool checkPositionDangerous(int k, int l, Player p) {
    List<List<PieceService>> currentBoard = _board$.value;

    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        PieceService piece = currentBoard[i][j];
        if (piece.own$.value == p &&
            piece.checkDestinationReachable(i, j, k, l)) return true;
      }
    }

    return false;
  }

  bool moveDangerousPieces() {
    List<List<PieceService>> currentBoard = _board$.value;
    Player player = getPlaying();

    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        if (currentBoard[i][j].own$.value == player &&
            currentBoard[i][j].hasPossibleMovements(i, j, size) &&
            checkPositionDangerous(i, j, Player.P1)) {
          piece.setCoordinates(i, j);
          if (moveToSafety()) {
            return true;
          }
        }
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
            print("Move to safety" +
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
            print("Move to safety" +
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

  void carefulMove() {
    List<List<PieceService>> currentBoard = _board$.value;
    Player player = getPlaying();

    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        if (currentBoard[i][j].own$.value == player &&
            currentBoard[i][j].hasPossibleMovements(i, j, size) &&
            !checkPositionDangerous(i, j, Player.P1)) {
          piece.setCoordinates(i, j);
          if (moveToSafety()) return;
        }
      }
    }
  }

  void randomAIMove() {
    List<List<PieceService>> currentBoard = _board$.value;
    int count = 0;
    Player player = getPlaying();
//    print("Starting Random Move");

    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        if (currentBoard[i][j].own$.value == player &&
            currentBoard[i][j].hasPossibleMovements(i, j, size)) {
          count++;
        }
      }
    }

//    print("Possible pieces to move " + count.toString());

    int pieceIndex = random.nextInt(count);
//    print("Random pieceIndex = " + pieceIndex.toString());
    count = 0;
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        if (currentBoard[i][j].own$.value == player &&
            currentBoard[i][j].hasPossibleMovements(i, j, size)) {
          if (count == pieceIndex) {
            piece.setCoordinates(i, j);
//            print("Piece to move: " + i.toString() + ":" + j.toString());
            randomAIPieceMove();
            return;
          } else {
            count++;
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
    // TODO all
    
    switch (gameDifficulty$.value) {
      case Difficulty.Easy:
        break;
      case Difficulty.Medium:
        break;
      case Difficulty.Hard:
        break;
      default:
    }
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
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService(1, Player.P2, Player.P2 == _start),
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

    _start = Player.P1;
    _second = Player.P2;

    _board$ = BehaviorSubject<List<List<PieceService>>>.seeded([
      [
        PieceService(6, Player.P2, Player.P2 == _start),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
        PieceService.empty(),
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
        PieceService(1, Player.P2, Player.P2 == _start),
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
  }
}
