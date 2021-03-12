// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
//
// class AddressScreenSearch extends StatefulWidget {
//   @override
//   _AddressScreenSearchState createState() => _AddressScreenSearchState();
// }
//
// class _AddressScreenSearchState extends State<AddressScreenSearch> {
//
//   List searchResults = [];
//
//
//   search() async {
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xfff6f6f6),
//       appBar: AppBar(
//        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: CupertinoSearchTextField(),
//         centerTitle: false,
// leadingWidth: 25,
//       ),
//       body: Column(
//         children: [
//           Divider(
//
//           ),
//           Expanded(child: ListView.builder(
//           itemCount: searchResults.length,
//             itemBuilder: (context, index) {
//             return Text(searchResults[index]);
//             },
//           ))
//         ],
//       ),
//     );
//   }
// }
