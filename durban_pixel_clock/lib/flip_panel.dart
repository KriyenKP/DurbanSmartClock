import 'package:flip_panel/flip_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef Widget DigitBuilder(BuildContext, int);

class FlipWidget extends StatelessWidget {
  final Color bgColor, txtColor;
  const FlipWidget({this.bgColor, this.txtColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 50, horizontal: 0),
      alignment: Alignment.center,
      height: 150.0,
      child: SizedBox(
          height: 150.0,
          child: FlipClock(
              startTime: DateTime.now(),
              separator: Container(
                width: 10,
                height: 75,
                alignment: Alignment.center,
                child: Text(
                  ':',
                  style: TextStyle(
                    fontSize: 50,
                    color: txtColor,
                  ),
                ),
              ),
              digitBuilder: (context, digit) => Container(
                    alignment: Alignment.center,
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Text(
                      '$digit',
                      style: TextStyle(
                        fontSize: 50,
                        color: txtColor,
                        fontFamily: 'silkscreen',
                      ),
                    ),
                  ))),
    );
  }
}

// FlipClock.simple(
//   startTime: DateTime.now(),
//   digitColor: txtColor,
//   backgroundColor: bgColor,
//   digitSize: 50.0,
//   borderRadius: const BorderRadius.all(Radius.circular(250)),
//   height: 85,
// ),

//     return FlipPanel.builder(
//       itemBuilder: (context, index) =>
//           Container(
//             margin: EdgeInsets.symmetric(vertical: 50, horizontal: 0),
//             alignment: Alignment.center,
//             width: 100.0,
//             height: 100.0,
//             decoration:
//               BoxDecoration(
//                 color: bgColor,
//                 borderRadius: BorderRadius.all(Radius.circular(8.0)),
//               ),
//             child: Text(
//               child,
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 50.0,
//                   color: txtColor,
//                   decoration: TextDecoration.none,
//                   fontFamily: 'Joystix',
//                   ),
//             ),
//           ),
//       itemsCount: child.length,
//       period: duration,
//       loop: -1,
//     );
//   }
// }
