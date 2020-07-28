import 'package:eigenstate/services/admob.dart';
import 'package:eigenstate/services/alert.dart';
import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/sound.dart';
import 'package:get_it/get_it.dart';

import 'package:admob_flutter/admob_flutter.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<BoardService>(BoardService());
  locator.registerSingleton<SoundService>(SoundService());
  locator.registerSingleton<AlertService>(AlertService());
  locator.registerSingleton<AdMobService>(AdMobService());

  Admob.initialize(locator<AdMobService>().getAdMobAppId());
}
