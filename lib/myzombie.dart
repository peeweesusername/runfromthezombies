import 'dart:async';
import 'package:flutter/material.dart';
import './globals.dart';

//TO DO:
//1) Make zombie move in straight line towards human
//2) Animate the zombie image

class zombie extends StatefulWidget {
  zombie({Key? key, required this.notifyEaten, required this.getHumanPosition, required this.startX, required this.startY}) : super(key: key);
  final Function() notifyEaten;
  List<double> Function() getHumanPosition;
  final double startX;
  final double startY;

  @override
  State<zombie> createState() => _zombie();
}

class _zombie extends State<zombie> {
  late double _x;
  late double _y;
  late Timer timer;
  late bool isEaten;

  void updateZombiePosition() {
    double hx = widget.getHumanPosition()[0];
    double hy = widget.getHumanPosition()[1];
    double h;
    double v;

    if (isEaten) {
      //Human already has been eaten, don't update state
    } else {
      setState(() {
        if (hx > _x) {
          _x = _x + 1;
        } else {
          _x = _x - 1;
        }
        if (hy > _y) {
          _y = _y + 1;
        } else {
          _y = _y - 1;
        }
      });

      h = hx - _x;
      v = hy - _y;
      if ((h.abs() < geatenDistance) && (v.abs() < geatenDistance)) {
        isEaten=true;
        widget.notifyEaten();
      }
    }
  }

  @override
  void initState() {
    _x = widget.startX;
    _y = widget.startY;
    isEaten=false;
    timer = Timer.periodic(
        const Duration(milliseconds: 50), (Timer t) => updateZombiePosition());
    super.initState();
  }

  @override
  void dispose() {
     timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Positioned(
      left: _x,
      top: _y,
      child: Stack(
        children: const [
          Image(
            image: AssetImage('assets/zombie.png'),
            width: gimageSize,
            height: gimageSize,
          )
        ],
      ),
    );
  }
}
