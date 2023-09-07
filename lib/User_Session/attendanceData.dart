class AttendanceData {
  final String date;
  final String intime;
  final String outtime;

  AttendanceData({
    required this.date,
    required this.intime,
    required this.outtime,
  });

//   factory AttendanceData.fromJson(Map<String, dynamic> json) {
//     return AttendanceData(
//       date: json['date'],
//       intime: json['intime'],
//       outtime: json['outtime'],
//     );
//   }
}
