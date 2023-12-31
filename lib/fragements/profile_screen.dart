import 'package:attaindance_user_aug/User_Session/User.dart';
import 'package:attaindance_user_aug/main.dart';
import 'package:attaindance_user_aug/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:http/http.dart' as http;



class Profilescreen extends StatefulWidget {
  final User? userInfo; // Add this line
  final String mobileNumber;

  const Profilescreen({Key? key, this.userInfo,
    required this.mobileNumber,

  }) : super(key: key); // Update the constructor

  @override
  State<Profilescreen> createState() => _Profilescreen();
}

class _Profilescreen extends State<Profilescreen> {
  String dropdownValue = 'User Info'; // Initial dropdown value
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffeef444c);

  String apiUrl = "https://api.trifrnd.com/portal/attend.php?apicall=readphoto";
  String imageBaseUrl = "https://portal.trifrnd.com";

  String? imageUrl;

  @override
  void initState() {
    super.initState();
    fetchAndDisplayImage(widget.mobileNumber);
  }

  Future<void> fetchAndDisplayImage(String mobile) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"mobile": mobile},
      );
      if (response.statusCode == 200) {
        final imageName = response.body.replaceAll('"..', '').replaceAll('///', '//').replaceAll('"', '');
        setState(() {
          imageUrl = "$imageBaseUrl$imageName";
        });
      } else {
        // Handle the case when the API call fails or returns an error
        imageUrl = null;
      }
    } catch (error) {
      print("Error fetching photo data: $error");
      // Handle the case when an error occurs during the API call
      imageUrl = null;
    }
  }


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body:  Stack(
        children: [
          // -------------------------This is code for cover page -----------------------------------------
          Container(
            height: 250, // Fixed height for the cover page
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(2, 2),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),

            ),
            child: Image.asset(
               // "${widget.userInfo!.mobile}",

                'assets/images/cover1.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // -------------------------This is code for Profile Photo circle--------------------------------
          Container(
            margin: const EdgeInsets.only(top: 125, right: 1, left: 250),
            child: Column(
              children: <Widget>[
                if (imageUrl != null)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white, // Set the border color here
                        width: 2, // Set the border width here
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        imageUrl!,
                        width: 120, // Adjust the size as needed
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Text('Image not found'),
              ],
            ),

          ),




          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[



                  // -----------------------Code for COver Page End --------------------------
                  // Code for Profile Page
                  // Container(
                  //   margin: const EdgeInsets.only(top: 132,right: 1,left: 220),
                  //
                  //   child: CircleAvatar(
                  //     backgroundImage: AssetImage('assets/images/CoverPage.jpg'),
                  //     backgroundColor: Colors.greenAccent,
                  //     radius: 60,
                  //
                  //   ),
                  // ),
                  SizedBox(height: 1,),

                  // -------------------------Main Box Of Nested BoxDEcoration--------------------------------

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 240),
                        width: 460,
                        decoration: BoxDecoration(
                          color: Colors.white, // Main BoxDecoration
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Set the mainAxisSize to min
                          children:[
                            // ------------------------- Nested child Box 1--------------------------------

                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              height: 200,
                              width: 360,
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(width: 8), // Add some spacing between the icon and text

                                            RichText(text: TextSpan(

                                                text: "${widget.userInfo!.fname} ${widget.userInfo!.lname}",
                                                style: TextStyle(
                                                  color: primary,
                                                  fontSize: screenWidth / 16,
                                                )
                                            ))
                                          ],
                                        ),
                                        SizedBox(height: 10,),

                                        Row(
                                          children: [
                                            SizedBox(width: 1), // Add some spacing between the icon and text
                                            Icon(
                                              Icons.person, // You can use any desired icon from the Icons class
                                              color: primary,
                                              size: screenWidth / 20,
                                            ),
                                            SizedBox(width: 4), // Add some spacing between the icon and text
                                            Text(" ${widget.userInfo!.empId}",
                                              style: TextStyle(
                                                  fontFamily: "NexaRegular",
                                                  fontSize: screenWidth / 20,
                                                  color: Colors.black54
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),

                                        Row(
                                          children: [
                                            SizedBox(width: 1), // Add some spacing between the icon and text
                                            Icon(
                                              Icons.email, // You can use any desired icon from the Icons class
                                              color: primary,
                                              size: screenWidth / 20,
                                            ),
                                            SizedBox(width: 4), // Add some spacing between the icon and text

                                            Flexible(
                                              child: Text(" ${widget.userInfo!.email}",
                                                style: TextStyle(
                                                    fontFamily: "NexaRegular",
                                                    fontSize: screenWidth / 20,
                                                    color: Colors.black54
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),

                                        Row(
                                          children: [
                                            SizedBox(width: 1), // Add some spacing between the icon and text

                                            Icon(
                                              Icons.mobile_friendly_sharp, // You can use any desired icon from the Icons class
                                              color: primary,
                                              size: screenWidth / 20,
                                            ),
                                            SizedBox(width: 4), // Add some spacing between the icon and text
                                            Text(" ${widget.userInfo!.mobile}",
                                              style: TextStyle(
                                                  fontFamily: "NexaRegular",
                                                  fontSize: screenWidth / 20,
                                                  color: Colors.black54
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),

                                        // Row(
                                        //   children: [
                                        //     SizedBox(width: 2), // Add some spacing between the icon and text
                                        //     Icon(
                                        //       Icons.important_devices, // You can use any desired icon from the Icons class
                                        //       color: primary,
                                        //       size: screenWidth / 20,
                                        //     ),
                                        //     SizedBox(width: 3), // Add some spacing between the icon and text
                                        //     Text(" Department: ${widget.userInfo!.departmentName}",
                                        //       style: TextStyle(
                                        //           fontFamily: "NexaRegular",
                                        //           fontSize: screenWidth / 20,
                                        //           color: Colors.black54
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            // ----------------------------Nested Child Box 2-------------------------------
                            Container(
                              margin: const EdgeInsets.only(top: 150,bottom: 20),
                              child: Builder(builder: (context) {
                                final GlobalKey<SlideActionState> key = GlobalKey();
                                return Container(
                                  // color: widget.outerColor ?? Colors.green, // Set the custom background color here
                                  child: SlideAction(
                                    text: "Slide to Log Out ",
                                    textStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize: screenWidth / 20,
                                      fontFamily: "NexaRegular",
                                    ),
                                    outerColor: Colors.white,
                                    innerColor: primary,
                                    key: key,
                                    onSubmit: () async {
                                      final SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                      await sharedPreferences.remove('mobile');
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginApp()));
                                      key.currentState!.reset(
                                      );
                                    },
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}