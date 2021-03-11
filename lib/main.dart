import 'package:flutter/material.dart';
import 'dart:math'; // package to generate random color

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rainbow',
      home: RandColorBackground(),
    )); // start of the app

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

  @override
  Widget build(BuildContext context) {
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

  /// method for generation 1 random color from 37 colors from standard palettes
  /// using nextInt method from math package
  Color randomColorGeneration() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }
}
