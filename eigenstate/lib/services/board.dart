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

  Player _start;
  Player _second;

  Phase turnPhase;

  Coordinate piece;
  int pinsSelected;

  BoardService() {
    _initStreams();
  }

  Player _checkWinner() {
    // TODO
    return null;
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

  List<List<Pin>> getPiecePins(int i, int j) {
    return _board$.value[i][j].getPins();
  }

  void nextTurn() {
    int round = _rounds$.value.key;
    Player actual = _rounds$.value.value;

    if (_start == actual) {
      _rounds$.add(MapEntry(round, _second));
    } else {
      _rounds$.add(MapEntry(round + 1, _start));
    }

    turnPhase = Phase.ChoosePieceToMove;
  }

  void play(int i, int j) {
    List<List<PieceService>> currentBoard = _board$.value;

    PieceService piece = currentBoard[i][j];
    PieceService pempty = currentBoard[4][0];

    currentBoard[4][0] = piece;
    currentBoard[i][j] = pempty;

    nextTurn();

    _board$.add(currentBoard);
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
        .checkDestinationReachable(i, j);
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

    _start = Player.P1;
    _second = Player.P2;
    turnPhase = Phase.ChoosePieceToMove;
    piece = Coordinate.origin();
    pinsSelected = 0;
  }
}
