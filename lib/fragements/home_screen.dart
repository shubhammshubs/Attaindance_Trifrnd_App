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
  DateTime? checkInDateTime; // Store Check In time as DateTime
  DateTime? checkOutDateTime; // Store Check Out time as DateTime
  Timer? dataRefreshTimer;


  // Load the button state from SharedPreferences
  Future<void> loadButtonState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isCheckingIn = prefs.getBool('isCheckingIn') ?? true;
    });
  }

  // Save the button state to SharedPreferences
  Future<void> saveButtonState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCheckingIn', isCheckingIn);
  }

  // Load the slider button interaction timestamp from SharedPreferences
  Future<void> loadSliderButtonTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString('sliderButtonTimestamp');
    if (timestamp != null) {
      final lastInteraction = DateTime.parse(timestamp);
      final currentTime = DateTime.now();
      final resetDuration = const Duration(hours: 24); // Change this to your desired reset period

      if (currentTime.difference(lastInteraction) >= resetDuration) {
        // Reset the button state if needed
        setState(() {
          isCheckingIn = true; // Reset to Check In
        });
      }
    }
  }

  // Save the slider button interaction timestamp to SharedPreferences
  Future<void> saveSliderButtonTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sliderButtonTimestamp', DateTime.now().toIso8601String());
  }

  @override
  void initState() {
    super.initState();
    _fetchAttendanceDataForHomePage();
    loadButtonState();
    loadSliderButtonTimestamp(); // Load the slider button timestamp when the widget initializes
    dataRefreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fetchAttendanceDataForHomePage();
    });
  }

  @override
  void dispose() {
    dataRefreshTimer?.cancel();
    slideTimer?.cancel();
    saveButtonState();
    saveSliderButtonTimestamp(); // Save the slider button timestamp when the widget is disposed
    super.dispose();
  }


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

          // Now, assuming the data is sorted by date/time in descending order,
          // you can get the latest entry for today.
          if (attendanceData.isNotEmpty) {
            final latestRecord = attendanceData[0];
            String intime = latestRecord.intime;
            String outtime = latestRecord.outtime ?? "";

            // Parse the date-time strings without the 'T' character
            checkInDateTime = DateTime.parse(currentDate + ' ' + intime);
            if (outtime.isNotEmpty) {
              checkOutDateTime = DateTime.parse(currentDate + ' ' + outtime);
            } else {
              checkOutDateTime = null;
            }
            // Update the button state based on checkOutDateTime
            setState(() {
              isCheckingIn = checkOutDateTime == null;
            });

            // Save the button state when the data is fetched
            saveButtonState();
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

                          Text(
                            _formatDateTime(checkInDateTime), // Format and display Check In time

                            // (widget.checkInTime ?? "--/--"),
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
                            _formatDateTime(checkOutDateTime), // Format and display Check Out time

                            // widget.checkOutTime ?? "--/--",
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
                      onSubmit: () async {
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
                            // Save the button state when the user interacts with the button
                            saveSliderButtonTimestamp();
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



