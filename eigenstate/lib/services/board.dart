import 'package:eigenstate/services/piece.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math' as math;

import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/services/sound.dart';

final soundService = locator<SoundService>();

enum Player { P1, P2 }
enum BoardState { EndGame, Play }
enum GameMode { Solo }
enum Difficulty { Easy, Medium, Hard }

class BoardService {
  static const size = 6;

  BehaviorSubject<List<List<PieceService>>> _board$;
  BehaviorSubject<List<List<PieceService>>> get board$ => _board$;

  BehaviorSubject<Player> _player$;
  BehaviorSubject<Player> get player$ => _player$;

  BehaviorSubject<MapEntry<BoardState, Player>> _boardState$;
  BehaviorSubject<MapEntry<BoardState, Player>> get boardState$ => _boardState$;

  BehaviorSubject<GameMode> _gameMode$;
  BehaviorSubject<GameMode> get gameMode$ => _gameMode$;

  BehaviorSubject<Difficulty> _gameDifficulty$;
  BehaviorSubject<Difficulty> get gameDifficulty$ => _gameDifficulty$;

  BehaviorSubject<MapEntry<int, int>> _score$;
  BehaviorSubject<MapEntry<int, int>> get score$ => _score$;

  Player _start;

  BoardService() {
    _initStreams();
  }

  Player _checkWinner() {
    // TODO 
    return null;
  }

  void setGameDifficulty(Difficulty difficulty) {
    _gameDifficulty$.add(difficulty);
  }

  void setPlayerStart(Player p) {
    _start = p;
  }

  void switchPlayer(Player player) {
    player == Player.P1 ? _player$.add(Player.P2) : _player$.add(Player.P1);
  }

  void resetBoard() {
    _board$.add([
      [PieceService(1, Owner.P2), PieceService(2, Owner.P2), PieceService(3, Owner.P2), PieceService(4, Owner.P2), PieceService(5, Owner.P2), PieceService(6, Owner.P2)],
      [PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty()],
      [PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty()],
      [PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty()],
      [PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty()],
      [PieceService(1, Owner.P1), PieceService(2, Owner.P1), PieceService(3, Owner.P1), PieceService(4, Owner.P1), PieceService(5, Owner.P1), PieceService(6, Owner.P1)]
    ]);

    _player$.add(_player$.value == Player.P1 ? Player.P2 : Player.P1);

    setPlayerStart(_player$.value);

    _boardState$.add(MapEntry(BoardState.Play, null));
  }

  void newGame() {
    resetBoard();
    _score$.add(MapEntry(0, 0));
  }

  void _initStreams() {
    _board$ = BehaviorSubject<List<List<PieceService>>>.seeded([
      [PieceService(1, Owner.P2), PieceService(2, Owner.P2), PieceService(3, Owner.P2), PieceService(4, Owner.P2), PieceService(5, Owner.P2), PieceService(6, Owner.P2)],
      [PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty()],
      [PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty()],
      [PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty()],
      [PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty(), PieceService.empty()],
      [PieceService(1, Owner.P1), PieceService(2, Owner.P1), PieceService(3, Owner.P1), PieceService(4, Owner.P1), PieceService(5, Owner.P1), PieceService(6, Owner.P1)]
    ]);

    _player$ = BehaviorSubject<Player>.seeded(Player.P1);

    _boardState$ = BehaviorSubject<MapEntry<BoardState, Player>>.seeded(MapEntry(BoardState.Play, null));

    _gameMode$ = BehaviorSubject<GameMode>.seeded(GameMode.Solo);

    _gameDifficulty$ = BehaviorSubject<Difficulty>.seeded(Difficulty.Easy);

    _score$ = BehaviorSubject<MapEntry<int, int>>.seeded(MapEntry(0, 0));

    _start = Player.P1;
  }
}