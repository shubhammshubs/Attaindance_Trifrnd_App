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
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async'; // Import the async library for Timer
import '../User_Session/display_attaindance.dart';
import '../services/api_service_display.dart';
import 'package:month_year_picker/month_year_picker.dart';

class Attaindencescreen extends StatefulWidget {
  final String mobileNumber;

  Attaindencescreen({required this.mobileNumber});

  @override
  State<Attaindencescreen> createState() => _AttaindencescreenState();
}

class _AttaindencescreenState extends State<Attaindencescreen> {
  List<display_attaindance> attendanceData = [];
  late Timer _timer; // Timer for periodic updates

  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffeef444c);
  String _month = DateFormat('MMMM').format(DateTime.now());
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


    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Attendance Records'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  "MY Attendance",
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "NexaRegular",
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 32),
                    child: Text(
                      _month,
                      // DateFormat('MMMM').format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth / 18,
                      ),
                    ),
                  ),

                  //  -------------------------------code for Month Picker--------------------------------
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 32),
                    child: GestureDetector(
                      onTap: () async {
                        final month = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2050),
                          builder: (context , child) {
                            return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                       primary: primary,
                                    secondary: primary,
                                    onSecondary: Colors.white,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      primary: primary,
                                    ),
                                  ),
                                  textTheme: const TextTheme(
                                    headline4: TextStyle(
                                      fontFamily: "NexaBold"
                                    ),
                                  )
                                ),

                                child: child!);
                          }
                        );
                        if(month != null) {
                          setState(() {
                            _month = DateFormat('MMMM').format(month);
                          });
                        }
                      },
                      child: Text(
                        "Pick a Month",
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: "NexaRegular",
                          fontSize: screenWidth / 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight / 1.12,
                child: ListView.builder(
                  itemCount: attendanceData.length,
                  itemBuilder: (context, index){
                    if(attendanceData.isEmpty == false){
                      final user = attendanceData.reversed.toList()[index];
                      return DateFormat('MMMM').format(DateTime.parse(user.date)) == _month ? Container(
                        margin:  EdgeInsets.only(top: index > 0 ? 12 : 0 ,left: 6,right: 6),
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(2, 2)
                            ),
                          ],

                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child:  Row (
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(),
                                  decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      DateFormat('EE \n dd').format(DateTime.parse(user.date)),
                                      //   (user.date),
                                      style: TextStyle(
                                        fontFamily: "NexaBold",
                                        fontSize: screenWidth / 18,
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                )),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Check In",
                                    style: TextStyle(
                                        fontFamily: "NexaRegular",
                                        fontSize: screenWidth / 20,
                                        color: Colors.black54
                                    ),),

                                  Text(
                                    '${user.intime}',
                                    style: TextStyle(
                                      fontFamily: "NexaBoald",
                                      fontSize: screenWidth / 18,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Check Out",
                                      style: TextStyle(
                                          fontFamily: "NexaRegular",
                                          fontSize: screenWidth / 20,
                                          color: Colors.black54
                                      ),
                                    ),
                                    Text(
                                      "${user.outtime ?? '--/--'}",
                                      style: TextStyle(
                                        fontFamily: "NexaBoald",
                                        fontSize: screenWidth / 18,
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ) : const SizedBox();
                    }
                    else{
                      return const SizedBox();
                    }

                  }
                ),
              ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: attendanceData.length,
              //     itemBuilder: (context, index) {
              //       final user = attendanceData.reversed.toList()[index];
              //       return ListTile(
              //         title: Text(user.date),
              //         subtitle: Text('In: ${user.intime}, Out: ${user.outtime ?? 'Not Available'}'),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
