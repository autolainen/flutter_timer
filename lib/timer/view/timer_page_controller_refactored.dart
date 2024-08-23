import 'dart:async';

import 'package:flutter_timer/ticker.dart';
import 'package:get/get.dart';

class TimerPageController {
  final duration = _initDuration.obs;
  final showPlayBtn = true.obs;
  final showPauseBtn = false.obs;
  final showResetBtn = false.obs;

  final Ticker _ticker;
  static const int _initDuration = 5;
  StreamSubscription<int>? _tickerSubscription;

  TimerPageController({required Ticker ticker}) : _ticker = ticker;

  void onPlayPress() {
    _tickerSubscription?.cancel();
    showPlayBtn.value = false;
    showPauseBtn.value = true;
    showResetBtn.value = true;

    _tickerSubscription = _ticker.tick(ticks: duration.value).listen((durationUpdate) {
      duration.value = durationUpdate;
      if (durationUpdate <= 0) {
        _onTimeOver();
      }
    });
  }

  void onPausePress() {
    _tickerSubscription?.cancel();
    showPlayBtn.value = true;
    showPauseBtn.value = false;
    showResetBtn.value = true;
  }

  void onResetPress() {
    _tickerSubscription?.cancel();
    duration.value = _initDuration;
    showPlayBtn.value = true;
    showPauseBtn.value = false;
    showResetBtn.value = false;
  }

  void _onTimeOver() {
    _tickerSubscription?.cancel();
    showPlayBtn.value = false;
    showPauseBtn.value = false;
    showResetBtn.value = true;
  }

  void dispose() {
    _tickerSubscription?.cancel();
  }
}
