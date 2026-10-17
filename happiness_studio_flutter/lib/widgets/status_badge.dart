import 'package:flutter/material.dart';

/// ป้ายสถานะการจอง เช่น รอชำระมัดจำ หรือยกเลิกแล้ว
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color get _backgroundColor {
    if (status.contains('ยกเลิก')) return const Color(0xFFFFE4E4);
    if (status.contains('ยืนยัน') || status.contains('สำเร็จ')) {
      return const Color(0xFFE0F3E5);
    }
    if (status.contains('รอ')) return const Color(0xFFFFF0D6);
    return const Color(0xFFF3E4ED);
  }

  Color get _textColor {
    if (status.contains('ยกเลิก')) return const Color(0xFF9D3030);
    if (status.contains('ยืนยัน') || status.contains('สำเร็จ')) {
      return const Color(0xFF27663A);
    }
    if (status.contains('รอ')) return const Color(0xFF8A5A00);
    return const Color(0xFF8B4564);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
