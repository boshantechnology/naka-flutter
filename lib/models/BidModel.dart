class Bid {
  final String id;
  final String jobTitle;
  final String workerName;
  final double bidAmount;
  final int daysRequired;
  final String message;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime bidDate;

  Bid({
    required this.id,
    required this.jobTitle,
    required this.workerName,
    required this.bidAmount,
    required this.daysRequired,
    required this.message,
    required this.status,
    required this.bidDate,
  });

  // Convert to Map for SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'workerName': workerName,
      'bidAmount': bidAmount,
      'daysRequired': daysRequired,
      'message': message,
      'status': status,
      'bidDate': bidDate.toIso8601String(),
    };
  }

  // Create from Map
  factory Bid.fromMap(Map<String, dynamic> map) {
    return Bid(
      id: map['id'] as String,
      jobTitle: map['jobTitle'] as String,
      workerName: map['workerName'] as String,
      bidAmount: (map['bidAmount'] as num).toDouble(),
      daysRequired: map['daysRequired'] as int,
      message: map['message'] as String,
      status: map['status'] as String,
      bidDate: DateTime.parse(map['bidDate'] as String),
    );
  }
}
