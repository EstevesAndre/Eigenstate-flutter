import 'package:rxdart/rxdart.dart';
import 'package:eigenstate/services/board.dart';

enum Pin { Center, Active, Disable }

class PieceService {
  BehaviorSubject<int> _id$;
  BehaviorSubject<int> get id$ => _id$;

  BehaviorSubject<Player> _own$;
  BehaviorSubject<Player> get own$ => _own$;

  BehaviorSubject<List<List<Pin>>> _piece$;
  BehaviorSubject<List<List<Pin>>> get piece$ => _piece$;

  PieceService(int _id, Player _own) {
    _initStreams(_id, _own);
  }

  PieceService.empty() {
    _own$ = BehaviorSubject<Player>.seeded(null);
  }

  bool checkDestinationReachable(int i, int j) {
    // TODO missing verifications

    return true;
  }

  List<List<Pin>> getPins() {
    return _piece$.value;
  }

  void _initStreams(int _id, Player _own) {
    _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
      [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Disable, Pin.Disable],
      [
        Pin.Disable,
        Pin.Disable,
        _own == Player.P1 ? Pin.Active : Pin.Disable,
        Pin.Disable,
        Pin.Disable
      ],
      [Pin.Disable, Pin.Disable, Pin.Center, Pin.Disable, Pin.Disable],
      [
        Pin.Disable,
        Pin.Disable,
        _own == Player.P2 ? Pin.Active : Pin.Disable,
        Pin.Disable,
        Pin.Disable
      ],
      [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Disable, Pin.Disable]
    ]);

    _id$ = BehaviorSubject<int>.seeded(_id);

    _own$ = BehaviorSubject<Player>.seeded(_own);
  }
}
