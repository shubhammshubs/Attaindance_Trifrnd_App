import 'dart:convert';
// import 'package:attaindace_display/user_model.dart';
import 'package:http/http.dart' as http;

import '../User_Session/display_attaindance.dart';

class ApiService {

  static Future<List<display_attaindance>> fetchAttendanceByMobile(String mobile) async {
    final response = await http.post(
      Uri.parse('https://api.trifrnd.com/portal/attend.php?apicall=attend'),
      body: {'mobile': mobile},
    );

    if (response.statusCode == 200) {
      final dynamic responseData = jsonDecode(response.body);

      if (responseData != null) {
        // Process the response here
        if (responseData is List) {
          // Successfully received a list of data
          return responseData.map((user) => display_attaindance.fromJson(user)).toList();
        } else {
          // Handle unexpected response format (e.g., it's a string or an object)
          print('Unexpected response format: $responseData');
          throw Exception('Unexpected response format');
        }
      } else {
        // Handle the case where the response is null
        print('API response is null');
        throw Exception('API response is null');
      }
    } else {
      // Handle other status codes (e.g., 404, 500)
      throw Exception('Failed to load attendance data');
    }
  }

}
