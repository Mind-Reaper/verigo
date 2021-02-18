import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

List<String> states = [
  "Abia",
  "Adamawa",
  "Akwa Ibom",
  "Anambra",
  "Bauchi",
  "Bayelsa",
  "Benue",
  "Borno",
  "Cross River",
  "Delta",
  "Ebonyi",
  "Edo",
  "Ekiti",
  "Enugu",
  "FCT - Abuja",
  "Gombe",
  "Imo",
  "Jigawa",
  "Kaduna",
  "Kano",
  "Katsina",
  "Kebbi",
  "Kogi",
  "Kwara",
  "Lagos",
  "Nasarawa",
  "Niger",
  "Ogun",
  "Ondo",
  "Osun",
  "Oyo",
  "Plateau",
  "Rivers",
  "Sokoto",
  "Taraba",
  "Yobe",
  "Zamfara"
];

List carrier = [
  {'icon': FontAwesomeIcons.motorcycle, 'name': 'Motorcycle'},
  {'icon': FontAwesomeIcons.car, 'name': 'Car'},
  {'icon': FontAwesomeIcons.truck, 'name': 'Van'},
];

List boxSize = ['Small Box', 'Medium Box', 'Large Box'];

List boxNumber = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20
];

List orders = [
  {
    'log_name': 'Happi Logistics',
    's_name': 'Moyin Samson',
    'r_name': 'Daniel Ojo',
    's_no': '+234347294732',
    'r_no': '+234582724953',
    'carrier': 'van',
    'order_date': '21 Jan 2021',
    'pickup_date': '22 Jan 2021',
    'delivery_date': '24 Jan 2021',
    'id': '48382843',
    'price': '1500',
    'tracking_id': '437472728484822',
    'pending': true,
    'completed': false,
    'transit': false,
  },
  {
    'log_name': 'Happi Logistics',
    's_name': 'Moyin Samson',
    'r_name': 'Daniel Ojo',
    's_no': '+234347294732',
    'r_no': '+234582724953',
    'carrier': 'van',
    'order_date': '21 Jan 2021',
    'pickup_date': '22 Jan 2021',
    'delivery_date': '24 Jan 2021',
    'id': '48382843',
    'price': '1500',
    'tracking_id': '437472728484822',
    'pending': false,
    'completed': true,
    'transit': false,
  },
  {
    'log_name': 'Happi Logistics',
    's_name': 'Moyin Samson',
    'r_name': 'Daniel Ojo',
    's_no': '+234347294732',
    'r_no': '+234582724953',
    'carrier': 'van',
    'order_date': '21 Jan 2021',
    'pickup_date': '22 Jan 2021',
    'delivery_date': '24 Jan 2021',
    'id': '48382843',
    'price': '1500',
    'tracking_id': '437472728484822',
    'pending': true,
    'completed': false,
    'transit': false,
  },
  {
    'log_name': 'Happi Logistics',
    's_name': 'Moyin Samson',
    'r_name': 'Daniel Ojo',
    's_no': '+234347294732',
    'r_no': '+234582724953',
    'carrier': 'van',
    'order_date': '21 Jan 2021',
    'pickup_date': '22 Jan 2021',
    'delivery_date': '24 Jan 2021',
    'id': '48382843',
    'price': '1500',
    'tracking_id': '437472728484822',
    'pending': false,
    'completed': false,
    'transit': true,
  },
  {
    'log_name': 'Happi Logistics',
    's_name': 'Moyin Samson',
    'r_name': 'Daniel Ojo',
    's_no': '+234347294732',
    'r_no': '+234582724953',
    'carrier': 'van',
    'order_date': '21 Jan 2021',
    'pickup_date': '22 Jan 2021',
    'delivery_date': '24 Jan 2021',
    'id': '48382843',
    'price': '1500',
    'tracking_id': '437472728484822',
    'pending': false,
    'completed': true,
    'transit': false,
  },
  {
    'log_name': 'Happi Logistics',
    's_name': 'Moyin Samson',
    'r_name': 'Daniel Ojo',
    's_no': '+234347294732',
    'r_no': '+234582724953',
    'carrier': 'van',
    'order_date': '21 Jan 2021',
    'pickup_date': '22 Jan 2021',
    'delivery_date': '24 Jan 2021',
    'id': '48382843',
    'price': '1500',
    'tracking_id': '437472728484822',
    'pending': false,
    'completed': true,
    'transit': false,
  },
  {
    'log_name': 'Happi Logistics',
    's_name': 'Moyin Samson',
    'r_name': 'Daniel Ojo',
    's_no': '+234347294732',
    'r_no': '+234582724953',
    'carrier': 'van',
    'order_date': '21 Jan 2021',
    'pickup_date': '22 Jan 2021',
    'delivery_date': '24 Jan 2021',
    'id': '48382843',
    'price': '1500',
    'tracking_id': '437472728484822',
    'pending': true,
    'completed': false,
    'transit': false,
  },
  {
    'log_name': 'Happi Logistics',
    's_name': 'Moyin Samson',
    'r_name': 'Daniel Ojo',
    's_no': '+234347294732',
    'r_no': '+234582724953',
    'carrier': 'van',
    'order_date': '21 Jan 2021',
    'pickup_date': '22 Jan 2021',
    'delivery_date': '24 Jan 2021',
    'id': '48382843',
    'price': '1500',
    'tracking_id': '437472728484822',
    'pending': false,
    'completed': false,
    'transit': true,
  }

];
