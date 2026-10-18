import '../models/booking.dart';
import '../models/cancellation.dart';
import 'app_database.dart';

class BookingService {
  Future<int> create(Booking booking) async {
    final db = await AppDatabase.instance.database;
    return db.insert('bookings', booking.toMap()..remove('id'));
  }

  Future<List<Booking>> forCustomer(String email) async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'bookings',
      where: 'customerEmail = ?',
      whereArgs: [email.toLowerCase()],
      orderBy: 'date DESC, time DESC',
    );
    return rows.map(Booking.fromMap).toList();
  }

  Future<void> saveSlip(int id, String path) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'bookings',
      {'slipPath': path, 'status': 'ส่งสลิปแล้ว (รอตรวจสอบ)'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<String> cancel(Booking booking) async {
    final appointmentAt = DateTime.parse('${booking.date} ${booking.time}:00');
    final now = DateTime.now();
    final eligible = Cancellation(
      appointmentAt: appointmentAt,
      cancelledAt: now,
    ).refundEligible;
    final status = eligible ? 'มีสิทธิ์คืนมัดจำ' : 'ไม่คืนมัดจำ';
    final db = await AppDatabase.instance.database;
    await db.update(
      'bookings',
      {
        'status': 'ยกเลิกแล้ว',
        'refundStatus': status,
      },
      where: 'id = ?',
      whereArgs: [booking.id],
    );
    return status;
  }
}
