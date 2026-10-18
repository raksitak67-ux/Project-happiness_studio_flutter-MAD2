import 'dart:io';
import 'package:flutter/material.dart';

/// แสดงรูป Reference ที่ลูกค้าเลือกจากอุปกรณ์
class ReferenceImage extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onPick;
  final double height;

  const ReferenceImage({
    super.key,
    required this.imagePath,
    this.onPick,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: onPick,
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: Text(hasImage ? 'เปลี่ยนรูป Reference' : 'เลือกรูป Reference จากเครื่อง'),
        ),
        if (hasImage) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              File(imagePath!),
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: height,
                color: const Color(0xFFF8DCE8),
                alignment: Alignment.center,
                child: const Text('ไม่สามารถแสดงรูปนี้ได้'),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
