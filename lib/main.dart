import 'package:flutter/material.dart';
import 'dart:async';
import './globals.dart';
import './screensize.dart';
import './myhuman.dart';
import './myzombies.dart';

//TO DO:
//1) Add fear sound on drag start
//2) Add scream in agony sound upon eaten in showRestart
//3) Prevent draggable from being dragged offscreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run From The Zombies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late HumanController humanController;
  late double _x;
  late double _y;
  late bool isEaten;
  late bool isDragging;
  late bool isNotBuilt;
  late Timer timer;
  late int secondsAlive;

  void restart() {
    setState(() {
      _x = screenCenter(context)[0]-adjustCenterPosition;
      _y = screenCenter(context)[1]-adjustCenterPosition;
      isEaten=false;
      isDragging=false;
      isNotBuilt=true;
      secondsAlive=0;
    });
  }

  void notifyEaten() {
    if (isEaten) {
      //Human already has been eaten, don't update state
    } else {
      if (isDragging) {
        humanController.humanNeedsUpdateCallback(true);
      }
      setState(() {
        isEaten = true;
      });
    }
  }

  List<double> getHumanPosition() {
    return [_x, _y];
  }

  void countSecondsAlive() {
    secondsAlive++;
  }

  Stack showRestart() {
  return Stack(
      children: [
        const Image(
          image: AssetImage('assets/blood.png'),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Center(
              child: Text('The Zombies Ate You',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 60,),
              ),
            ),
            Center(
              child: Text('You only lasted ' + secondsAlive.toString() + ' seconds',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 40,),
              ),
            ),
            Center(
              child: TextButton(
                child: const Text('Tap To Try Again', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20,),
                ),
              onPressed: () {
                restart();
              },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    isEaten=false;
    isDragging=false;
    isNotBuilt=true;
    humanController = HumanController();
    secondsAlive=0;
    timer = Timer.periodic(
        const Duration(milliseconds: 1000), (Timer t) => countSecondsAlive());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isNotBuilt){
      _x = screenCenter(context)[0]-adjustCenterPosition;
      _y = screenCenter(context)[1]-adjustCenterPosition;
      isNotBuilt = false;
    }
    return Scaffold(
      body: Center(
        child: isEaten? showRestart() : Stack(
          children: <Widget>[
            Positioned(
              left: _x,
              top: _y,
              child: Draggable(
                child: const Image(
                  image: AssetImage('assets/stick-figure-standing.png'),
                  width: gimageSize,
                  height: gimageSize,
                ),
                feedback: human(controller: humanController),
                childWhenDragging: Container(),
                onDragStarted: () {
                  isDragging=true;
                },
                onDragUpdate: (dragDetails) {
                  if (isEaten) {
                    //Human already has been eaten, don't update position
                  } else {
                    setState(() {
                      _x += dragDetails.delta.dx;
                      _y += dragDetails.delta.dy;
                    });
                  }
                },
                onDraggableCanceled: (velocity, offset) {
                  isDragging=false;
                },
              ),
            ),
            zombies(notifyEaten: notifyEaten, getHumanPosition: getHumanPosition),
          ],
        ),
      ),
    );
  }
}
