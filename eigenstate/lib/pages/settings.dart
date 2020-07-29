import 'package:eigenstate/services/board.dart';
import 'package:eigenstate/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/services/sound.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final boardService = locator<BoardService>();
  final soundService = locator<SoundService>();

  Future<void> addBoolToSF(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);

    if (key == "sound")
      soundService.enableSound$.add(value);
    else if (key == "board3D") boardService.thirdDimension$.add(value);
  }

  Future<bool> getBoolValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key))
      return prefs.getBool(key);
    else
      addBoolToSF(key, true);

    return true;
  }

  Future<void> _updateBoolValuesSF() async {
    boardService.thirdDimension$.add(await getBoolValuesSF("board3D"));
    soundService.enableSound$.add(await getBoolValuesSF("sound"));
  }

  @override
  void initState() {
    super.initState();
    _updateBoolValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MapEntry<bool, bool>>(
        stream: Rx.combineLatest2(soundService.enableSound$,
            boardService.thirdDimension$, (a, b) => MapEntry(a, b)),
        builder: (context, AsyncSnapshot<MapEntry<bool, bool>> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final bool isSoundEnabled = snapshot.data.key;
          final bool isThirdDimensionEnabled = snapshot.data.value;

          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Settings".toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Enable Sound",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        Expanded(child: Container()),
                        CupertinoSwitch(
                          onChanged: (e) {
                            addBoolToSF("sound", e);
                            soundService.playSound('sounds/slide');
                          },
                          value: isSoundEnabled,
                          activeColor: Themes.p1Orange,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Board 3D effect",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        Expanded(child: Container()),
                        CupertinoSwitch(
                          onChanged: (e) {
                            addBoolToSF("board3D", e);
                            soundService.playSound('sounds/slide');
                          },
                          value: isThirdDimensionEnabled,
                          activeColor: Themes.p1Orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
