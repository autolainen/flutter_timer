part of 'timer_cubit.dart';

enum TimerStatus { initial, running, paused }

class TimerState extends Equatable {
  const TimerState({
    @required this.duration,
    this.status = TimerStatus.initial,
  });

  final int duration;
  final TimerStatus status;

  TimerState copyWith({int duration, TimerStatus status}) {
    return TimerState(
      duration: duration ?? this.duration,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [duration, status];
}
