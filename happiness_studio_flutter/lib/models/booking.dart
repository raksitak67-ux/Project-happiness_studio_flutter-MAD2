class Booking {
  final int? id;
  final String customerEmail;
  final String designName;
  final String date;
  final String time;
  final double totalPrice;
  final double deposit;
  final String status;
  final String? referencePath;
  final String? slipPath;
  final String refundStatus;
  final String createdAt;

  const Booking({
    this.id,
    required this.customerEmail,
    required this.designName,
    required this.date,
    required this.time,
    required this.totalPrice,
    required this.deposit,
    required this.status,
    this.referencePath,
    this.slipPath,
    this.refundStatus = 'ไม่เกี่ยวข้อง',
    required this.createdAt,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'customerEmail': customerEmail,
        'designName': designName,
        'date': date,
        'time': time,
        'totalPrice': totalPrice,
        'deposit': deposit,
        'status': status,
        'referencePath': referencePath,
        'slipPath': slipPath,
        'refundStatus': refundStatus,
        'createdAt': createdAt,
      };

  factory Booking.fromMap(Map<String, Object?> map) => Booking(
        id: map['id'] as int?,
        customerEmail: map['customerEmail'] as String,
        designName: map['designName'] as String,
        date: map['date'] as String,
        time: map['time'] as String,
        totalPrice: (map['totalPrice'] as num).toDouble(),
        deposit: (map['deposit'] as num).toDouble(),
        status: map['status'] as String,
        referencePath: map['referencePath'] as String?,
        slipPath: map['slipPath'] as String?,
        refundStatus: (map['refundStatus'] as String?) ?? 'ไม่เกี่ยวข้อง',
        createdAt: map['createdAt'] as String,
      );
}
