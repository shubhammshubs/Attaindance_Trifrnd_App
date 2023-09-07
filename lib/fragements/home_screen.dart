// import 'package:attaindance_user_aug/User_Session/User.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../User_Session/User.dart';


class Homescreen extends StatefulWidget {
  final Color outerColor; // Define the outerColor property
  final User userInfo;
  final VoidCallback markAttendance;
  final VoidCallback markCheckOut;
  final String checkInTime; // Add check-in time parameter
  final String checkOutTime; // Add check-out time parameter


  const Homescreen({
    Key? key,
    this.outerColor = Colors.transparent,
    required this.userInfo,
    required this.markAttendance, // Pass the markAttendance function
    required this.checkInTime,  // Add check-in time parameter
    required this.checkOutTime,
    required this.markCheckOut, // Add check-out time parameter

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


  @override
  void dispose() {
    // Dispose of animation controllers or listeners here
    // Add any additional cleanup logic you need
    slideTimer?.cancel();
    super.dispose();
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

                          Text(widget.checkInTime,
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
                            widget.checkOutTime,
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
                        // slideTimer = Timer(
                        //   isCheckingIn ? Duration(seconds: 5) :
                        //       waitTimeUntileNextDay(),
                        //      () {
                        //     setState(() {
                        //       isShowingTick = false;
                        //       isCheckingIn = !isCheckingIn;
                        //     });
                        //     // Reset the SlideAction
                        //     key.currentState!.reset();
                        //      },
                        // );
                        // Wait for 1 second and then reset
                        Future.delayed(const Duration(seconds: 5), () {
                          setState(() {
                            isShowingTick = false;
                            // Toggle the state to switch between Check In and Check Out
                            isCheckingIn = !isCheckingIn;
                          });

                          // key.currentState!.reset();
                        });
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


