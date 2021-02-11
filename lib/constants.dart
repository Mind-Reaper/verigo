import 'package:flutter/material.dart';

// textTheme(context, TextTheme theme) {
//   return Theme.of(context).textTheme.theme;
// }

namedLogo() {
  return AnimatedContainer(
    duration: Duration(seconds: 1),
    height: 77.81,
    width: 171,
    decoration: BoxDecoration(
        image: DecorationImage(
      image: AssetImage('assets/images/verigo_name.png'),
      fit: BoxFit.fill,
    )),
  );
}

InputDecoration fieldDecoration = InputDecoration(
  isDense: true,
  hintText: 'Email Address',
  filled: true,
  fillColor: Color(0xffe7e7e7),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide.none,
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: Colors.red),
  ),
);

pushPage(BuildContext context, page) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}
