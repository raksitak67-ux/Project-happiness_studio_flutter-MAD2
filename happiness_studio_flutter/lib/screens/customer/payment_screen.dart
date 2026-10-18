import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import 'booking_status_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Booking booking;
  const PaymentScreen({super.key, required this.booking});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _slipPath;
  bool _saving = false;

  Future<void> _pickSlip() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null && mounted) setState(() => _slipPath = image.path);
  }

  Future<void> _submit() async {
    if (_slipPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณาเลือกรูปสลิป')));
      return;
    }
    setState(() => _saving = true);
    await BookingService().saveSlip(widget.booking.id!, _slipPath!);
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => BookingStatusScreen(email: widget.booking.customerEmail)),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('ชำระเงินมัดจำ')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('QR สำหรับสาธิต', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE8A0BF)),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_2, size: 120, color: Color(0xFFB85C83)),
                  Text('DEMO QR — ไม่ใช่ QR ชำระเงินจริง'),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text('ยอดมัดจำ: ${widget.booking.deposit.toStringAsFixed(0)} บาท',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _pickSlip,
              icon: const Icon(Icons.upload_file),
              label: const Text('อัปโหลดสลิปจากเครื่อง'),
            ),
            if (_slipPath != null) ...[
              const SizedBox(height: 12),
              Image.file(File(_slipPath!), height: 180, fit: BoxFit.contain),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: Text(_saving ? 'กำลังบันทึก...' : 'ส่งสลิป (จำลอง)'),
            ),
            const SizedBox(height: 8),
            const Text(
              'การส่งสลิปเป็นเพียงการบันทึกไฟล์ในเครื่อง แอปไม่ได้ตรวจสอบยอดเงินหรือยืนยันการรับเงินจริง',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
}
