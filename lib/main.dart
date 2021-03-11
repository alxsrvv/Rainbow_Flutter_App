import 'package:flutter/material.dart';
import 'dart:math'; // package to generate random color
import 'package:shared_preferences/shared_preferences.dart'; // package for only first load dialog

void main() => runApp(RainbowApp()); // start of the app

class RainbowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rainbow',
      home: RandColorBackground(),
    );
  }
}

// Instance creater for _RandColorBackgroundState widget
class RandColorBackground extends StatefulWidget {
  @override
  _RandColorBackgroundState createState() => _RandColorBackgroundState();
  Color get bgColor => createState().tempBackgroundColor;
}

/// Widget class that changing color on tap anywhere on the screen
/// and if it is first load of the app, it will start Dialog with greetings
class _RandColorBackgroundState extends State<RandColorBackground> {
  // tempBackgroundColor field is temporary value for backgroundColor of the material app Scaffold
  Color tempBackgroundColor = Colors.grey[300];

  // keyIsFirstLoaded field: null - first app load / false - app is reloaded
  final keyIsFirstLoaded = null;

  @override
  Widget build(BuildContext context) {
    // The Dialog showing after 1 sec, so user can see animation for first app loading
    Future.delayed(
        Duration(seconds: 1), () => showDialogIfFirstLoaded(context));

    return Scaffold(
      // backgroundColor of Scaffold is always linked to tempBackgroundColor field
      backgroundColor: tempBackgroundColor,

      // body consists with stack, so gestures detects even ON the 'Hey there' text
      body: Stack(
        children: <Widget>[
          Center(
            child: Text(
              'Hey there',
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // respond for tapping
              Feedback.forTap(context);
              // update when screen is tapped, so tempBackgroundColor is changing
              setState(() {
                tempBackgroundColor = randomColorGeneration();
              });
            },
          ),
        ],
      ),
    );
  }

  /// asynchronous method that start Dialog with greetings when it is first load of the app
  /// it is saving data about first launching with the SharedPreferences package
  showDialogIfFirstLoaded(BuildContext context) async {
    SharedPreferences tmpData = await SharedPreferences.getInstance();

    bool isFirstLoaded = tmpData.getBool(keyIsFirstLoaded);
    // if the app is launching for the first time - shows Dialog with greetings
    if (isFirstLoaded == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            // formatting dialog textes
            return AlertDialog(
              title: Text(
                'Hi, solid software!',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              content: Text(
                'Rainbow app is curious because it is changing the background randomly whenever you tap the screen!\n\n' +
                    'Attention!\nThe app may trigger seizures for people with photosensitive epilepsy!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Let's play!",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  // if user pressed 'Let's play!' button - Dialog will never shows again
                  onPressed: () {
                    Navigator.of(context).pop();
                    // SharedPreferences instance tmpData changes field keyIsFirstLoaded
                    tmpData.setBool(keyIsFirstLoaded, false);
                  },
                )
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
            );
          });
    }
  }

  /// method for generation 1 random color from 37 colors from standard palettes
  /// using nextInt method from math package
  Color randomColorGeneration() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }
}
