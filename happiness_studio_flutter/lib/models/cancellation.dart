class Cancellation {
  final DateTime appointmentAt;
  final DateTime cancelledAt;

  const Cancellation({
    required this.appointmentAt,
    required this.cancelledAt,
  });

  // เงื่อนไขนี้ใช้ 72 ชั่วโมงเต็มก่อนเวลานัดหมาย
  bool get refundEligible =>
      appointmentAt.difference(cancelledAt) >= const Duration(days: 3);
}
