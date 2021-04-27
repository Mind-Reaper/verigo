import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatefulWidget {
  final bool active;
  final String title;
  final Function onPressed;
  final Widget child;
  final bool inverse;
  

  const RoundedButton(
      {Key key,
      this.active: false,
      this.title,
      this.onPressed,
      this.child,
      this.inverse: false})
      : super(key: key);

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {

  DateTime loginClickTime;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      if(loginClickTime == null ) {
        if (widget.active) {
          loginClickTime = DateTime.now();
          widget.onPressed();
        }
      } else if(DateTime.now().difference(loginClickTime).inSeconds > 3) {
        if (widget.active) {
          loginClickTime = DateTime.now();
          widget.onPressed();
        }
      }

      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.elasticInOut,
        height: 50,
        width: double.infinity,
        child: Center(
          child: widget.title != null
              ? Text(widget.title,
                  style: Theme.of(context).textTheme.button.copyWith(
                   fontSize: 20,
                      color: widget.inverse
                          ? Theme.of(context).primaryColor
                          : Colors.white))
              : widget.child,
        ),
        decoration: BoxDecoration(
          color: widget.active
              ? widget.inverse
                  ? Colors.white
                  : Theme.of(context).primaryColor
              : Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

class DottedButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  const DottedButton({Key key, this.title, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DottedBorder(
        dashPattern: [3, 5],
        borderType: BorderType.RRect,
        color: Theme.of(context).primaryColor,
        radius: const Radius.circular(15),
        child: Container(
          height: 50,

          child: Center(
            child: Text(title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                )),
          ),
        ),
      ),
    );


  }
}
