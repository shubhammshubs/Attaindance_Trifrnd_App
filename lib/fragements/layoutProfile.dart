// import 'package:attaindance_user_aug/User_Session/User.dart';
// import 'package:attaindance_user_aug/main.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:slide_to_act/slide_to_act.dart';
//
//
// class layout extends StatefulWidget {
//   final User? userInfo; // Add this line
//
//   const layout({Key? key, this.userInfo}) : super(key: key); // Update the constructor
//
//   @override
//   State<layout> createState() => _layout();
// }
//
// class _layout extends State<layout> {
//   String dropdownValue = 'User Info'; // Initial dropdown value
//   double screenHeight = 0;
//   double screenWidth = 0;
//   Color primary = const Color(0xffeef444c);
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body:  Stack(
//         children: [
//           // -------------------------This is code for cover page -----------------------------------------
//           Container(
//             height: 250, // Fixed height for the cover page
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 20,
//                   offset: Offset(2, 2),
//                 )
//               ],
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//
//             ),
//             child: Image.asset(
//               'assets/images/cover1.jpg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           // -------------------------This is code for Profile Photo circle--------------------------------
//           Container(
//             margin: const EdgeInsets.only(top: 132,right: 1,left: 260),
//
//             child: const CircleAvatar(
//               backgroundImage: AssetImage('assets/images/CoverPage.jpg'),
//               backgroundColor: Colors.greenAccent,
//               radius: 60,
//
//             ),
//           ),
//
//
//
//
//       SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//
//               // -----------------------Code for COver Page End --------------------------
//               // Code for Profile Page
//               // Container(
//               //   margin: const EdgeInsets.only(top: 132,right: 1,left: 220),
//               //
//               //   child: CircleAvatar(
//               //     backgroundImage: AssetImage('assets/images/CoverPage.jpg'),
//               //     backgroundColor: Colors.greenAccent,
//               //     radius: 60,
//               //
//               //   ),
//               // ),
//               SizedBox(height: 1,),
//
//               // -------------------------Main Box Of Nested BoxDEcoration--------------------------------
//
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(top: 240),
//                     width: 460,
//                     decoration: BoxDecoration(
//                       color: Colors.white, // Main BoxDecoration
//                       borderRadius: BorderRadius.circular(30),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.5),
//                           blurRadius: 5,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min, // Set the mainAxisSize to min
//                       children:[
//                         // ------------------------- Nested child Box 1--------------------------------
//
//                         Container(
//                           margin: const EdgeInsets.only(top: 20),
//                           height: 200,
//                           width: 360,
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Colors.black26,
//                                   blurRadius: 10,
//                                   offset: Offset(2, 2)
//                               ),
//                             ],
//                             borderRadius: BorderRadius.all(Radius.circular(20)),
//                           ),
//                           child: Row (
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         SizedBox(width: 1), // Add some spacing between the icon and text
//                                         Icon(
//                                           Icons.person, // You can use any desired icon from the Icons class
//                                           color: primary,
//                                           size: screenWidth / 20,
//
//                                         ),
//                                         SizedBox(width: 4), // Add some spacing between the icon and text
//                                         Text("This is a layout Demo pAge",
//                                           style: TextStyle(
//                                               fontFamily: "NexaRegular",
//                                               fontSize: screenWidth / 20,
//                                               color: Colors.red
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         // Icon(
//                                         //   Icons.person, // You can use any desired icon from the Icons class
//                                         //   color: primary,
//                                         //   size: screenWidth / 20,
//                                         // ),
//                                         SizedBox(width: 8), // Add some spacing between the icon and text
//                                         RichText(text: TextSpan(
//
//                                             text: "${widget.userInfo!.fname} ${widget.userInfo!.lname}",
//                                             style: TextStyle(
//                                               color: primary,
//                                               fontSize: screenWidth / 16,
//                                             )
//                                         ))
//                                       ],
//                                     ),
//                                     SizedBox(height: 10,),
//
//                                     Row(
//                                       children: [
//                                         SizedBox(width: 1), // Add some spacing between the icon and text
//                                         Icon(
//                                           Icons.person, // You can use any desired icon from the Icons class
//                                           color: primary,
//                                           size: screenWidth / 20,
//
//                                         ),
//                                         SizedBox(width: 4), // Add some spacing between the icon and text
//                                         Text(" Employee ID: ${widget.userInfo!.empId}",
//                                           style: TextStyle(
//                                               fontFamily: "NexaRegular",
//                                               fontSize: screenWidth / 20,
//                                               color: Colors.black54
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         SizedBox(width: 1), // Add some spacing between the icon and text
//                                         Icon(
//                                           Icons.email, // You can use any desired icon from the Icons class
//                                           color: primary,
//                                           size: screenWidth / 20,
//                                         ),
//                                         SizedBox(width: 4), // Add some spacing between the icon and text
//
//                                         Flexible(
//                                           child: Text(" Email: ${widget.userInfo!.email}",
//                                             style: TextStyle(
//                                                 fontFamily: "NexaRegular",
//                                                 fontSize: screenWidth / 20,
//                                                 color: Colors.black54
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         SizedBox(width: 1), // Add some spacing between the icon and text
//
//                                         Icon(
//                                           Icons.mobile_friendly_sharp, // You can use any desired icon from the Icons class
//                                           color: primary,
//                                           size: screenWidth / 20,
//                                         ),
//                                         SizedBox(width: 4), // Add some spacing between the icon and text
//                                         Text(" Mobile: ${widget.userInfo!.mobile}",
//                                           style: TextStyle(
//                                               fontFamily: "NexaRegular",
//                                               fontSize: screenWidth / 20,
//                                               color: Colors.black54
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         SizedBox(width: 2), // Add some spacing between the icon and text
//                                         Icon(
//                                           Icons.important_devices, // You can use any desired icon from the Icons class
//                                           color: primary,
//                                           size: screenWidth / 20,
//                                         ),
//                                         SizedBox(width: 3), // Add some spacing between the icon and text
//                                         Text(" Department: ${widget.userInfo!.departmentName}",
//                                           style: TextStyle(
//                                               fontFamily: "NexaRegular",
//                                               fontSize: screenWidth / 20,
//                                               color: Colors.black54
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//
//                         // ----------------------------Nested Child Box 2-------------------------------
//                         Container(
//                           margin: const EdgeInsets.only(top: 150,bottom: 20),
//                           child: Builder(builder: (context) {
//                             final GlobalKey<SlideActionState> key = GlobalKey();
//                             return Container(
//                               // color: widget.outerColor ?? Colors.green, // Set the custom background color here
//                               child: SlideAction(
//                                 text: "Slide to Log Out",
//                                 textStyle: TextStyle(
//                                   color: Colors.black54,
//                                   fontSize: screenWidth / 20,
//                                   fontFamily: "NexaRegular",
//                                 ),
//                                 outerColor: Colors.white,
//                                 innerColor: primary,
//                                 key: key,
//                                 onSubmit: () async {
//                                   final prefs = await SharedPreferences.getInstance();
//                                   await prefs.remove('userName');
//                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginApp()));
//                                   key.currentState!.reset(
//                                   );
//                                 },
//                               ),
//                             );
//                           }),
//                         )
// ,
//
//                       ],
//                     ),
//                   ),
//                 ],
//               )
// ,
//
//
//
//
//
//               // Container(
//               //   margin: const EdgeInsets.only(top: 270),
//               //   height: 200,
//               //   width: 360,
//               //   decoration: const BoxDecoration(
//               //     color: Colors.white,
//               //     boxShadow: [
//               //       BoxShadow(
//               //           color: Colors.black26,
//               //           blurRadius: 10,
//               //           offset: Offset(2, 2)
//               //       ),
//               //     ],
//               //     borderRadius: BorderRadius.all(Radius.circular(20)),
//               //   ),
//               //   child: Row (
//               //     mainAxisAlignment: MainAxisAlignment.center,
//               //     crossAxisAlignment: CrossAxisAlignment.center,
//               //     children: [
//               //       Expanded(
//               //         child: Column(
//               //           mainAxisAlignment: MainAxisAlignment.center,
//               //           crossAxisAlignment: CrossAxisAlignment.start,
//               //           children: [
//               //             Row(
//               //               children: [
//               //                 SizedBox(width: 1), // Add some spacing between the icon and text
//               //                 Icon(
//               //                   Icons.person, // You can use any desired icon from the Icons class
//               //                   color: primary,
//               //                   size: screenWidth / 20,
//               //
//               //                 ),
//               //                 SizedBox(width: 4), // Add some spacing between the icon and text
//               //                 Text("This is a layout Demo pAge",
//               //                   style: TextStyle(
//               //                       fontFamily: "NexaRegular",
//               //                       fontSize: screenWidth / 20,
//               //                       color: Colors.red
//               //                   ),
//               //                 ),
//               //               ],
//               //             ),
//               //             Row(
//               //               mainAxisAlignment: MainAxisAlignment.center,
//               //               crossAxisAlignment: CrossAxisAlignment.center,
//               //               children: [
//               //                 // Icon(
//               //                 //   Icons.person, // You can use any desired icon from the Icons class
//               //                 //   color: primary,
//               //                 //   size: screenWidth / 20,
//               //                 // ),
//               //                 SizedBox(width: 8), // Add some spacing between the icon and text
//               //                 RichText(text: TextSpan(
//               //
//               //                     text: "${widget.userInfo!.fname} ${widget.userInfo!.lname}",
//               //                     style: TextStyle(
//               //                       color: primary,
//               //                       fontSize: screenWidth / 16,
//               //                     )
//               //                 ))
//               //               ],
//               //             ),
//               //             SizedBox(height: 10,),
//               //
//               //             Row(
//               //               children: [
//               //                 SizedBox(width: 1), // Add some spacing between the icon and text
//               //                 Icon(
//               //                   Icons.person, // You can use any desired icon from the Icons class
//               //                   color: primary,
//               //                   size: screenWidth / 20,
//               //
//               //                 ),
//               //                 SizedBox(width: 4), // Add some spacing between the icon and text
//               //                 Text(" Employee ID: ${widget.userInfo!.empId}",
//               //                   style: TextStyle(
//               //                       fontFamily: "NexaRegular",
//               //                       fontSize: screenWidth / 20,
//               //                       color: Colors.black54
//               //                   ),
//               //                 ),
//               //               ],
//               //             ),
//               //             Row(
//               //               children: [
//               //                 SizedBox(width: 1), // Add some spacing between the icon and text
//               //                 Icon(
//               //                   Icons.email, // You can use any desired icon from the Icons class
//               //                   color: primary,
//               //                   size: screenWidth / 20,
//               //                 ),
//               //                 SizedBox(width: 4), // Add some spacing between the icon and text
//               //
//               //                 Flexible(
//               //                   child: Text(" Email: ${widget.userInfo!.email}",
//               //                     style: TextStyle(
//               //                         fontFamily: "NexaRegular",
//               //                         fontSize: screenWidth / 20,
//               //                         color: Colors.black54
//               //                     ),
//               //                   ),
//               //                 ),
//               //               ],
//               //             ),
//               //             Row(
//               //               children: [
//               //                 SizedBox(width: 1), // Add some spacing between the icon and text
//               //
//               //                 Icon(
//               //                   Icons.mobile_friendly_sharp, // You can use any desired icon from the Icons class
//               //                   color: primary,
//               //                   size: screenWidth / 20,
//               //                 ),
//               //                 SizedBox(width: 4), // Add some spacing between the icon and text
//               //                 Text(" Mobile: ${widget.userInfo!.mobile}",
//               //                   style: TextStyle(
//               //                       fontFamily: "NexaRegular",
//               //                       fontSize: screenWidth / 20,
//               //                       color: Colors.black54
//               //                   ),
//               //                 ),
//               //               ],
//               //             ),
//               //             Row(
//               //               children: [
//               //                 SizedBox(width: 2), // Add some spacing between the icon and text
//               //                 Icon(
//               //                   Icons.important_devices, // You can use any desired icon from the Icons class
//               //                   color: primary,
//               //                   size: screenWidth / 20,
//               //                 ),
//               //                 SizedBox(width: 3), // Add some spacing between the icon and text
//               //                 Text(" Department: ${widget.userInfo!.departmentName}",
//               //                   style: TextStyle(
//               //                       fontFamily: "NexaRegular",
//               //                       fontSize: screenWidth / 20,
//               //                       color: Colors.black54
//               //                   ),
//               //                 ),
//               //               ],
//               //             ),
//               //           ],
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//
//               // Container(
//               //   margin: const EdgeInsets.only(top: 100),
//               //   child: Builder(builder: (context) {
//               //     final GlobalKey<SlideActionState> key = GlobalKey();
//               //     return Container(
//               //       // color: widget.outerColor ?? Colors.green, // Set the custom background color here
//               //       child: SlideAction(
//               //         text: "Slide to Log Out",
//               //         textStyle: TextStyle(
//               //           color: Colors.black54,
//               //           fontSize: screenWidth / 20,
//               //           fontFamily: "NexaRegular",
//               //         ),
//               //         outerColor: Colors.white,
//               //         innerColor: primary,
//               //         key: key,
//               //         onSubmit: () async {
//               //           final prefs = await SharedPreferences.getInstance();
//               //           await prefs.remove('userName');
//               //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginApp()));
//               //           key.currentState!.reset(
//               //           );
//               //         },
//               //       ),
//               //     );
//               //   }),
//               // )
//             ],
//           ),
//         ),
//       ),
//         ],
//       ),
//     );
//
//   }
// }