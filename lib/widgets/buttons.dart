import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: active ? onPressed : null,
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        height: 50,
        width: double.infinity,
        child: Center(
          child: title != null
              ? Text(title,
                  style: Theme.of(context).textTheme.button.copyWith(
                      color: inverse
                          ? Theme.of(context).primaryColor
                          : Colors.white))
              : child,
        ),
        decoration: BoxDecoration(
          color: active
              ? inverse
                  ? Colors.white
                  : Theme.of(context).primaryColor
              : Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
