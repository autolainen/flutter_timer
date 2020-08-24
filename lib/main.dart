import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer/cubit/timer_cubit.dart';
import 'package:flutter_timer/ticker.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Color.fromRGBO(109, 234, 255, 1),
            accentColor: Color.fromRGBO(72, 74, 126, 1),
            brightness: Brightness.dark),
        title: 'Flutter Timer',
        home: BlocProvider(
          create: (context) => TimerCubit(Ticker()),
          child: Timer(),
        ));
  }
}

class Timer extends StatelessWidget {
  static const TextStyle timerTextStyle =
      TextStyle(fontSize: 60, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Flutter Timer')),
        body: Stack(children: [
          Background(),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 100.0),
                    child: Center(child: BlocBuilder<TimerCubit, TimerState>(
                        builder: (context, state) {
                      return (int duration) {
                        final String minutesStr = ((duration / 60) % 60)
                            .floor()
                            .toString()
                            .padLeft(2, '0');
                        final String secondsStr =
                            (duration % 60).floor().toString().padLeft(2, '0');
                        return Text(
                          '$minutesStr:$secondsStr',
                          style: Timer.timerTextStyle,
                        );
                      }(state.duration);
                    }))),
                Actions()
              ])
        ]));
  }
}

class Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (state.status == TimerStatus.initial)
              FloatingActionButton(
                child: Icon(Icons.play_arrow),
                onPressed: () => context.bloc<TimerCubit>().start(),
              ),
            if (state.status == TimerStatus.running) ...[
              FloatingActionButton(
                child: Icon(Icons.pause),
                onPressed: () => context.bloc<TimerCubit>().pause(),
              ),
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () => context.bloc<TimerCubit>().reset(),
              )
            ],
            if (state.status == TimerStatus.paused) ...[
              FloatingActionButton(
                child: Icon(Icons.play_arrow),
                onPressed: () => context.bloc<TimerCubit>().resume(),
              ),
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () => context.bloc<TimerCubit>().reset(),
              )
            ],
          ],
        );
      },
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
        config: CustomConfig(
            gradients: [
              [
                Color.fromRGBO(72, 74, 126, 1),
                Color.fromRGBO(125, 170, 206, 1),
                Color.fromRGBO(184, 189, 245, 0.7)
              ],
              [
                Color.fromRGBO(72, 74, 126, 1),
                Color.fromRGBO(125, 170, 206, 1),
                Color.fromRGBO(172, 182, 219, 0.7)
              ],
              [
                Color.fromRGBO(72, 73, 126, 1),
                Color.fromRGBO(125, 170, 206, 1),
                Color.fromRGBO(190, 238, 246, 0.7)
              ],
            ],
            durations: [
              19440,
              10800,
              6000
            ],
            heightPercentages: [
              0.03,
              0.01,
              0.02
            ],
            gradientBegin: Alignment.bottomCenter,
            gradientEnd: Alignment.topCenter),
        size: Size(double.infinity, double.infinity),
        waveAmplitude: 25,
        backgroundColor: Colors.blue[50]);
  }
}
