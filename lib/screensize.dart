import 'package:flutter/material.dart';
import 'dart:math';

enum screenCorner {
  upperRight,
  lowerRight,
  lowerLeft,
  upperLeft
}

enum screenEdge {
  topEdge,
  rightEdge,
  bottomEdge,
  leftEdge
}

List<double> screenSize(BuildContext context) {
  List<double> size=List<double>.empty(growable: true);
  size.add(MediaQuery.of(context).size.width.roundToDouble());
  size.add(MediaQuery.of(context).size.height.roundToDouble());
  return size;
}

List<double> screenCenter(BuildContext context) {
  List<double> center=List<double>.empty(growable: true);
  center.add((MediaQuery.of(context).size.width.roundToDouble())/2.0);
  center.add((MediaQuery.of(context).size.height.roundToDouble())/2.0);
  //System sometimes not ready at launch and can return 0.0
  //In this case, return 100,100
  if(center[0]==0.0) {
    center[0]=100.0;
  }
  if(center[1]==0.0) {
    center[1]=100.0;
  }
  return center;
}

List<double> screenUpperRight(BuildContext context) {
  List<double> upperight=List<double>.empty(growable: true);
  upperight.add(MediaQuery.of(context).size.width.roundToDouble());
  upperight.add(0.0);
  return upperight;
}

List<double> screenLowerRight(BuildContext context) {
  List<double> loweright=List<double>.empty(growable: true);
  loweright.add(MediaQuery.of(context).size.width.roundToDouble());
  loweright.add(MediaQuery.of(context).size.height.roundToDouble());
  return loweright;
}

List<double> screenLowerLeft(BuildContext context) {
  List<double> lowerleft=List<double>.empty(growable: true);
  lowerleft.add(0.0);
  lowerleft.add(MediaQuery.of(context).size.height.roundToDouble());
  return lowerleft;
}

List<double> screenUpperLeft(BuildContext context) {
  List<double> upperleft=List<double>.empty(growable: true);
  upperleft.add(0.0);
  upperleft.add(0.0);
  return upperleft;
}

List<double> screenRandomEdgeStart(BuildContext context) {
  List<double> randomstart=List<double>.empty(growable: true);
  double x=0.0;
  double y=0.0;
  double w=MediaQuery.of(context).size.width.roundToDouble();
  double h=MediaQuery.of(context).size.height.roundToDouble();
  var rnd=Random();
  int i=rnd.nextInt(screenEdge.leftEdge.index+1);
  screenEdge edge=screenEdge.values[i];

  switch(edge) {
    case screenEdge.topEdge:
      {
        x=rnd.nextDouble()*w;
        y=0.0;
      }
      break;
    case screenEdge.rightEdge:
      {
        x=w;
        y=rnd.nextDouble()*h;
      }
      break;
    case screenEdge.bottomEdge:
      {
        x=rnd.nextDouble()*w;
        y=h;
      }
      break;
    case screenEdge.leftEdge:
      {
        x=0.0;
        y=rnd.nextDouble()*h;
      }
      break;
  }

  randomstart.add(x);
  randomstart.add(y);

  return randomstart;
}