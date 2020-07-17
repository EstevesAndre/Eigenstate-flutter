import 'dart:math';

import 'package:eigenstate/components/piece.dart';
import 'package:rxdart/rxdart.dart';

import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/services/piece.dart';
import 'package:eigenstate/services/sound.dart';
import 'package:eigenstate/services/coord.dart';

final soundService = locator<SoundService>();

enum Player { P1, P2 }
enum BoardState { EndGame, Play }
enum GameMode { Solo }
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

    if (p != null) {
      print("GANHOUU");
      print(p);
      // TODO
      //parar o jogo.

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
  }

  int handleClick(int i, int j) {
    print(turnPhase);

    switch (turnPhase) {
      case Phase.ChoosePieceToMove:
        if (checkPiece(i, j)) {
          turnPhase = Phase.Destination;
          piece.setCoordinates(i, j);
        }
        break;
      case Phase.Destination:
        if (checkDestination(i, j)) {
          executeMove(i, j);
          turnPhase = Phase.ChoosePieceToPin;
        }
        break;
      case Phase.ChoosePieceToPin:
        if (checkPiece(i, j)) {
          turnPhase = Phase.ChoosePins;
          piece.setCoordinates(i, j);
          return 1;
        }
        break;
      case Phase.ChoosePins:
        List<List<PieceService>> currentBoard = _board$.value;
        if (currentBoard[piece.getI()][piece.getJ()].checkPin(i, j)) {
          pinsSelected++;
          currentBoard[piece.getI()][piece.getJ()].addPin(i, j);
          _board$.add(currentBoard);

          if (pinsSelected == 2)
            return 2; // finish phase
          else
            return 3; // alert dialog change
        }
        break;
      default:
    }

    print(turnPhase);

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
      piece.setCoordinates(i, j);
      return false;
    }

    return currentBoard[piece.getI()][piece.getJ()]
        .checkDestinationReachable(piece.getI(), piece.getJ(), i, j);
  }

  void executeMove(int i, int j) {
    List<List<PieceService>> currentBoard = _board$.value;

    currentBoard[i][j] = currentBoard[piece.getI()][piece.getJ()];
    currentBoard[piece.getI()][piece.getJ()] = PieceService.empty();

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

  void resetBoard() {
    print("Reset Board\n");

    _board$.add([
      [
        PieceService(6, Player.P2),
        PieceService(5, Player.P2),
        PieceService(4, Player.P2),
        PieceService(3, Player.P2),
        PieceService(2, Player.P2),
        PieceService(1, Player.P2)
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
        PieceService(1, Player.P1),
        PieceService(2, Player.P1),
        PieceService(3, Player.P1),
        PieceService(4, Player.P1),
        PieceService(5, Player.P1),
        PieceService(6, Player.P1)
      ]
    ]);

    setPlayerStart();
    _rounds$.add(MapEntry(1, _start));

    _boardState$.add(MapEntry(BoardState.Play, null));

    turnPhase = Phase.ChoosePieceToMove;
    piece = Coordinate.origin();
    pinsSelected = 0;
  }

  void newGame() {
    resetBoard();
    _score$.add(MapEntry(0, 0));
  }

  void _initStreams() {
    print("Initiate Streams\n");

    _board$ = BehaviorSubject<List<List<PieceService>>>.seeded([
      [
        PieceService(6, Player.P2),
        PieceService(5, Player.P2),
        PieceService(4, Player.P2),
        PieceService(3, Player.P2),
        PieceService(2, Player.P2),
        PieceService(1, Player.P2)
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
        PieceService(1, Player.P1),
        PieceService(2, Player.P1),
        PieceService(3, Player.P1),
        PieceService(4, Player.P1),
        PieceService(5, Player.P1),
        PieceService(6, Player.P1)
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

    _start = Player.P1;
    _second = Player.P2;
    turnPhase = Phase.ChoosePieceToMove;
    piece = Coordinate.origin();
    pinsSelected = 0;
  }
}
