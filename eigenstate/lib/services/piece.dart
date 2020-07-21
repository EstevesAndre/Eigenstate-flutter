import 'package:rxdart/rxdart.dart';
import 'package:eigenstate/services/board.dart';

enum Pin { Center, Active, Disable }

class PieceService {
  static const size = 5;

  BehaviorSubject<int> _id$;
  BehaviorSubject<int> get id$ => _id$;

  BehaviorSubject<Player> _own$;
  BehaviorSubject<Player> get own$ => _own$;

  BehaviorSubject<List<List<Pin>>> _piece$;
  BehaviorSubject<List<List<Pin>>> get piece$ => _piece$;

  BehaviorSubject<bool> _toAnimate$;
  BehaviorSubject<bool> get toAnimate$ => _toAnimate$;

  BehaviorSubject<bool> _pieceMoved$;
  BehaviorSubject<bool> get pieceMoved$ => _pieceMoved$;


  PieceService(int _id, Player _own, bool _toAnimate) {
    _initStreams(_id, _own, _toAnimate);
  }

  PieceService.empty() {
    _own$ = BehaviorSubject<Player>.seeded(null);
    _toAnimate$ = BehaviorSubject<bool>.seeded(false);
    _pieceMoved$ = BehaviorSubject<bool>.seeded(false);
  }

  PieceService.number(int number, Player p) {
    _own$ = BehaviorSubject<Player>.seeded(p);
    createPiece(number);
    _toAnimate$ = BehaviorSubject<bool>.seeded(false);
    _pieceMoved$ = BehaviorSubject<bool>.seeded(false);
  }

  bool checkDestinationReachable(
      int positionI, int positionJ, int destinationI, int destinationJ) {
    int offsetI = destinationI - positionI;
    int offsetJ = destinationJ - positionJ;

//    print("Pos: " + positionI.toString() + " " + positionJ.toString());
//    print("Des: " + destinationI.toString() + " " + destinationJ.toString());
//    print("Offset: " + offsetI.toString() + " " + offsetJ.toString());

    if (offsetI < -2 || offsetJ < -2 || offsetI > 2 || offsetJ > 2)
      return false;

    return _piece$.value[2 + offsetI][2 + offsetJ] == Pin.Active;
  }

  List<List<Pin>> getPins() {
    return _piece$.value;
  }

  bool checkFullPin() {
    bool isFull = true;

    _piece$.value.forEach((line) =>
        line.forEach((pin) => pin == Pin.Disable ? isFull = false : null));

    return isFull;
  }

  bool checkPin(int i, int j) {
    if (handleInput(i, j)) return false;

    List<List<Pin>> currentPins = _piece$.value;

    return currentPins[i][j] == Pin.Disable;
  }

  void addPin(int i, int j) {
    List<List<Pin>> actual = _piece$.value;

    actual[i][j] = Pin.Active;

    _piece$.add(actual);
  }

  bool handleInput(int i, int j) {
    return i >= size || j >= size || i < 0 || j < 0;
  }

  void createPiece(int number) {
    switch (number) {
      case 0:
        _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable]
        ]);
        break;
      case 1:
        _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
          [Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable]
        ]);
        break;
      case 2:
        _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable]
        ]);
        break;
      case 3:
        _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable]
        ]);
        break;
      case 4:
        _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
          [Pin.Disable, Pin.Active, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable]
        ]);
        break;
      case 5:
        _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Disable, Pin.Disable, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable]
        ]);
        break;
      case 6:
        _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Disable, Pin.Disable, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable]
        ]);
        break;
      case 7:
        _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable]
        ]);
        break;
      case 8:
        _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable]
        ]);
        break;
      case 9:
        _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Active, Pin.Disable],
          [Pin.Disable, Pin.Active, Pin.Active, Pin.Active, Pin.Disable]
        ]);
        break;
      case 10:
        _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
          [
            Pin.Disable,
            Pin.Active,
            Pin.Disable,
            Pin.Active,
            Pin.Active,
            Pin.Active
          ],
          [
            Pin.Active,
            Pin.Active,
            Pin.Disable,
            Pin.Active,
            Pin.Disable,
            Pin.Active
          ],
          [
            Pin.Disable,
            Pin.Active,
            Pin.Disable,
            Pin.Active,
            Pin.Disable,
            Pin.Active
          ],
          [
            Pin.Disable,
            Pin.Active,
            Pin.Disable,
            Pin.Active,
            Pin.Disable,
            Pin.Active
          ],
          [
            Pin.Disable,
            Pin.Active,
            Pin.Disable,
            Pin.Active,
            Pin.Active,
            Pin.Active
          ],
        ]);
        break;
      default:
        _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
          [
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active
          ],
          [
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active
          ],
          [
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active
          ],
          [
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active
          ],
          [
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active,
            Pin.Active
          ],
        ]);
    }
  }

  void _initStreams(int _id, Player _own, bool _toAnimate) {
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

    _toAnimate$ = BehaviorSubject<bool>.seeded(_toAnimate);
    _pieceMoved$ = BehaviorSubject<bool>.seeded(false);
  }
}
