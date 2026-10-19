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
  final ImagePicker _picker = ImagePicker();
  final BookingService _bookingService = BookingService();

  String? _slipPath;
  bool _saving = false;

  // เลือกรูปสลิปจากแกลเลอรี
  Future<void> _pickSlip() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (!mounted || image == null) return;

      setState(() {
        _slipPath = image.path;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เลือกรูปสลิปไม่สำเร็จ กรุณาลองอีกครั้ง')),
      );
    }
  }

  // บันทึกสลิปและเปลี่ยนไปหน้าสถานะการจอง
  Future<void> _submit() async {
    if (_slipPath == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('กรุณาเลือกรูปสลิป')));
      return;
    }

    final bookingId = widget.booking.id;

    if (bookingId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่พบรหัสการจอง กรุณาตรวจสอบรายการอีกครั้ง'),
        ),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      // บันทึกตำแหน่งไฟล์สลิปและอัปเดตสถานะใน SQLite
      await _bookingService.saveSlip(bookingId, _slipPath!);

      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      // ไปหน้าสถานะการจอง
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              BookingStatusScreen(email: widget.booking.customerEmail),
        ),
        (route) => route.isFirst,
      );
    } catch (e, stackTrace) {
      debugPrint('SAVE SLIP ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกสลิปไม่สำเร็จ กรุณาลองอีกครั้ง')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ชำระเงินมัดจำ')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'QR สำหรับสาธิต',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // QR จำลองสำหรับการนำเสนอ ไม่ใช่ QR รับเงินจริง
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

          // แสดงยอดมัดจำ
          Text(
            'ยอดมัดจำ: '
            '${widget.booking.deposit.toStringAsFixed(0)} บาท',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 14),

          // ปุ่มเลือกรูปสลิป
          OutlinedButton.icon(
            onPressed: _saving ? null : _pickSlip,
            icon: const Icon(Icons.upload_file),
            label: const Text('อัปโหลดสลิปจากเครื่อง'),
          ),

          // แสดงตัวอย่างรูปที่เลือก
          if (_slipPath != null) ...[
            const SizedBox(height: 12),

            Image.file(
              File(_slipPath!),
              height: 180,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Text('ไม่สามารถแสดงรูปสลิปได้');
              },
            ),

            TextButton.icon(
              onPressed: _saving
                  ? null
                  : () {
                      setState(() {
                        _slipPath = null;
                      });
                    },
              icon: const Icon(Icons.delete_outline),
              label: const Text('เลือกรูปใหม่'),
            ),
          ],

          const SizedBox(height: 20),

          // ปุ่มส่งสลิป
          ElevatedButton(
            onPressed: _saving ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB85C83),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: _saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('ส่งสลิป (จำลอง)'),
          ),

          const SizedBox(height: 8),

          const Text(
            'การส่งสลิปเป็นเพียงการบันทึกไฟล์ในเครื่อง '
            'แอปไม่ได้ตรวจสอบยอดเงินหรือยืนยันการรับเงินจริง',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
