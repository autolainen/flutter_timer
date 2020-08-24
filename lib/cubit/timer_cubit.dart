import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../ticker.dart';

part 'timer_state.dart';

const int _duration = 60;

class TimerCubit extends Cubit<TimerState> {
  TimerCubit(this._ticker) : super(TimerState(duration: _duration));

  StreamSubscription<int> _subscription;

  final Ticker _ticker;

  void reset() {
    emit(TimerState(duration: _duration));
    _subscription?.cancel();
  }

  Future<void> start() async {
    if (state.status == TimerStatus.initial) {
      emit(state.copyWith(status: TimerStatus.running));
      await _subscription?.cancel();
      _subscription = _ticker
          .tick(ticks: _duration)
          .listen((duration) => emit(state.copyWith(duration: duration)));
    }
  }

  void resume() {
    if (state.status == TimerStatus.paused) {
      emit(state.copyWith(status: TimerStatus.running));
      _subscription?.resume();
    }
  }

  void pause() {
    if (state.status == TimerStatus.running) {
      emit(state.copyWith(status: TimerStatus.paused));
      _subscription?.pause();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
