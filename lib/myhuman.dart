import 'package:flutter/material.dart';
import './globals.dart';
//TO DO:
//1) Add continuous running sound while dragging

class HumanController {
  late Function(bool) humanNeedsUpdateCallback;
}

class human extends StatefulWidget {
  const human({Key? key, required this.controller}) : super(key: key);
  final HumanController controller;

  @override
  State<human> createState() => _human();
}

class _human extends State<human> {

  bool isOnTarget=false;

  @override
  void initState() {
    isOnTarget = false;
    widget.controller.humanNeedsUpdateCallback = humanNeedsUpdateCallbackHandler;
    super.initState();
  }

  void humanNeedsUpdateCallbackHandler(bool t) {
    setState(() {
      isOnTarget = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  isOnTarget? Container() :  const Image(
      image: AssetImage('assets/stick-figure-running.gif'),
      width: gimageSize,
      height: gimageSize,
    );
  }
}