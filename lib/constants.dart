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

copy(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text)).then((_){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Copied to clipboard', textAlign: TextAlign.center,),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.black87,
elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
margin: EdgeInsets.symmetric(vertical: 70, horizontal: 50),

      behavior: SnackBarBehavior.floating,

    ));
  });
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
{'icon': FontAwesomeIcons.bicycle, 'name': 'Bicycle', 'index': 1},
  {'icon': FontAwesomeIcons.motorcycle, 'name': 'Bike', 'index': 2},
  {'icon': FontAwesomeIcons.truck, 'name': 'Tricycle', 'index': 3},

  {'icon': FontAwesomeIcons.bus, 'name': 'Van/Bus','index': 4},
  {'icon': FontAwesomeIcons.trailer, 'name': 'Truck', 'index': 5},
];

List boxSize = ['Small Box', 'Medium Box', 'Large Box'];

List boxNumber = [

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

List bicyclePackages = [
  {'name': 'Document','size': 1},
  {'name': 'Small Box','size': 2},


];

List bikePackages = [
  {'name': 'Document','size': 1},
  {'name': 'Small Box','size': 2},
  {'name': 'Medium Box','size': 3},
];

List tricyclePackages = [
  {'name': 'Small Box','size': 2},
  {'name': 'Medium Box','size': 3},
  {'name': 'Large Box','size': 4},
];

List busPackages = [
  {'name': 'Medium Box','size': 3},
  {'name': 'Large Box','size': 4},
];

List truckPackages = [
  {'name': 'Covered 5TONS','size': 5},
  {'name': 'Open 5TONS','size': 6},
  {'name': 'Covered 10TONS','size': 7},
  {'name': 'Open 10TONS','size': 8},
  {'name': 'Covered 20TONS','size': 9},
  {'name': 'Flatbed 20FT','size': 10},
  {'name': 'Open 20TONS','size': 11},
  {'name': 'Covered 30TONS','size': 12},
  {'name': 'Open 30TONS','size': 13},
  {'name': 'Tipper 30TONS','size': 14},
  {'name': 'BOX 30TONS','size': 15},
  {'name': 'Covered 40TONS','size': 16},
  {'name': 'Open 40TONS','size': 17},
  {'name': 'Flatbed 40FT','size': 18},
  {'name': 'Covered 50TONS','size': 19},
  {'name': 'Open 50TONS','size': 20},
  {'name': 'Covered 60TONS','size': 21},
  {'name': 'Open 60TONS','size': 22},
  {'name': 'Tanker 33000 LITRES','size': 23},
  {'name': 'Tanker 45000 LITRES','size': 24},
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
