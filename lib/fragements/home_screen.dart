import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../User_Session/User.dart';
import '../User_Session/display_attaindance.dart';
import '../services/api_service_display.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Homescreen extends StatefulWidget {
  final Color outerColor; // Defining the outerColor property
  final User userInfo;
  final VoidCallback markAttendance;
  final VoidCallback markCheckOut;
  final String checkInTime; // check-in time parameter
  final String checkOutTime; // check-out time parameter
  final String mobileNumber;


  // Attaindencescreen({required this.mobileNumber});



  const Homescreen({
    Key? key,
    this.outerColor = Colors.transparent,
    required this.userInfo,
    required this.markAttendance, // Pass the markAttendance function
    required this.checkInTime,  // check-in time parameter
    required this.checkOutTime, // Check0out time parameter
    required this.markCheckOut,
    required this.mobileNumber, //  check-out time parameter

  }) : super(key: key);


  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffeef444c);
  bool isCheckingIn = true; // Initially set to Check In
  bool isShowingTick = false;
  Timer? slideTimer;
  String checkInTime = "--/--"; // Initialize with default values
  String checkOutTime = "--/--"; // Initialize with default values
  List<display_attaindance> attendanceData = [];



  @override
  void dispose() {
    slideTimer?.cancel();
    super.dispose();
  }

  void _fetchAttendanceDataForHomePage() async {
    final mobile = widget.mobileNumber;
    try {

      final data = await ApiService.fetchAttendanceByMobile(mobile);
      if (data != null) {
        setState(() {
          attendanceData = data;
          // Filter the attendanceData list to include only records for the current date
          DateTime currentDate = DateTime.now();
          attendanceData = attendanceData.where((record) {
            DateTime recordDate = DateTime.parse(record.date);
            return recordDate.year == currentDate.year &&
                recordDate.month == currentDate.month &&
                recordDate.day == currentDate.day;
          }).toList();
        });
      } else {
        // Handle the case where the API response is null
        print('API response is null');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> saveCheckInStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isCheckedIn', true);
    prefs.setInt('checkInTimestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> saveCheckOutStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isCheckedIn', false);
    prefs.setInt('checkOutTimestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> retrieveCheckInOutStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isCheckedIn = prefs.getBool('isCheckedIn') ?? false;
    final int checkInTimestamp = prefs.getInt('checkInTimestamp') ?? 0;
    final int checkOutTimestamp = prefs.getInt('checkOutTimestamp') ?? 0;

    setState(() {
      // Update your UI based on the retrieved values
      isCheckingIn = isCheckedIn;
      // You can also calculate if the check-in/out is still valid based on timestamps.
      // For example, you can compare the timestamps to the current time and decide if it's within 24 hours.
    });
  }


  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //  -------------------------------code for Hey user msg--------------------------------

            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Hey,",
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "NexaRegular",
                  fontSize: screenWidth / 20,
                ),
              ),
            ),
            Container(
              //  -------------------------------code for display user Name--------------------------------

            alignment: Alignment.centerLeft,
              child:  RichText(
                text: TextSpan(
                    text: "${widget.userInfo.fname}",
                    style: TextStyle(
                      color: primary,
                      fontSize: screenWidth / 16,
                    ),
                ),
              ),
            ),
            Container(
              //  -------------------------------code for Todays Status--------------------------------

            alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Today's Status:",
                style: TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              //  -------------------------------code for box Shape conatainer--------------------------------

            margin: const EdgeInsets.only(top: 12,bottom: 32),
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
              child: Row (
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //  -------------------------------code for CHeckIn Time--------------------------------

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

                          Text((widget.checkInTime ?? "--/--"),
                            style: TextStyle(
                                fontFamily: "NexaBoald",
                                fontSize: screenWidth / 18,
                                ),
                          )
                        ],
                      ),
                  ),
                  Expanded(
                    //  -------------------------------code for CHeckOut Time--------------------------------

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
                            widget.checkOutTime ?? "--/--",
                            style: TextStyle(
                              fontFamily: "NexaBoald",
                              fontSize: screenWidth / 18,
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Container(
              //  -------------------------------code for Display Date and Time--------------------------------

            alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                    text: DateTime.now().day.toString(),
                    // DateFormat('d').format(DateTime.now()), // Format and display day
                  style: TextStyle(
                    color: primary,
                    fontSize: screenWidth / 16,

                  ),
                  children: [
                    TextSpan(
                        text: DateFormat(' MMM yyyy').format(DateTime.now()), // Format and display month and year
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth / 18,
                        fontFamily: "NexaBold",
                      )
                    )
                  ]
                ),
              )
            ),
            StreamBuilder(
              // Making clock run constantly .
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                     DateFormat('hh:mm:ss a').format(DateTime.now()), // Format and display month and year
                    style: TextStyle(
                      fontFamily: "NexaBold",
                      fontSize: screenWidth / 20,
                      color: Colors.black54,

                    ),
                  ),
                );
              }
            ),
            Container(
              //  -------------------------------code for Slider Button--------------------------------

            margin: const EdgeInsets.only(top: 100),
              child: Builder(builder: (context) {
                final GlobalKey<SlideActionState> key1 = GlobalKey();
                return Container(
                  color: widget.outerColor ?? Colors.green,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 15), // Adjust duration as needed
                    child:
                    isShowingTick
                        ? Icon(
                      Icons.check,
                      color: Colors.red,

                      size: screenWidth / 10,
                    )
                        : SlideAction(
                      text: isCheckingIn ? "Slide to Check In" : "Slide to Check Out",
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: screenWidth / 20,
                        fontFamily: "NexaRegular",
                      ),
                      outerColor: Colors.white,
                      innerColor: primary,
                      key: key1,
                      onSubmit: () {
                        // handleSlideActionPress; // Call the function to handle SlideAction press

                        if (isCheckingIn) {
                          // If checking in, call markAttendance for Check In
                          widget.markAttendance();
                        } else {
                          // If checking out, call the checkOut function (you need to implement this)
                          widget.markCheckOut();
                        }

                        // Show the tick mark
                        setState(() {
                          isShowingTick = true;
                        });

                        // wait for 5 sec or untillNextDay to check out
                        slideTimer = Timer(
                          isCheckingIn ? Duration(seconds: 5) :
                              waitTimeUntileNextDay(),
                             () {
                            setState(() {
                              isShowingTick = false;
                              isCheckingIn = !isCheckingIn;
                            });
                            // Reset the SlideAction
                            key1.currentState!.reset();
                             },
                        );
                        // // Wait for 1 second and then reset
                        // Future.delayed(const Duration(seconds: 5), () {
                        //   setState(() {
                        //     isShowingTick = false;
                        //     // Toggle the state to switch between Check In and Check Out
                        //     isCheckingIn = !isCheckingIn;
                        //   });
                        //
                        //   // key.currentState!.reset();
                        // });
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Duration waitTimeUntileNextDay() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow.difference(now);
  }
  }



