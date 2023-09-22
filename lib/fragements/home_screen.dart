
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../User_Session/User.dart';
import '../User_Session/display_attaindance.dart';
import '../services/api_service_display.dart';


class Homescreen extends StatefulWidget {
  final Color outerColor; // Define the outerColor property
  final User userInfo;
  final VoidCallback markAttendance;
  final VoidCallback markCheckOut;
  final String checkInTime; // Add check-in time parameter
  final String checkOutTime; // Add check-out time parameter
  final String mobileNumber;


  const Homescreen({
    Key? key,
    this.outerColor = Colors.transparent,
    required this.userInfo,
    required this.markAttendance, // Pass the markAttendance function
    required this.checkInTime,  // Add check-in time parameter
    required this.checkOutTime,
    required this.markCheckOut, // Add check-out time parameter
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
  bool isCheckingOut = true; // Initially set to Check In
  Timer? dataRefreshTimer;
  Timer? slideTimer;
  String checkInTime = "--/--"; // Initialize with default values
  String checkOutTime = "--/--"; // Initialize with default values
  List<display_attaindance> attendanceData = [];
  DateTime? checkInDateTime; // Store Check In time as DateTime
  DateTime? checkOutDateTime; // Store Check Out time as DateTime

  // // code for both button and display features function
  void _fetchAttendanceDataForHomePage() async {
    final mobile = widget.mobileNumber;
    try {
      final data = await ApiService.fetchAttendanceByMobile(mobile);
      if (data != null && data.isNotEmpty) {
        setState(() {
          attendanceData = data;
          // Filter the attendanceData list to include only records for the current date
          String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          attendanceData = attendanceData.where((record) => record.date == currentDate).toList();


          // Check if there is a check-in time available for the current date
          final hasCheckIn = attendanceData.any((record) => record.intime.isNotEmpty);

          if (hasCheckIn) {

            final latestRecord = attendanceData[0];
            String intime = latestRecord.intime;
            String outtime = latestRecord.outtime ?? "";
            // If check-in time is available, show Slide to Check Out or Tick based on check-out time
            checkInDateTime = DateTime.parse(currentDate + ' ' + intime);

            if (outtime.isNotEmpty) {
              checkOutDateTime = DateTime.parse(currentDate + ' ' + outtime);

              // Check-out time is available, show Tick
              isShowingTick = true;

            } else {
              // Check-out time is not available, show Slide to Check Out
              isCheckingIn = false;
            }
          } else {
            // Check-in time is not available, show Slide to Check In
            isCheckingIn = true;
          }
        });
      } else {
        print('API response is null');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }




  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('hh:mm').format(dateTime);
    } else {
      return "--/--";
    }
  }



  @override
  void dispose() {
    dataRefreshTimer?.cancel();
    slideTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchAttendanceDataForHomePage();
    // _loadButtonState(); // Initialize the button state
    dataRefreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fetchAttendanceDataForHomePage();
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
                          _formatDateTime(checkInDateTime), // Format and display Check In time
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
                            _formatDateTime(checkOutDateTime), // Format and display Check Out time
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
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                      text: DateTime.now().day.toString(),
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
              margin: const EdgeInsets.only(top: 100),
              child: Builder(builder: (context) {
                final GlobalKey<SlideActionState> key1 = GlobalKey();
                return Container(
                  color: widget.outerColor ?? Colors.green,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 15),
                    child: isShowingTick
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
                          if (isCheckingIn) {
                            // If checking in, call markAttendance for Check In
                            widget.markAttendance();
                          } else {
                            // If checking out, call the checkOut function (you need to implement this)
                            widget.markCheckOut();
                          }

                          // Show the tick mark if check-out time is available
                          setState(() {
                            isShowingTick = !isCheckingIn && attendanceData.isNotEmpty && attendanceData[0].outtime?.isNotEmpty == true;
                            isCheckingIn = !isCheckingIn; // Toggle the button state
                          });
                        },

                      // onSubmit: () {
                      //   if (isCheckingIn) {
                      //     // If checking in, call markAttendance for Check In
                      //     widget.markAttendance();
                      //   } else {
                      //     // If checking out, call the checkOut function (you need to implement this)
                      //     widget.markCheckOut();
                      //   }
                      //
                      //   // Show the tick mark
                      //   setState(() {
                      //     isShowingTick = true;
                      //   });
                      //
                      //   // wait for 5 sec or untilNextDay to check out
                      //   slideTimer = Timer(
                      //     isCheckingIn ? Duration(seconds: 5) : waitTimeUntileNextDay(),
                      //         () {
                      //       setState(() {
                      //         isShowingTick = false;
                      //         isCheckingIn = !isCheckingIn;
                      //       });
                      //
                      //     },
                      //   );
                      // },
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
