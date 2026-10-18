import 'package:flutter/material.dart';
import '../models/booking.dart';
import 'status_badge.dart';

/// การ์ดสรุปข้อมูลการจองของลูกค้า
class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onUploadSlip;
  final VoidCallback? onCancel;

  const BookingCard({
    super.key,
    required this.booking,
    this.onUploadSlip,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isCancelled = booking.status == 'ยกเลิกแล้ว';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    booking.designName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                StatusBadge(status: booking.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('วันที่ ${booking.date} เวลา ${booking.time}'),
            const SizedBox(height: 4),
            Text('ยอดรวม ${booking.totalPrice.toStringAsFixed(0)} บาท'),
            Text('มัดจำ ${booking.deposit.toStringAsFixed(0)} บาท'),
            if (booking.refundStatus != 'ไม่เกี่ยวข้อง') ...[
              const SizedBox(height: 4),
              Text('สถานะมัดจำ: ${booking.refundStatus}'),
            ],
            if (!isCancelled && (onUploadSlip != null || onCancel != null)) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  if (onUploadSlip != null)
                    OutlinedButton(onPressed: onUploadSlip, child: const Text('แนบสลิป')),
                  if (onCancel != null)
                    TextButton(onPressed: onCancel, child: const Text('ยกเลิกการจอง')),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
