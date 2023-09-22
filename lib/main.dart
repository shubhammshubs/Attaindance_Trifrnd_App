  import 'dart:convert';
  import 'package:attaindance_user_aug/splash_screen.dart';
  import 'package:flutter/material.dart';
  import 'package:fluttertoast/fluttertoast.dart';
  import 'package:get/get_core/src/get_main.dart';
  import 'package:http/http.dart' as http;
  import 'package:month_year_picker/month_year_picker.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:get/get.dart';

  import 'HomePage.dart';

  void main() {
    runApp(GetMaterialApp(
      home: LoginApp(),
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
    ));
  }

  class LoginApp extends StatelessWidget {

    @override
    Widget build(BuildContext context) {

      return MaterialApp(
        title: 'Trifrnd Attendance',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          hintColor: Colors.blue, // Set your desired accent color here
        ),
        home:
        SplashScreen(),
      );
    }
  }

  class LoginPage extends StatefulWidget {
    @override
    _LoginPageState createState() => _LoginPageState();

  }

  class _LoginPageState extends State<LoginPage> {
    TextEditingController _mobileController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    bool _isPasswordVisible = false;
    bool _isLoading = false;


    Future<void> _login() async {

      setState(() {
        _isLoading = true;
      });

      final String apiUrl =
          'https://api.trifrnd.com/portal/Attend.php?apicall=login';

      // Simulate a delay of 1 second
      await Future.delayed(Duration(seconds: 1));

      final response = await http.post(Uri.parse(apiUrl),
          body: {
            "mobile": _mobileController.text,
            "password": _passwordController.text,
          });

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("Response body: ${response.body}");

        print("Decoded data: $responseData");

        if (responseData == "Login Done" ) {
          // Login successful, you can navigate to the next screen
          print("Login successful");
          final user = json.decode(response.body)[0];
          final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('mobile', _mobileController.text);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(mobileNumber: _mobileController.text,)),

          );
        } else {
          // Login failed, show an error message
          print("Login failed");
          // Fluttertoast.showToast(msg: "LogIn Failed");
          Fluttertoast.showToast(msg: "Invalid mobile number or password!",toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red,
            textColor: Colors.white,);
        }
      } else {
        // Handle error if the API call was not successful
        print("API call failed");
        Fluttertoast.showToast(msg: "Server Connction Error!",toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(

        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(height: 1,),
                  Container(
                    child: Image.asset(
                      'assets/images/jpg_logo_crop.jpg',
                      fit: BoxFit.fitHeight,

                    ),
                  ),
                  TextField(
                    controller: _mobileController,
                    decoration: InputDecoration(labelText: 'Mobile Number',
                        prefixIcon: Icon(Icons.mobile_friendly_sharp)),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password',
                        prefixIcon: Icon(Icons.password_outlined),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off
                          ),
                        )    // This Widget is for password Visibility
                    ),
                    obscureText: _isPasswordVisible,
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator()  // Show loading indicator
                        : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.login),
                        SizedBox(width: 8),
                        Text('Login'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
