import 'package:audioplayers/audioplayers.dart';
import 'package:exesices_app/hr.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HeartRateNotifier {
  AudioCache player = AudioCache();
  BehaviorSubject<RangeValues> _range$ =
      BehaviorSubject.seeded(RangeValues(60, 120));

  Stream<RangeValues> get range$ => _range$;

  setRange(RangeValues values) {
    _range$.add(values);
  }

  onInit(Stream<HRAction> hr$) {
    Stream.periodic(Duration(seconds: 5)).withLatestFrom2(
        hr$.where((event) => event is HRReceivedAction), range$,
        (_, _hr, _range) {
      var hr = _hr as HRReceivedAction;
      var range = _range as RangeValues;

      if (hr.payload < range.start || hr.payload > range.end) {
        player.play('bong.mp3', volume: 0.25);
      }
    }).listen((event) {});
  }

  dispose() {
    _range$.close();
  }
}
