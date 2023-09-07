class display_attaindance {
  final String date;
  final String intime;
  final String? outtime; // Use String? to indicate that it can be null

  display_attaindance({
    required this.date,
    required this.intime,
    this.outtime,
  });

  factory display_attaindance.fromJson(Map<String, dynamic> json) {
    return display_attaindance(
      date: json['date'],
      intime: json['intime'],
      outtime: json['outtime'],
    );
  }
}
