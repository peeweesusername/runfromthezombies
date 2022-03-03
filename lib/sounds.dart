import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class DyingScream {
  static AudioPlayer player = AudioPlayer();
  static AudioCache cache = AudioCache(fixedPlayer: player);
  static int numOfScreams=8;

  String selectscreamfn(){
    String fn;
    var rnd=Random();
    int i=rnd.nextInt(numOfScreams)+1;
    fn = 'deathscream'+i.toString()+'.mp3';
    return fn;
  }

  playScream() {
    String soundfn = selectscreamfn();
    cache.play(soundfn);
  }

  bool isStillPlaying() {
    return ((cache.fixedPlayer?.state == PlayerState.PLAYING));
  }

  pause() {
    cache.fixedPlayer?.pause();
  }

  stop() {
    cache.fixedPlayer?.stop();
  }
}

class StartScream {
  static AudioPlayer player = AudioPlayer();
  static AudioCache cache = AudioCache(fixedPlayer: player);
  static int numOfStartScreams=6;

  static String selectstartscreamfn(){
    String fn;
    var rnd=Random();
    int i=rnd.nextInt(numOfStartScreams)+1;
    fn = 'startscream'+i.toString()+'.mp3';
    return fn;
  }

  playStartScream() {
    if(cache.fixedPlayer?.state != PlayerState.PLAYING){
      cache.play(selectstartscreamfn());
    }
  }

  pause() {
    cache.fixedPlayer?.pause();
  }

  stop() {
    cache.fixedPlayer?.stop();
  }
}

class ZombieMoan {
  static AudioPlayer player = AudioPlayer();
  static AudioCache cache = AudioCache(fixedPlayer: player);
  static int numOfMoans=7;

  static String selectmoanfn(){
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