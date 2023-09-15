import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';
import 'main.dart';


// String finalmobile = ' '  ;

class SplashScreen extends StatefulWidget {
  // final String mobileNumber; // Declare mobileNumber as a property
  //
  // SplashScreen({required this.mobileNumber});





  @override
  State<SplashScreen> createState() => SplashScreenState();


}

class SplashScreenState extends State<SplashScreen> {

  // static const String KEYLOGIN = "Mobile_Login";
  // double screenHeight = 0;
  // double screenWidth = 0;


  @override
  void initState() {
    super.initState();
    checkUserLogin();
  }

  Future<void> checkUserLogin() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? mobileNumber = sharedPreferences.getString('mobile');
    // finalmobile = mobileNumber!;
    // Check if the user is logged in
    if (mobileNumber != null) {
      print("User is already logged in with mobile number: $mobileNumber");
      navigateToHomePage(mobileNumber);
    } else {
      print("User is not logged in. Redirecting to LoginPage.");
      navigateToLoginPage();
    }
  }

  void navigateToHomePage(String mobileNumber) {
    Timer(
      Duration(seconds: 2),
          () => Get.to(() => HomePage(mobileNumber: mobileNumber))
              // Get.to(HomePage(mobileNumber: mobileNumber)),
    );
  }

  void navigateToLoginPage() {
    Timer(
      Duration(seconds: 2),
            () => Get.to(() => LoginPage())
              // Get.to(LoginPage()),
    );
  }
    // whereToGo();
  //
  //   // You can access widget.mobileNumber to get the passed mobile number
  //   print("Mobile Number from LoginPage: ${widget.mobileNumber}");
  //
  //   getValidationData().whenComplete(() async {
  //     Timer(Duration(seconds: 2), () =>
  //         Get.to(finalmobile == null ? LoginPage() : HomePage(
  //             mobileNumber: widget.mobileNumber)));
  //
  //     // Timer(Duration(seconds: 2), () {
  //     //   Navigator.pushReplacement(context,
  //     //       MaterialPageRoute(builder: (context) => LoginPage()));
  //     // });
  //
  //   });
  // }
  //
  // Future getValidationData() async {
  //   final SharedPreferences sharedPreferences = await SharedPreferences
  //       .getInstance();
  //   var obtainedMobile = sharedPreferences.getString('mobile');
  //   setState(() {
  //     finalmobile = obtainedMobile;
  //   });
  //   print(finalmobile);
  // }


  @override
  Widget build(BuildContext context) {

    // screenHeight = MediaQuery.of(context).size.height;
    // screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        // Use Image.asset as the background
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/2.jpg'), // Replace with your image asset
            fit: BoxFit.cover,
          ),
        ),
            ),
    );
    //         child: Image.asset(
    //           'assets/images/cover1.jpg',
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}