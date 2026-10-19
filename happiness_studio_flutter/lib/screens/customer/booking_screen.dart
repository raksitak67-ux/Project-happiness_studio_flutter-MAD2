import 'package:flutter/material.dart';

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
  final BookingService _bookingService = BookingService();

  DateTime? _selectedDate;
  String? _selectedTime;

  List<String> _bookedTimes = [];

  bool _loadingTimes = false;
  bool _saving = false;
  String? _errorMessage;

  final List<String> _timeSlots = ['10:00', '11:30', '13:00', '14:30', '16:00'];

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  String _displayDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Future<void> _pickDate() async {
    final now = DateUtils.dateOnly(DateTime.now());
    final firstDate = now.add(const Duration(days: 1));
    final lastDate = now.add(const Duration(days: 30));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'เลือกวันที่ต้องการจอง',
      cancelText: 'ยกเลิก',
      confirmText: 'เลือกวันที่',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFD96C96),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF3D2932),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      _selectedDate = pickedDate;
      _selectedTime = null;
      _bookedTimes = [];
      _loadingTimes = true;
      _errorMessage = null;
    });

    try {
      final times = await _bookingService.bookedTimes(_formatDate(pickedDate));

      if (!mounted) return;

      setState(() {
        _bookedTimes = times;
        _loadingTimes = false;
      });
    } catch (e, stackTrace) {
      debugPrint('LOAD BOOKED TIMES ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _loadingTimes = false;
        _errorMessage = 'โหลดเวลาที่ว่างไม่สำเร็จ กรุณาลองอีกครั้ง';
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ตรวจสอบคิวไม่สำเร็จ: $e')));
    }
  }

  Future<void> _confirmBooking() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเลือกวันที่และเวลาก่อน')),
      );
      return;
    }

    if (_loadingTimes || _errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาตรวจสอบคิวว่างอีกครั้ง')),
      );
      return;
    }

    if (_bookedTimes.contains(_selectedTime)) {
      setState(() {
        _selectedTime = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เวลานี้มีคนจองแล้ว กรุณาเลือกเวลาใหม่')),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      // ตรวจสอบคิวล่าสุดก่อนบันทึก
      final latestBookedTimes = await _bookingService.bookedTimes(
        _formatDate(_selectedDate!),
      );

      if (!mounted) return;

      if (latestBookedTimes.contains(_selectedTime)) {
        setState(() {
          _bookedTimes = latestBookedTimes;
          _selectedTime = null;
          _saving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('คิวนี้ถูกจองไปแล้ว กรุณาเลือกเวลาอื่น'),
          ),
        );
        return;
      }

      // สร้างข้อมูลการจอง
      final booking = Booking(
        customerEmail: widget.user.email.toLowerCase(),
        designName: widget.design.name,
        date: _formatDate(_selectedDate!),
        time: _selectedTime!,
        totalPrice: widget.estimate.total,
        deposit: widget.estimate.deposit,
        status: 'รอส่งสลิปมัดจำ (สาธิต)',
        referencePath: widget.request.referencePath,
        createdAt: DateTime.now().toIso8601String(),
        nailShape: widget.request.nailShape,
        usePvc: widget.request.usePvc,
        accessoryLevel: widget.request.accessoryLevel,
        details: widget.request.details,
      );

      debugPrint('BOOKING: เริ่มบันทึกข้อมูล');
      debugPrint('BOOKING DATE: ${booking.date}');
      debugPrint('BOOKING TIME: ${booking.time}');
      debugPrint('BOOKING EMAIL: ${booking.customerEmail}');

      // บันทึกลง SQLite
      final bookingId = await _bookingService.create(booking);

      debugPrint('BOOKING SUCCESS: id=$bookingId');

      if (!mounted) return;

      // สร้างข้อมูลการจองที่มี ID
      final savedBooking = Booking(
        id: bookingId,
        customerEmail: booking.customerEmail,
        designName: booking.designName,
        date: booking.date,
        time: booking.time,
        totalPrice: booking.totalPrice,
        deposit: booking.deposit,
        status: booking.status,
        referencePath: booking.referencePath,
        slipPath: booking.slipPath,
        refundStatus: booking.refundStatus,
        createdAt: booking.createdAt,
        nailShape: booking.nailShape,
        usePvc: booking.usePvc,
        accessoryLevel: booking.accessoryLevel,
        details: booking.details,
      );

      setState(() {
        _saving = false;
      });

      // ไปหน้าชำระเงิน
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PaymentScreen(booking: savedBooking)),
      );
    } catch (e, stackTrace) {
      // แสดงสาเหตุจริงใน Terminal
      debugPrint('BOOKING ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('บันทึกการจองไม่สำเร็จ: $e'),
          duration: const Duration(seconds: 10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDateText = _selectedDate == null
        ? 'ยังไม่ได้เลือกวันที่'
        : _displayDate(_selectedDate!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกวันและเวลาจอง'),
        backgroundColor: const Color(0xFFF8DCE8),
        foregroundColor: const Color(0xFF593747),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'สรุปรายการจอง',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _summaryRow('แบบเล็บ', widget.design.name),
                    _summaryRow('ทรงเล็บ', widget.request.nailShape),
                    _summaryRow(
                      'ต่อ PVC',
                      widget.request.usePvc ? 'ใช่' : 'ไม่ต่อ',
                    ),
                    _summaryRow(
                      'ระดับอะไหล่',
                      _accessoryText(widget.request.accessoryLevel),
                    ),
                    if (widget.request.details.trim().isNotEmpty)
                      _summaryRow(
                        'รายละเอียดเพิ่มเติม',
                        widget.request.details,
                      ),
                    const Divider(height: 24),
                    _summaryRow(
                      'ราคาประเมิน',
                      '${widget.estimate.total.toStringAsFixed(0)} บาท',
                    ),
                    _summaryRow(
                      'มัดจำ',
                      '${widget.estimate.deposit.toStringAsFixed(0)} บาท',
                    ),
                    _summaryRow(
                      'ส่วนที่เหลือ',
                      '${(widget.estimate.total - widget.estimate.deposit).toStringAsFixed(0)} บาท',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '1. เลือกวันที่',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _saving ? null : _pickDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(selectedDateText),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                foregroundColor: const Color(0xFFD96C96),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '2. เลือกเวลา',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'เวลาที่แสดงเป็นช่วงเวลาสำหรับนัดหมาย',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            if (_selectedDate == null)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('กรุณาเลือกวันที่ก่อน'),
                ),
              )
            else if (_loadingTimes)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_errorMessage != null)
              Column(
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _saving ? null : _pickDate,
                    child: const Text('ลองตรวจสอบอีกครั้ง'),
                  ),
                ],
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _timeSlots.map((time) {
                  final isBooked = _bookedTimes.contains(time);
                  final isSelected = _selectedTime == time;

                  return ChoiceChip(
                    label: Text(isBooked ? '$time (เต็ม)' : time),
                    selected: isSelected,
                    onSelected: isBooked || _saving
                        ? null
                        : (selected) {
                            setState(() {
                              _selectedTime = selected ? time : null;
                            });
                          },
                    selectedColor: const Color(0xFFF3B7CE),
                    disabledColor: const Color(0xFFEEEEEE),
                    labelStyle: TextStyle(
                      color: isBooked
                          ? Colors.grey
                          : isSelected
                          ? const Color(0xFF593747)
                          : Colors.black87,
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _saving ||
                        _loadingTimes ||
                        _selectedDate == null ||
                        _selectedTime == null ||
                        _errorMessage != null
                    ? null
                    : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD96C96),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                    : const Text(
                        'ยืนยันการจอง',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'หมายเหตุ: ราคานี้เป็นราคาประเมินเบื้องต้น '
              'การจองยังเป็นข้อมูลภายในเครื่อง '
              'ร้านต้องยืนยันคิวและรายละเอียดอีกครั้ง',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(title, style: const TextStyle(color: Colors.black54)),
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
}
