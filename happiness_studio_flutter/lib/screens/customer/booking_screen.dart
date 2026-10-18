import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/booking.dart';
import '../../models/nail_design.dart';
import '../../models/nail_request.dart';
import '../../models/price_estimate.dart';
import '../../models/user.dart';
import '../../services/booking_service.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final AppUser user;
  final NailDesign design;
  final NailRequest request;
  final PriceEstimate estimate;

  const BookingScreen({
    super.key,
    required this.user,
    required this.design,
    required this.request,
    required this.estimate,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _date;
  String _time = '10:00';
  final _times = const ['10:00', '11:30', '13:00', '14:30', '16:00'];

  Future<void> _chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _continue() async {
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณาเลือกวันที่')));
      return;
    }
    // Starter version: เก็บการจองในเครื่อง แต่ยังไม่มีระบบป้องกันเวลาซ้ำข้ามอุปกรณ์
    final booking = Booking(
      customerEmail: widget.user.email.toLowerCase(),
      designName: widget.design.name,
      date: DateFormat('yyyy-MM-dd').format(_date!),
      time: _time,
      totalPrice: widget.estimate.total,
      deposit: widget.estimate.deposit,
      status: 'รอส่งสลิปมัดจำ (สาธิต)',
      referencePath: widget.request.referencePath,
      createdAt: DateTime.now().toIso8601String(),
    );
    final id = await BookingService().create(booking);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(booking: Booking(
          id: id,
          customerEmail: booking.customerEmail,
          designName: booking.designName,
          date: booking.date,
          time: booking.time,
          totalPrice: booking.totalPrice,
          deposit: booking.deposit,
          status: booking.status,
          referencePath: booking.referencePath,
          createdAt: booking.createdAt,
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('เลือกวันและเวลา')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(widget.design.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _chooseDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(_date == null ? 'เลือกวันที่' : DateFormat('dd/MM/yyyy').format(_date!)),
            ),
            const SizedBox(height: 14),
            const Text('เลือกเวลา', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _times.map((t) => ChoiceChip(
                label: Text(t),
                selected: _time == t,
                onSelected: (_) => setState(() => _time = t),
              )).toList(),
            ),
            const SizedBox(height: 20),
            Text('ยอดมัดจำ: ${widget.estimate.deposit.toStringAsFixed(0)} บาท'),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _continue, child: const Text('ยืนยันวันเวลาและไปหน้ามัดจำ')),
          ],
        ),
      );
}
