import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class DyingScream extends StatelessWidget{
  const DyingScream({Key? key}) : super(key: key);

  static int numOfScreams=8;

  String selectscreamfn(){
    String fn;
    var rnd=Random();
    int i=rnd.nextInt(numOfScreams)+1;
    fn = 'deathscream'+i.toString()+'.mp3';
    return fn;
  }

  playScream() {
    AudioCache player = AudioCache();
    String soundfn = selectscreamfn();
    player.play(soundfn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: playScream());
  }
}

class ZombieMoan {
  static AudioPlayer player = AudioPlayer();
  static AudioCache cache = AudioCache(fixedPlayer: player);
  static int numOfMoans=7;

  String selectmoanfn(){
    String fn;
    var rnd=Random();
    int i=rnd.nextInt(numOfMoans)+1;
    fn = 'zombie'+i.toString()+'.mp3';
    return fn;
  }

  playsingle() {
    cache.play(selectmoanfn());
  }

  playmaster() {
    cache.loop('zombiemaster.mp3');
  }

  pause() {
    cache.fixedPlayer?.pause();
  }

  stop() {
    cache.fixedPlayer?.stop();
  }
}