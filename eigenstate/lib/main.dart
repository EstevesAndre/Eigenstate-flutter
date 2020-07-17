import 'package:flutter/material.dart';
import 'package:eigenstate/services/provider.dart';
import 'package:eigenstate/pages/Home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eigenstate',
      theme: ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: true,
      home: HomePage(),
    );
  }
}
