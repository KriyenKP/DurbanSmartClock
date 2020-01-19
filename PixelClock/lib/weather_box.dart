import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:bordered_text/bordered_text.dart';

import 'dart:developer';

final weatherIcons = {
  WeatherCondition.cloudy: Image.asset(
    "assets/cloudy.png",
  ),
  WeatherCondition.foggy: Image.asset(
    "assets/fog.png",
  ),
  WeatherCondition.rainy: Image.asset(
    "assets/rain.png",
  ),
  WeatherCondition.snowy: Image.asset(
    "assets/snow.png",
  ),
  WeatherCondition.sunny: Image.asset(
    "assets/sunny.png",
  ),
  WeatherCondition.thunderstorm: Image.asset(
    "assets/thunderstorm.png",
  ),
  WeatherCondition.windy: Image.asset(
    "assets/wind.png",
  ),
};

class Weather extends StatelessWidget {
  const Weather({
    Key key,
    @required this.weatherBox,
    @required this.weatherBoxStroke,
    @required this.weatherCondition,
    @required this.location,
    @required this.temperature,
  }) : super(key: key);

  final TextStyle weatherBox;
  final TextStyle weatherBoxStroke;
  final weatherCondition;
  final location;
  final temperature;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness != Brightness.light;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
          elevation: 10,
          color: isDarkMode
              ? Colors.black.withAlpha(125)
              : Colors.white.withAlpha(125),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(250)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    //gap
                    width: constraints.maxHeight * 0.5,
                  ),
                  Container(
                    //gap
                    width: constraints.maxHeight * 0.8,
                    child: AspectRatio(
                      aspectRatio: 0.5,
                      child: weatherIcons[weatherCondition],
                    ),
                  ),
                  Container(
                    //weather icon
                    height: constraints.maxHeight,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Container(
                          //text
                          margin: EdgeInsets.symmetric(
                              vertical: constraints.maxHeight * 0.1,
                              horizontal: constraints.maxHeight * 0.4),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      BorderedText(
                                        strokeWidth: 0,
                                        strokeColor: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        child: Text(
                                          temperature,
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            decoration: TextDecoration.none,
                                            decorationColor: isDarkMode
                                                ? Colors.white
                                                : Colors.white,
                                            fontFamily: 'silkscreen',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                //text
                                height: constraints.maxHeight * 0.3,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            BorderedText(
                                              strokeWidth: 0,
                                              strokeColor: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              child: Text(
                                                location,
                                                style: TextStyle(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  decoration:
                                                      TextDecoration.none,
                                                  decorationColor: isDarkMode
                                                      ? Colors.white
                                                      : Colors.white,
                                                  fontFamily: 'silkscreen',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //gap
                    width: constraints.maxHeight * 0.8,

                    child: AspectRatio(
                      aspectRatio: 0.5,
                      child: weatherIcons[weatherCondition],
                    ),
                  ),
                  Container(
                    //gap
                    width: constraints.maxHeight * 0.5,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
