import 'package:eigenstate/services/admob.dart';
import 'package:eigenstate/services/alert.dart';
import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/sound.dart';
import 'package:eigenstate/services/store.dart';
import 'package:eigenstate/theme/theme.dart';
import 'package:get_it/get_it.dart';

import 'package:admob_flutter/admob_flutter.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<Themes>(Themes());
  locator.registerSingleton<StoreService>(StoreService());
  locator.registerSingleton<SoundService>(SoundService());
  locator.registerSingleton<BoardService>(BoardService());
  locator.registerSingleton<AlertService>(AlertService());
  locator.registerSingleton<AdMobService>(AdMobService());

  setupTheme();

  Admob.initialize(locator<AdMobService>().getAdMobAppId());
}

Future<void> setupTheme() async {
  await locator<Themes>().init();
}
