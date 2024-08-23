import 'package:flutter/material.dart';
import 'package:flutter_timer/ticker.dart';
import 'package:flutter_timer/timer/view/timer_page_controller_refactored.dart';
import 'package:get/get.dart';

class TimerPageRefactored extends StatefulWidget {
  const TimerPageRefactored({super.key});

  @override
  State<TimerPageRefactored> createState() => _TimerPageRefactoredState();
}

class _TimerPageRefactoredState extends State<TimerPageRefactored> {
  late final TimerPageController controller;

  @override
  void initState() {
    super.initState();
    controller = TimerPageController(ticker: const Ticker());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: Center(child: Obx(() => TimerText(duration: controller.duration.value))),
              ),
              Actions(controller),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text('REFACTORED'),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  final int duration;

  const TimerText({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w500),
    );
  }
}

class Actions extends StatelessWidget {
  final TimerPageController controller;

  const Actions(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (controller.showPlayBtn.value)
              FloatingActionButton(
                onPressed: controller.onPlayPress,
                child: const Icon(Icons.play_arrow),
              ),
            if (controller.showPauseBtn.value)
              FloatingActionButton(
                onPressed: controller.onPausePress,
                child: const Icon(Icons.pause),
              ),
            if (controller.showResetBtn.value)
              FloatingActionButton(
                onPressed: controller.onResetPress,
                child: const Icon(Icons.replay),
              ),
          ],
        ));
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade500,
            ],
          ),
        ),
      ),
    );
  }
}
