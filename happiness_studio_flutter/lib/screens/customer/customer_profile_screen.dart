import 'package:flutter/material.dart';

import '../../models/booking.dart';
import '../../models/user.dart';
import '../../services/booking_service.dart';
import '../auth/login_screen.dart';
import 'booking_status_screen.dart';

class CustomerProfileScreen extends StatefulWidget {
  final AppUser user;

  const CustomerProfileScreen({super.key, required this.user});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  static const Color pink = Color(0xFFB45D83);
  static const Color darkPink = Color(0xFF75405A);
  static const Color background = Color(0xFFFFF8FB);

  late Future<List<Booking>> _bookingFuture;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  // โหลดรายการจองของลูกค้าคนนี้
  void _loadBookings() {
    _bookingFuture = BookingService().forCustomer(widget.user.email);
  }

  // โหลดข้อมูลใหม่เมื่อกดรีเฟรช
  Future<void> _refresh() async {
    setState(_loadBookings);
    await _bookingFuture;
  }

  // ยืนยันก่อนออกจากระบบ
  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'ออกจากระบบ',
            style: TextStyle(color: darkPink, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'คุณต้องการออกจากระบบใช่ไหม?',
            style: TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'ยกเลิก',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: pink,
                foregroundColor: Colors.white,
              ),
              child: const Text('ออกจากระบบ'),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldLogout != true) return;

    // กลับไปหน้า Login และล้างหน้าก่อนหน้าทั้งหมด
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  // ไปหน้ารายการจองทั้งหมด
  void _openAllBookings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingStatusScreen(email: widget.user.email),
      ),
    ).then((_) {
      if (mounted) {
        setState(_loadBookings);
      }
    });
  }

  // หัวข้อแต่ละส่วน
  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: pink, size: 23),
        const SizedBox(width: 9),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkPink,
          ),
        ),
      ],
    );
  }

  // แสดงข้อมูลลูกค้าแต่ละแถว
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEF4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: pink, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: darkPink,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // การ์ดแสดงรายการจอง
  Widget _bookingPreview(Booking booking) {
    final cancelled = booking.status == 'ยกเลิกแล้ว';

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1DDE6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8DCE8),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(Icons.spa_outlined, color: pink),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.designName,
                      style: const TextStyle(
                        color: darkPink,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${booking.date} • ${booking.time}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: cancelled ? Colors.grey.shade200 : const Color(0xFFFFEEF4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              booking.status,
              style: TextStyle(
                color: cancelled ? Colors.grey.shade700 : darkPink,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'ราคาประเมิน',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Text(
                '${booking.totalPrice.toStringAsFixed(0)} บาท',
                style: const TextStyle(
                  color: darkPink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'เงินมัดจำ',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Text(
                '${booking.deposit.toStringAsFixed(0)} บาท',
                style: const TextStyle(
                  color: pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ส่วนแสดงรายการจองล่าสุด
  Widget _bookingSection() {
    return FutureBuilder<List<Booking>>(
      future: _bookingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator(color: pink)),
          );
        }

        if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: pink, size: 36),
                const SizedBox(height: 8),
                const Text('โหลดข้อมูลการจองไม่สำเร็จ'),
                TextButton(
                  onPressed: _refresh,
                  child: const Text('ลองอีกครั้ง'),
                ),
              ],
            ),
          );
        }

        final bookings = snapshot.data ?? [];

        if (bookings.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFF1DDE6)),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: Color(0xFFD9A6BC),
                  size: 46,
                ),
                SizedBox(height: 10),
                Text(
                  'ยังไม่มีรายการจอง',
                  style: TextStyle(
                    color: darkPink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'เมื่อจองคิวแล้ว รายการจองจะแสดงที่นี่',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          );
        }

        // แสดงรายการจอง 3 รายการล่าสุด
        final recentBookings = bookings.take(3).toList();

        return Column(
          children: [
            ...recentBookings.map(_bookingPreview),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openAllBookings,
                icon: const Icon(Icons.receipt_long_outlined),
                label: const Text('ดูรายการจองทั้งหมด'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: pink,
                  side: const BorderSide(color: Color(0xFFE8B8CC)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('โปรไฟล์ของฉัน'),
        backgroundColor: background,
        foregroundColor: darkPink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'รีเฟรชข้อมูล',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: pink,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            // ส่วนหัวโปรไฟล์
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFEAF2), Color(0xFFF7D5E3)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: pink,
                      size: 52,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.user.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: darkPink,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'สมาชิก Happiness Studio ♡',
                    style: TextStyle(color: darkPink, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitle('ข้อมูลลูกค้า', Icons.person_outline_rounded),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1DDE6)),
              ),
              child: Column(
                children: [
                  if (widget.user.id != null)
                    _infoRow(
                      Icons.badge_outlined,
                      'รหัสลูกค้า',
                      'CUS${widget.user.id.toString().padLeft(3, '0')}',
                    ),
                  _infoRow(Icons.person_outline, 'ชื่อ', widget.user.name),
                  _infoRow(Icons.email_outlined, 'อีเมล', widget.user.email),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _sectionTitle('ข้อมูลการจอง', Icons.calendar_month_outlined),
            const SizedBox(height: 4),
            const Text(
              'รายการจองล่าสุดของคุณ',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            _bookingSection(),
            const SizedBox(height: 32),

            // ปุ่มออกจากระบบ
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('ออกจากระบบ'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: pink,
                  side: const BorderSide(color: Color(0xFFE8B8CC)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
