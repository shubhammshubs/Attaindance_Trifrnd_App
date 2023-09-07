// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../User_Session/display_attaindance.dart';
// import '../services/api_service_display.dart';
// class Attaindencescreen extends StatefulWidget {
//   final String mobileNumber;
//
//   Attaindencescreen({required this.mobileNumber});
//
//   @override
//   State<Attaindencescreen> createState() => _AttaindencescreenState();
// }
//
// class _AttaindencescreenState extends State<Attaindencescreen> {
//   List<display_attaindance> attendanceData = [];
//
//   void _fetchAttendanceData() async {
//     final mobile = widget.mobileNumber; // Use the provided mobile number directly
//     try {
//       final data = await ApiService.fetchAttendanceByMobile(mobile);
//       if (data != null) {
//         setState(() {
//           attendanceData = data;
//         });
//       } else {
//         // Handle the case where the API response is null
//         print('API response is null');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Attendance Records'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: _fetchAttendanceData,
//               child: Text('Fetch Attendance'),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: attendanceData.length,
//                 itemBuilder: (context, index) {
//                   final user = attendanceData.reversed.toList()[index];
//                   return ListTile(
//                     title: Text(user.date),
//                     subtitle: Text('In: ${user.intime}, Out: ${user.outtime ?? 'Not Available'}'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Import the async library for Timer
import '../User_Session/display_attaindance.dart';
import '../services/api_service_display.dart';

class Attaindencescreen extends StatefulWidget {
  final String mobileNumber;

  Attaindencescreen({required this.mobileNumber});

  @override
  State<Attaindencescreen> createState() => _AttaindencescreenState();
}

class _AttaindencescreenState extends State<Attaindencescreen> {
  List<display_attaindance> attendanceData = [];
  late Timer _timer; // Timer for periodic updates

  @override
  void initState() {
    super.initState();
    // Start fetching attendance data when the screen initializes
    _fetchAttendanceData();
    // Set up a timer to fetch data every 1 minutes
    _timer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      _fetchAttendanceData();
    });

  }

  void _fetchAttendanceData() async {
    final mobile = widget.mobileNumber;
    try {
      final data = await ApiService.fetchAttendanceByMobile(mobile);
      if (data != null) {
        setState(() {
          attendanceData = data;
        });
      } else {
        // Handle the case where the API response is null
        print('API response is null');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Records'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: attendanceData.length,
                itemBuilder: (context, index) {
                  final user = attendanceData.reversed.toList()[index];
                  return ListTile(
                    title: Text(user.date),
                    subtitle: Text('In: ${user.intime}, Out: ${user.outtime ?? 'Not Available'}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
