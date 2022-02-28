import 'package:flutter/material.dart';
import 'dart:async';
import './screensize.dart';
import '/myzombie.dart';
import './sounds.dart';

class zombies extends StatefulWidget {
  zombies({Key? key, required this.notifyEaten, required this.getHumanPosition}) : super(key: key);
  VoidCallback notifyEaten;
  List<double> Function() getHumanPosition;

  @override
  State<zombies> createState() => _zombies();
}

class _zombies extends State<zombies> {
  late Timer timer;
  late screenCorner theCorner;
  final zombieMoan = ZombieMoan();

  List<Widget> zombiesList = List<Widget>.empty(growable: true);

  void addMoreZombiesAtEdge() {
    List<double> edgestart=List<double>.empty(growable: true);
    edgestart=(screenRandomEdgeStart(context));
    setState(() {
      zombiesList.add(zombie(notifyEaten: widget.notifyEaten, getHumanPosition: widget.getHumanPosition, startX:edgestart[0], startY:edgestart[1]));
    });
  }

  void addMoreZombiesAtCorners(){
    double x = screenUpperRight(context)[0];
    double y = screenUpperRight(context)[1];

    switch(theCorner) {
      case screenCorner.upperRight:{
        x = screenUpperRight(context)[0];
        y = screenUpperRight(context)[1];
        theCorner = screenCorner.lowerRight;
      }
      break;
      case screenCorner.lowerRight:{
        x = screenLowerRight(context)[0];
        y = screenLowerRight(context)[1];
        theCorner = screenCorner.lowerLeft;
      }
      break;
      case screenCorner.lowerLeft:{
        x = screenLowerLeft(context)[0];
        y = screenLowerLeft(context)[1];
        theCorner = screenCorner.upperLeft;
      }
      break;
      case screenCorner.upperLeft:{
        x = screenUpperLeft(context)[0];
        y = screenUpperLeft(context)[1];
        theCorner = screenCorner.upperRight;
      }
      break;
    }

    setState(() {
      zombiesList.add(zombie(notifyEaten: widget.notifyEaten, getHumanPosition: widget.getHumanPosition, startX: x, startY: y));
    });
  }

  @override
  void initState() {
    theCorner = screenCorner.upperRight;
    zombieMoan.playmaster();
    timer = Timer.periodic(
        const Duration(milliseconds: 1000), (Timer t) => addMoreZombiesAtEdge());
    super.initState();
  }

  @override
  void dispose() {
    zombieMoan.pause();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: zombiesList);
  }
}