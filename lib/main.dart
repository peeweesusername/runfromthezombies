import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import './globals.dart';
import './screensize.dart';
import './myhuman.dart';
import './myzombies.dart';
import './sounds.dart';

//TO DO:
//1) Feature: Prevent draggable from being dragged offscreen
//2) Feature: Fade to showRestart - https://api.flutter.dev/flutter/widgets/FadeTransition-class.html
//5) Feature: Do not display restart button until dying scream is completed
//- Modify DyingScream to be like StartScream.
//- Add method bool doneScreaming() that returns false if(cache.fixedPlayer?.state == PlayerState.PLAYING) else true
//- At top of showRestart method add call DyingScream().playDyingScream()
//- For restart button widget, add check of if (DyingScream().doneScreaming()) to setstate and display TextButton() otherwise empty Container()
//6) Feature: Animate gif of zombie. See https://insider.office.com/en-us/blog/export-animated-gifs-transparent-backgrounds
//7) Feature: Rotate/flip zombie/human images in direction of motion
//8) Feature: Transparent background on animated gifs zombie/human. See https://insider.office.com/en-us/blog/export-animated-gifs-transparent-backgrounds
//9) Feature: Fade into showRestart screen
//10) Feature: modify icons to show full image, not circumscribed image

void main() {
  //Prevent screen rotation
  //App is portrait orientation only
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Run From The Zombies',
      home: MyHomePage(),
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
        //Only call this while dragging
        //Otherwise the feedback widget doesn't exist in tree
        //and throws exception
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
        const DyingScream(),
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
              child: Text('You lasted only ' + secondsAlive.toString() + ' seconds',
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
    _x = 100.0;
    _y = 100.0;
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
                  StartScream().playStartScream();
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
