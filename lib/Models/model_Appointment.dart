class Appointment {
  final int? id;
  final int userId;
  final String name;
  final String address;
  final String time;
  final String date;
  final String notes;
  final String status;

  Appointment({
    this.id,
    required this.userId,
    required this.name,
    required this.address,
    required this.time,
    required this.date,
    required this.notes,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'address': address,
      'time': time,
      'date': date,
      'notes': notes,
      'status': status,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      address: map['address'],
      time: map['time'],
      date: map['date'],
      notes: map['notes'],
      status: map['status'],
    );
  }
}
