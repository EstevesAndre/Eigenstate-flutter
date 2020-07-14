import 'package:rxdart/rxdart.dart';

enum Owner { P1, P2, Empty }
enum Pin { Center, Active, Disable }

class PieceService {

  BehaviorSubject<int> _id$;
  BehaviorSubject<int> get id$ => _id$;

  BehaviorSubject<Owner> _own$;
  BehaviorSubject<Owner> get own$ => _own$;

  BehaviorSubject<List<List<Pin>>> _piece$;
  BehaviorSubject<List<List<Pin>>> get piece$ => _piece$;

  PieceService(int _id, Owner _own) {
    _initStreams(_id, _own);
  }

  PieceService.empty() {
    _own$ = BehaviorSubject<Owner>.seeded(Owner.Empty);
  }

  void _initStreams(int _id, Owner _own) {
    _piece$ = BehaviorSubject<List<List<Pin>>>.seeded([
      [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Disable, Pin.Disable],
      [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Disable, Pin.Disable],
      [Pin.Disable, Pin.Disable, Pin.Center, Pin.Disable, Pin.Disable],
      [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Disable, Pin.Disable],
      [Pin.Disable, Pin.Disable, Pin.Disable, Pin.Disable, Pin.Disable]
    ]);

    _id$ = BehaviorSubject<int>.seeded(_id);

    _own$ = BehaviorSubject<Owner>.seeded(_own);

  }
}