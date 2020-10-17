library countdown_timer;

import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  /// Widget build a countdown timer

  CountdownTimer(
    this.to,
    {
      this.builder
    }
  );
  final DateTime to;
  final Widget Function(BuildContext context, String hour, String minute, String seconds) builder;

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer _timer;

  String _seconds = '00';
  String _minute = '00';
  String _hour = '00';

  void startTimer() {
    _timer = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          DateTime today = DateTime.now();
          var diff = widget.to.difference(today);
          if (diff.inSeconds <= 0) {
            timer.cancel();
          }
          String twoDigits(int n) => n.toString().padLeft(2, "0");
          String twoDigitMinutes = twoDigits(diff.inMinutes.remainder(60));
          String twoDigitSeconds = twoDigits(diff.inSeconds.remainder(60));
          setState(() {
            _hour = twoDigits(diff.inHours);
            _minute = twoDigitMinutes;
            _seconds = twoDigitSeconds;
          });
        },
      ),
    );
  }
  
  String format(int value) {
    return value < 10 ? '0' + value.toString() : value.toString();
  }
  Widget buildTimeElement(String value) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(3)
      ),
      constraints: BoxConstraints(
        minWidth: 20
      ),
      child: Center(child: Text(value, style: TextStyle(color: Colors.white, fontSize: 9),)),
    );
  }
  Widget buildDevide() {
    return Padding(
      padding: EdgeInsets.fromLTRB(2, 0, 2, 2),
      child: Text(':', style: TextStyle(color: Colors.black26, fontSize: 11),),
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  Widget build(BuildContext context) {
    if (widget.builder != null) return widget.builder(context, _hour, _minute, _seconds);
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        buildTimeElement(_hour),
        buildDevide(),
        buildTimeElement(_minute),
        buildDevide(),
        buildTimeElement(_seconds),
      ],
    );
  }
}
