import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreService {
  BehaviorSubject<int> _coins$;
  BehaviorSubject<int> get coins$ => _coins$;

  int rewardVideoBonus;
  int endGameBonus;

  StoreService() {
    _coins$ = BehaviorSubject<int>.seeded(0);
    rewardVideoBonus = 100;
    endGameBonus = 45;
  }

  Future<void> _addIntToSF(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);

    if (key == "coins") _coins$.add(value);
  }

  Future<void> resetIntToSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, 0);

    if (key == "coins") _coins$.add(0);
  }

  Future<void> addRewardIntToSF(String key, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int actual = await _getIntValuesSF(key);
    int value = 0;

    if (type == "VideoReward")
      value = rewardVideoBonus;
    else if (type == "WinReward") value = endGameBonus;

    prefs.setInt(key, value + actual);
    if (key == "coins") _coins$.add(value + actual);
  }

  Future<int> _getIntValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key))
      return prefs.getInt(key);
    else
      _addIntToSF(key, 0);

    return 0;
  }

  Future<void> updateIntValuesSF() async {
    _coins$.add(await _getIntValuesSF("coins"));
  }

  void setBonuses(int endGame, int rewardedVideo) {
    endGameBonus = endGame;
    rewardVideoBonus = rewardedVideo;
  }
}
