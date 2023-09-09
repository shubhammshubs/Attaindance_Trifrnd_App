import 'dart:convert';

import 'package:attaindance_user_aug/fragements/attaindance_screen.dart';
import 'package:attaindance_user_aug/fragements/home_screen.dart';
import 'package:attaindance_user_aug/fragements/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'User_Session/User.dart'as UserSession;
import 'User_Session/User.dart';
import 'User_Session/attendance.dart';
import 'User_Session/display_attaindance.dart';
import 'fragements/layoutProfile.dart';

class HomePage extends StatefulWidget {
  final String mobileNumber;
  HomePage({required this.mobileNumber});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  List<User> users = [];
  User? userInfo;
  bool isLoading = false;

  final dateController = TextEditingController();
  String intime = '';
  String result = '';
  String checkOutTime = '';

  List<AttendanceRecord> attendanceRecords = [];
  List<AttendanceRecordouttime> attendanceRecordsOutTime = [];


  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);
  int currentIndex = 1; // to make current index as home_screen

  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendarDays,
    FontAwesomeIcons.check,
    FontAwesomeIcons.user,
  ];




// ------------------------------------- USer Profile API ---------------------------------
  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    http.Response response = await http.get(
      Uri.parse("https://api.trifrnd.com/portal/Attend.php?apicall=readall"),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<User> userList = data.map((item) => UserSession.User(
        id: item['id'],
        fname: item['fname'],
        lname: item['lname'],
        empId: item['EmpId'],
        email: item['email'],
        mobile: item['mobile'],
        departmentName: item['department_name'],
      )).toList();

      setState(() {
        users = userList;
        userInfo = users.firstWhere(
              (user) => user.mobile == widget.mobileNumber,
          orElse: () => UserSession.User(
            id: '',
            fname: '',
            lname: '',
            empId: '',
            email: '',
            mobile: '',
            departmentName: '',
          ),
        );
      });
    } else {
      print("API call failed");
      Fluttertoast.showToast(
        msg: "Server Connection Error!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }
  // ----------------------------------Users Attendance fetchin using API = checkin---------------------------------
  Future<void> markAttendance() async {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // String currentDate = '2023-06-03'; // Change this to the desired date
    // Get the current time and format it as HH:mm:ss
    String currentTime = DateFormat('HH:mm').format(DateTime.now());

    final url = Uri.parse('https://api.trifrnd.com/portal/attend.php?apicall=checkin');
    final response = await http.post(
      url,
      body: {
        'mobile': widget.mobileNumber,
        'date': currentDate,
        'intime': currentTime,
      },
    );

    String attendanceResult = '';

    if (response.statusCode == 200) {
      attendanceResult = '${response.body}';
      print("The result is  ${response.body}");
      Fluttertoast.showToast(msg:" ${response.body}",toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,);
    } else {
      attendanceResult = 'Failed to mark attendance: ${response.body}';
    }

    setState(() {
      result = attendanceResult;
      intime = '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
      intime = currentTime; // Update intime with the current time

      attendanceRecords.add(AttendanceRecord(
        mobile: widget.mobileNumber,
        date: currentDate,
        intime: intime,
        result: result,
      ));
    });
  }
  // ----------------------------------Users Attendance fetchin using API = checkout---------------------------------
  Future<void> markCheckOut() async {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String currentTime = DateFormat('HH:mm').format(DateTime.now());
    // String currentDate = '2023-06-03'; // Change this to the desired date


    final url = Uri.parse('https://api.trifrnd.com/portal/attend.php?apicall=checkout');
    final response = await http.post(
      url,
      body: {
        'mobile': widget.mobileNumber,
        'date': currentDate,
        'outtime': currentTime,
      },
    );

    String attendanceResult = '';

    if (response.statusCode == 200) {
      attendanceResult = '${response.body}';
      print("The check-out result is ${response.body}");
      Fluttertoast.showToast(
        msg: "${response.body}",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      attendanceResult = 'Failed to mark check-out: ${response.body}';
    }

    setState(() {
      result = attendanceResult;
      // Update check-out time with the current time
      checkOutTime = currentTime;

      attendanceRecordsOutTime.add(AttendanceRecordouttime(
        mobile: widget.mobileNumber,
        date: currentDate,
        outtime: currentTime,
        result: result,
      ));
    });
  }




  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    // Check if widget.mobileNumber and widget.userInfo are not null
    if (widget.mobileNumber != null && userInfo != null) {
      return Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: [
            Attaindencescreen(
              mobileNumber: widget.mobileNumber,
            ),

            Homescreen(userInfo: userInfo!,
              markAttendance: markAttendance,
              // Pass the markAttendance function
              markCheckOut: markCheckOut,
              checkInTime: intime, // Pass the check-in time
              checkOutTime: checkOutTime, // Pass the check-out time

            ),
            Profilescreen(userInfo: userInfo),
          ],
        ),
        bottomNavigationBar: Container(
          height: 70,
          margin: const EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 24,
          ),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                )
              ]
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(40)),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(int i = 0; i < navigationIcons.length; i++)...<Expanded>{
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = i;
                        });
                      },
                      child: Container(
                        height: screenHeight,
                        width: screenWidth,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(navigationIcons[i],
                                color: i == currentIndex ? primary : Colors
                                    .black54,
                                size: i == currentIndex ? 30 : 26,
                              ),
                              i == currentIndex ? Container(
                                margin: EdgeInsets.only(top: 6),
                                height: 3,
                                width: 22,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(40)),
                                  color: primary,
                                ),
                              ) : const SizedBox()
                            ],
                          ),

                        ),
                      ),
                    ),
                  ),
                }
              ],
            ),
          ),
        ),
      );
    }else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // or any other loading indicator
        ),
      );
    }
  }
}
