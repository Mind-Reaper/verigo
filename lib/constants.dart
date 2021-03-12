import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui' as ui;

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
String apiKey = "AIzaSyCxT_RfK3d3T0T2Qu7uUrQ9AbyR1dXjE3Q";

InputDecoration fieldDecoration = InputDecoration(
  isDense: true,
  hintText: 'Email Address',
  filled: true,

  fillColor:  Color(0xffe7e7e7),
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
  {'icon': FontAwesomeIcons.motorcycle, 'name': 'Bike'},
  {'icon': FontAwesomeIcons.truck, 'name': 'Tricycle'},
  {'icon': FontAwesomeIcons.shuttleVan, 'name': 'Minivan'},
  {'icon': FontAwesomeIcons.bus, 'name': 'Van/Bus'},
  {'icon': FontAwesomeIcons.trailer, 'name': 'Truck'},
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

List bikePackages = [
  'Document',
  'Small Box'
];

List tricyclePackages = [
  'Small Box',
  'Medium Box'
];

List minivanPackages = [
  'Medium Box',
  'Large Box'
];

List busPackages = [
  'Large Box'
];

List truckPackages = [
  'Covered 5TONS',
  'Open 5TONS',
  'Covered 10TONS',
  'Open 10TONS',
  'Covered 20TONS',
  'Flatbed 20FT',
  'Open 20TONS',
  'Covered 30TONS',
  'Open 30TONS',
  'Tipper 30TONS',
  'BOX 30TONS',
  'Covered 40TONS',
  'Open 40TONS',
  'Flatbed 40FT',
  'Covered 50TONS',
  'Open 50TONS',
  'Covered 60TONS',
  'Open 60TONS',
  'Tanker 33000 LITRES',
  'Tanker 45000 LITRES'
];

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
