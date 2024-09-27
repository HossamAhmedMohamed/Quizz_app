// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class SensorDataScreen extends StatefulWidget {
//   @override
//   _SensorDataScreenState createState() => _SensorDataScreenState();
// }

// class _SensorDataScreenState extends State<SensorDataScreen> {
//   final DatabaseReference _databaseReference =
//       FirebaseDatabase.instance.reference().child('sensor_data');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Real-time Sensor Data'),
//       ),
//       body: StreamBuilder(
//         stream: _databaseReference.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.hasData && !snapshot.hasError && snapshot.data!.snapshot.value != null) {
//             // جلب البيانات من الـ snapshot
//             Map<dynamic, dynamic> data = snapshot.data!.snapshot.value;
//             return ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 String key = data.keys.elementAt(index);
//                 return ListTile(
//                   title: Text('Sensor $key: ${data[key]}'),
//                 );
//               },
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
