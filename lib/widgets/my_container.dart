import 'package:flutter/material.dart';

class FloatingContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final Color color;
  final bool border;
  final bool padding;

  const FloatingContainer(
      {Key key,
      this.height,
      this.width,
      this.color: Colors.white,
        this.padding: true,
      this.child,
      this.border: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: border
            ? Border.all(width: 2, color: Theme.of(context).primaryColor)
            : null,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 20,
              spreadRadius: -5,
              offset: Offset(0.0, 2.0)),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: color,
        child: Padding(
          padding: padding?  const EdgeInsets.all(16.0) : EdgeInsets.zero ,
          child: child,
        ),
      ),
    );
  }
}
