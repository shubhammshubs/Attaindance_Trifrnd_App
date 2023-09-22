import 'attendanceData.dart';

class User {
  final String id;
  final String fname;
  final String lname;
  final String empId;
  final String email;
  final String mobile;
  final String departmentName;

  AttendanceData? attendanceData; // Add attendance data field



  User({
    required this.id,
    required this.fname,
    required this.lname,
    required this.empId,
    required this.email,
    required this.mobile,
    required this.departmentName,
    this.attendanceData, // Initialize attendance data to null

  });


  // Factory constructor to create a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      empId: json['EmpId'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      departmentName: json['department_name'] ?? '',
    );
  }
}
