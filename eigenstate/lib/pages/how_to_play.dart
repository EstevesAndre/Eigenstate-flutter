import 'package:flutter/material.dart';

class HowToPlayPage extends StatefulWidget {
  @override
  HowToPlayState createState() => HowToPlayState();
}

class HowToPlayState extends State<HowToPlayPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Text(
              "TOCTOC",
            ),
          ),
        ),
    );
  }
}