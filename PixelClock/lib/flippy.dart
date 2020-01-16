import 'package:flip_panel/flip_panel.dart';
import 'package:flutter/widgets.dart';


class FlipWidget extends StatelessWidget{
 final  String child;
 final  Color bgColor,txtColor;
 final  Duration duration;
  const FlipWidget({ this.child, this.bgColor, this.txtColor ,this.duration});

  @override
  Widget build(BuildContext context) {
    
    return FlipPanel.builder(
      itemBuilder: (context, index) =>
          Container(
            margin: EdgeInsets.symmetric(vertical: 50, horizontal: 0),
            alignment: Alignment.center,
            width: 100.0,
            height: 100.0,
            decoration: 
              BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            child: Text(
              child,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                  color: txtColor,
                  decoration: TextDecoration.none,                  
                  fontFamily: 'Joystix', 
                  ),
            ),
          ),
      itemsCount: child.length,
      period: duration,
      loop: -1,
    );
  }
}
