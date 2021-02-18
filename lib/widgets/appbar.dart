import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget appBar(BuildContext context,
    {bool showbackArrow: true,
    List<Widget> actions,
      Brightness brightness,
      Widget bottom,
    String title,
    Color backgroundColor: Colors.white,
    bool centerTitle: true,
    bool blackTitle: false,
    double elevation: 0}) {
  return AppBar(

    elevation: elevation,
    brightness: brightness,
    backgroundColor: backgroundColor,
    automaticallyImplyLeading: showbackArrow,
    actions: actions,
    title: title != null
        ? Text(
            title,
            style: Theme.of(context).textTheme.headline2.copyWith(
                  fontWeight: centerTitle ? FontWeight.w500 : FontWeight.w700,
                  fontSize: centerTitle ? 20 : 25,
                  color: blackTitle
                      ? Color(0xff414141)
                      : Theme.of(context).primaryColor,
                ),
          )
        : Image(
            height: 50,
            image: AssetImage('assets/images/verigo_purple.png'),

          ),
    centerTitle: centerTitle,
    titleSpacing: !showbackArrow ? 16 : -15,
    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
    actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
    bottom: bottom,
  );
}
