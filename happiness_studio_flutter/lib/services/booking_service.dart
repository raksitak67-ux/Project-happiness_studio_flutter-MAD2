import '../models/booking.dart';
import '../models/cancellation.dart';
import 'app_database.dart';

class BookingService {
  // สร้างรายการจองใหม่
  Future<int> create(Booking booking) async {
    final db = await AppDatabase.instance.database;

    return db.insert('bookings', booking.toMap()..remove('id'));
  }

  // ดึงรายการจองของลูกค้า โดยให้รายการที่สร้างล่าสุดอยู่ด้านบน
  Future<List<Booking>> forCustomer(String email) async {
    final db = await AppDatabase.instance.database;

    final rows = await db.query(
      'bookings',
      where: 'customerEmail = ?',
      whereArgs: [email.toLowerCase()],
      orderBy: 'createdAt DESC, id DESC',
    );

    return rows.map((row) => Booking.fromMap(row)).toList();
  }

  // ดึงเวลาที่มีการจองในวันที่เลือก
  // ไม่นับรายการที่ยกเลิกแล้ว เพื่อให้จองเวลานั้นใหม่ได้
  Future<List<String>> bookedTimes(String date) async {
    final db = await AppDatabase.instance.database;

    final rows = await db.query(
      'bookings',
      columns: ['time'],
      where: 'date = ? AND status != ?',
      whereArgs: [date, 'ยกเลิกแล้ว'],
    );

    return rows.map((row) => row['time'] as String).toList();
  }

  // บันทึกตำแหน่งไฟล์สลิปและเปลี่ยนสถานะการจอง
  Future<void> saveSlip(int id, String path) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      'bookings',
      {'slipPath': path, 'status': 'ส่งสลิปแล้ว (รอตรวจสอบ)'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ยกเลิกการจองและตรวจสอบสิทธิ์คืนมัดจำเบื้องต้น
  Future<String> cancel(Booking booking) async {
    final db = await AppDatabase.instance.database;

    // อ่านข้อมูลล่าสุดจากฐานข้อมูลก่อนตรวจสอบ
    final rows = await db.query(
      'bookings',
      where: 'id = ? AND customerEmail = ?',
      whereArgs: [booking.id, booking.customerEmail.toLowerCase()],
      limit: 1,
    );

    if (rows.isEmpty) {
      return 'ไม่พบรายการจอง';
    }

    final row = rows.first;
    final slipPath = row['slipPath'] as String?;

    // ถ้ายังไม่มีไฟล์สลิป จะยังไม่มีหลักฐานการชำระมัดจำ
    final String refundStatus;

    if (slipPath == null || slipPath.isEmpty) {
      refundStatus = 'ยังไม่ได้ชำระมัดจำ';
    } else {
      // ตรวจสอบระยะเวลาจากวันนัดหมายถึงเวลาที่ยกเลิก
      final appointmentAt = DateTime.parse('${row['date']} ${row['time']}:00');

      final now = DateTime.now();

      final eligible = Cancellation(
        appointmentAt: appointmentAt,
        cancelledAt: now,
      ).refundEligible;

      refundStatus = eligible ? 'มีสิทธิ์คืนมัดจำ (รอตรวจสอบ)' : 'ไม่คืนมัดจำ';
    }

    // เปลี่ยนสถานะรายการจองเป็นยกเลิกแล้ว
    await db.update(
      'bookings',
      {'status': 'ยกเลิกแล้ว', 'refundStatus': refundStatus},
      where: 'id = ? AND customerEmail = ?',
      whereArgs: [booking.id, booking.customerEmail.toLowerCase()],
    );

    return refundStatus;
  }
}
