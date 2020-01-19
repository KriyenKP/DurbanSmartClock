import 'dart:async';
import 'dart:ui';
import 'package:flutter/painting.dart';

import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:intl/intl.dart';
import 'package:flutter_clock_helper/model.dart';
import 'dart:developer';
import 'weather_box.dart';
import 'flipBoard.dart';

const String Day = "Day";
const String D2S = "Day2Sunset";
const String Sunset = "Sunset";
const String S2N = "Sunset2Night";
const String Night = "Night";
const String N2S = "Night2Sunrise";
const String Sunrise = "Sunrise";
const String S2D = "Sunrise2Day";

void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}

final defaultTheme = PixelClockTheme(
  globalTextStyle: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 70.0,
    color: Colors.white,
    decoration: TextDecoration.none,
    fontFamily: 'silkscreen',
  ),
  weatherBoxStroke: TextStyle(
    fontSize: 70.0,
    fontFamily: 'silkscreen',
    fontWeight: FontWeight.bold,
    foreground: Paint()
      ..strokeWidth = 5
      ..color = Colors.black
      ..style = PaintingStyle.stroke,
  ),
  weatherBoxTextStyle: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 70.0,
    color: Colors.white,
    decoration: TextDecoration.none,
    fontFamily: 'silkscreen',
  ),
);

class PixelClockTheme {
  const PixelClockTheme({
    @required this.globalTextStyle,
    @required this.weatherBoxStroke,
    @required this.weatherBoxTextStyle,
  });

  final TextStyle globalTextStyle;
  final TextStyle weatherBoxTextStyle;
  final TextStyle weatherBoxStroke;
}

class DigitalClock extends StatefulWidget {
  DigitalClock(this.model) : this.theme = defaultTheme;
  final ClockModel model;
  final PixelClockTheme theme;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  String currentAnimation;
  Timer _timer;
  String previous = "";

  var _temperature = '';
  var _weather;
  var _location = '';
  bool previousMode = false;

  int flipTimer =
      5; //this is a hack to get the flipboard of the clock to change for dark mode
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();

    super.initState();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    imageCache.clear();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _weather = widget.model.weatherCondition;
      _location = widget.model.location;
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    _dateTime = DateTime.now();
    final String next = dayProgression(_dateTime);
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      // _timer = Timer(
      //   Duration(minutes: 1) -
      //       Duration(seconds: _dateTime.second) -
      //       Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );

      if (next.compareTo(previous) != 0) {
        log("previous : " + previous);
        log("next : " + next);
        dayProgressionAnimate(next);
        previous = next;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateFormat('HH').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = DateFormat('ss').format(_dateTime);

    final isDarkMode = Theme.of(context).brightness != Brightness.light;

    int hourChangeInSeconds = 3600; // 3600;
    int minuteChangeInSeconds = 60; // 60;

    if (previousMode != isDarkMode) {
      log("change");
      //change flip timer to 1 seconds to switch frame to dark mode in place....this doesnt seem to work well...
      hourChangeInSeconds = 3600;
      minuteChangeInSeconds = 60;
      flipTimer--;
    }

    if (flipTimer <= 0) {
      previousMode = !previousMode;
      flipTimer = 5;
    }

    return Stack(
      children: <Widget>[
        SizedBox(
            child: FlareActor(
          "assets/DayNightCycle.flr",
          alignment: Alignment.center,
          fit: BoxFit.fill,
          animation: currentAnimation,
          callback: (string) {
            log(string);
          },
        )),

//time
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          FlipWidget(
            child: hour,
            bgColor: isDarkMode
                ? Colors.black.withAlpha(125)
                : Colors.white.withAlpha(125),
            txtColor: isDarkMode ? Colors.white : Colors.black,
            duration: Duration(seconds: hourChangeInSeconds),
          ),
          Text(
            ":",
            style: TextStyle(
                color: Colors.white,
                fontSize: 100,
                decoration: TextDecoration.none),
          ),
          FlipWidget(
            child: minute,
            bgColor: isDarkMode
                ? Colors.black.withAlpha(125)
                : Colors.white.withAlpha(125),
            txtColor: isDarkMode ? Colors.white : Colors.black,
            duration: Duration(seconds: minuteChangeInSeconds),
          ),
          Text(
            ":",
            style: TextStyle(
                color: Colors.white,
                fontSize: 100,
                decoration: TextDecoration.none),
          ),
          FlipWidget(
            child: second,
            bgColor: isDarkMode
                ? Colors.black.withAlpha(125)
                : Colors.white.withAlpha(125),
            txtColor: isDarkMode ? Colors.white : Colors.black,
            duration: Duration(seconds: 1),
          ),
        ]),

        Align(
          alignment: Alignment(0, 0.8),
          child: FractionallySizedBox(
            heightFactor: 0.16,
            child: Weather(
              weatherBoxStroke: widget.theme.weatherBoxStroke,
              weatherBox: widget.theme.weatherBoxTextStyle,
              weatherCondition: _weather,
              temperature: _temperature,
              location: _location,
            ),
          ),
        ),
      ],
    );
  }

  void _animateTo(String anim) {
    setState(() {
      currentAnimation = anim;
    });
  }

  String dayProgression(DateTime now) {
    int hours = now.hour;
    //final int minutes  = now.minute;
    //final int seconds = now.second;

    if (hours >= 0 && hours <= 4) //between Midnight and 4AM
    //if(seconds >= 0 && seconds <4) //debug
    {
      return Night;
    } else if (hours >= 4 && hours <= 9) //between 4AM and 9AM - Sunrise
    //if(seconds >= 4 && seconds <15) //debug
    {
      return Sunrise;
    } else if (hours > 9 && hours <= 16) //between 9AM and 4PM - Day
    //if(seconds >= 15 && seconds <30) //debug
    {
      return Day;
    } else if (hours > 16 && hours < 19) //between 4PM and 7PM - Sunset
    //if(seconds >= 30 && seconds < 45) //debug
    {
      return Sunset;
    }
    //else //between 7PM and 4AM - Night
    else {
      return Night;
    }
  }

  void dayProgressionAnimate(String timeOfDay) {
    int transitionSpeed = 4; // each transition lasts 4 seconds - Rive

    switch (timeOfDay) {
      case Day:
        {
          _animateTo(S2D);
          Timer(Duration(seconds: transitionSpeed), () {
            _animateTo(Day);
          });
          break;
        }
      case Sunset:
        {
          _animateTo(D2S);
          Timer(Duration(seconds: transitionSpeed), () {
            _animateTo(Sunset);
          });
          break;
        }
      case Sunrise:
        {
          _animateTo(N2S);
          Timer(Duration(seconds: transitionSpeed), () {
            _animateTo(Sunrise);
          });
          break;
        }
      case Night:
        {
          _animateTo(S2N);
          Timer(Duration(seconds: transitionSpeed), () {
            _animateTo(Night);
          });
          break;
        }
      default:
        {
          _animateTo(S2N);
          Timer(Duration(seconds: transitionSpeed), () {
            _animateTo(Night);
          });
          break;
        }
    }
  }
}
