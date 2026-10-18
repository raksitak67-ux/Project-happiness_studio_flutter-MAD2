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

  void _load() => _future = BookingService().forCustomer(widget.email);

  Future<void> _cancel(Booking booking) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการยกเลิก'),
        content: const Text('ต้องการยกเลิกการจองนี้หรือไม่? ระบบจะตรวจสอบเงื่อนไขคืนมัดจำตามเวลานัดหมาย'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ไม่ยกเลิก')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('ยืนยันยกเลิก')),
        ],
      ),
    );
    if (confirm != true) return;
    final result = await BookingService().cancel(booking);
    if (!mounted) return;
    setState(_load);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('การจองของฉัน'),
          actions: [IconButton(onPressed: () => setState(_load), icon: const Icon(Icons.refresh))],
        ),
        body: FutureBuilder<List<Booking>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final bookings = snapshot.data ?? [];
            if (bookings.isEmpty) {
              return const Center(child: Text('ยังไม่มีรายการจอง'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final b = bookings[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.designName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('วันที่ ${b.date} เวลา ${b.time}'),
                        Text('ยอดรวม ${b.totalPrice.toStringAsFixed(0)} บาท • มัดจำ ${b.deposit.toStringAsFixed(0)} บาท'),
                        Text('สถานะ: ${b.status}'),
                        if (b.refundStatus != 'ไม่เกี่ยวข้อง') Text('สถานะมัดจำ: ${b.refundStatus}'),
                        if (b.slipPath != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, size: 18),
                                const SizedBox(width: 5),
                                const Text('มีไฟล์สลิปแนบแล้ว'),
                                const SizedBox(width: 8),
                                if (File(b.slipPath!).existsSync())
                                  SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Image.file(File(b.slipPath!), fit: BoxFit.cover),
                                  ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: [
                            if (b.slipPath == null && b.status != 'ยกเลิกแล้ว')
                              OutlinedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => PaymentScreen(booking: b)),
                                ).then((_) => setState(_load)),
                                child: const Text('แนบสลิป'),
                              ),
                            if (b.status != 'ยกเลิกแล้ว')
                              TextButton(
                                onPressed: () => _cancel(b),
                                child: const Text('ยกเลิกการจอง'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
}
