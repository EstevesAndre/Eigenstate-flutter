import 'package:eigenstate/services/alert.dart';
import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/services/sound.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<BoardService>(BoardService());
  locator.registerSingleton<SoundService>(SoundService());
  locator.registerSingleton<AlertService>(AlertService());
}
