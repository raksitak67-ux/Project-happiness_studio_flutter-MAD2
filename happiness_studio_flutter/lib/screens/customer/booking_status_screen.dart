import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/booking.dart';
import '../../services/booking_service.dart';
import 'payment_screen.dart';

class BookingStatusScreen extends StatefulWidget {
  final String email;

  const BookingStatusScreen({super.key, required this.email});

  @override
  State<BookingStatusScreen> createState() => _BookingStatusScreenState();
}

class _BookingStatusScreenState extends State<BookingStatusScreen> {
  late Future<List<Booking>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = BookingService().forCustomer(widget.email);
  }

  Future<void> _refresh() async {
    setState(_load);
    await _future;
  }

  bool _hasSlip(Booking booking) {
    return booking.slipPath != null && booking.slipPath!.trim().isNotEmpty;
  }

  DateTime? _appointmentDate(Booking booking) {
    try {
      return DateTime.parse('${booking.date} ${booking.time}:00');
    } catch (_) {
      return null;
    }
  }

  String _cancelExplanation(Booking booking) {
    if (!_hasSlip(booking)) {
      return 'รายการนี้ยังไม่มีไฟล์สลิปแนบ '
          'จึงยังไม่มีหลักฐานการชำระมัดจำในระบบ '
          'หากยืนยันยกเลิก จะยกเลิกรายการจองนี้';
    }

    final appointment = _appointmentDate(booking);

    if (appointment == null) {
      return 'ไม่สามารถตรวจสอบวันนัดหมายได้ '
          'กรุณาตรวจสอบข้อมูลการจองก่อนยกเลิก';
    }

    final remaining = appointment.difference(DateTime.now());

    if (remaining >= const Duration(days: 3)) {
      return 'คุณกำลังยกเลิกล่วงหน้าอย่างน้อย 3 วัน '
          'ตามเงื่อนไขร้านมีสิทธิ์ได้รับมัดจำคืน '
          'ทั้งนี้ขึ้นอยู่กับการตรวจสอบการชำระเงินของร้าน';
    }

    return 'เหลือเวลาน้อยกว่า 3 วันก่อนถึงวันนัดหมาย '
        'ตามเงื่อนไขร้านจะไม่คืนมัดจำ '
        'หากยืนยันยกเลิก';
  }

  Future<void> _cancel(Booking booking) async {
    if (booking.status == 'ยกเลิกแล้ว') return;

    final hasSlip = _hasSlip(booking);
    final appointment = _appointmentDate(booking);

    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Expanded(child: Text('ยืนยันการยกเลิก')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('แบบเล็บ: ${booking.designName}'),
              const SizedBox(height: 6),
              Text('วันนัดหมาย: ${booking.date}'),
              Text('เวลานัดหมาย: ${booking.time}'),
              const SizedBox(height: 12),
              const Divider(),
              const Text(
                'เงื่อนไขการคืนมัดจำ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                '• ยกเลิกล่วงหน้าอย่างน้อย 3 วัน: '
                'มีสิทธิ์ได้รับมัดจำคืน หากชำระแล้ว\n'
                '• ยกเลิกก่อนถึงวันนัดหมายน้อยกว่า 3 วัน: '
                'ไม่คืนมัดจำ หากชำระแล้ว',
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(_cancelExplanation(booking)),
              ),
              if (hasSlip) ...[
                const SizedBox(height: 8),
                const Text(
                  'หมายเหตุ: การแนบสลิปยังไม่ใช่การยืนยัน '
                  'ว่าร้านตรวจสอบและรับชำระเงินเรียบร้อยแล้ว',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
              if (appointment != null &&
                  appointment.isBefore(DateTime.now())) ...[
                const SizedBox(height: 8),
                const Text(
                  'คำเตือน: วันนัดหมายผ่านไปแล้ว '
                  'กรุณาตรวจสอบกับร้านก่อนยกเลิก',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('กลับไป'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('ยืนยันยกเลิก'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    try {
      final result = await BookingService().cancel(booking);

      if (!mounted) return;

      setState(_load);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ยกเลิกการจองไม่สำเร็จ: $e')));
    }
  }

  String _accessoryText(String level) {
    switch (level) {
      case 'few':
        return 'เล็กน้อย (+50 บาท)';
      case 'many':
        return 'เยอะ (+100 บาท)';
      default:
        return 'ไม่ใส่';
    }
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _referenceImage(String? path) {
    if (path == null || path.isEmpty) {
      return const SizedBox.shrink();
    }

    final file = File(path);

    if (!file.existsSync()) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          'ไม่พบไฟล์รูปอ้างอิงในเครื่อง',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'รูปอ้างอิง',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              file,
              height: 160,
              width: 160,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: Text('ไม่สามารถแสดงรูปได้')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookingCard(Booking b) {
    final cancelled = b.status == 'ยกเลิกแล้ว';
    final hasSlip = _hasSlip(b);
    final balance = (b.totalPrice - b.deposit)
        .clamp(0, double.infinity)
        .toDouble();

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              b.designName,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: cancelled
                    ? Colors.grey.shade200
                    : const Color(0xFFF8DCE8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'สถานะ: ${b.status}',
                style: TextStyle(
                  color: cancelled
                      ? Colors.grey.shade700
                      : const Color(0xFF8F3F61),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _detailRow('วันที่จอง', b.date),
            _detailRow('เวลานัดหมาย', b.time),
            const Divider(height: 24),
            const Text(
              'รายละเอียดการทำเล็บ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _detailRow('ทรงเล็บ', b.nailShape),
            _detailRow('ต่อ PVC', b.usePvc ? 'ต่อ PVC' : 'ไม่ต่อ PVC'),
            _detailRow('ระดับอะไหล่', _accessoryText(b.accessoryLevel)),
            if (b.details.trim().isNotEmpty)
              _detailRow('รายละเอียดเพิ่มเติม', b.details),
            _referenceImage(b.referencePath),
            const Divider(height: 24),
            const Text(
              'สรุปค่าใช้จ่าย',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _detailRow('ราคาประเมิน', '${b.totalPrice.toStringAsFixed(0)} บาท'),
            _detailRow('เงินมัดจำ', '${b.deposit.toStringAsFixed(0)} บาท'),
            _detailRow('ยอดคงเหลือ', '${balance.toStringAsFixed(0)} บาท'),
            if (b.refundStatus != 'ไม่เกี่ยวข้อง')
              _detailRow('สถานะมัดจำ', b.refundStatus),
            if (hasSlip) ...[
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.receipt_long, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('มีไฟล์สลิปแนบแล้ว')),
                  if (File(b.slipPath!).existsSync())
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        File(b.slipPath!),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (!cancelled && !hasSlip)
                  OutlinedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentScreen(booking: b),
                        ),
                      );

                      if (mounted) setState(_load);
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('แนบสลิป'),
                  ),
                if (!cancelled)
                  TextButton.icon(
                    onPressed: () => _cancel(b),
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('ยกเลิกการจอง'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('การจองของฉัน'),
        backgroundColor: const Color(0xFFF8DCE8),
        foregroundColor: const Color(0xFF593747),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'รีเฟรชรายการ',
          ),
        ],
      ),
      body: FutureBuilder<List<Booking>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text('โหลดรายการจองไม่สำเร็จ'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _refresh,
                      child: const Text('ลองอีกครั้ง'),
                    ),
                  ],
                ),
              ),
            );
          }

          final bookings = snapshot.data ?? [];

          if (bookings.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text('ยังไม่มีรายการจอง'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return _bookingCard(bookings[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
