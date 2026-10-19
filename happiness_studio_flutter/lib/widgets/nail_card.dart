
import 'package:flutter/material.dart';
import '../models/nail_design.dart';

/// การ์ดแสดงรายละเอียดลายเล็บในรายการบริการ
class NailCard extends StatelessWidget {
  final NailDesign design;
  final VoidCallback? onTap;
  final String actionLabel;

  const NailCard({
    super.key,
    required this.design,
    this.onTap,
    this.actionLabel = 'เลือกแบบนี้',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // แสดงรูปภาพลายเล็บจาก assets/images/
          Image.asset(
            design.imagePath,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 180,
                color: const Color(0xFFF8DCE8),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
              );
            },
          ),

          // แสดงรายละเอียดลายเล็บ
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  design.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),

                Text(
                  design.description,
                ),
                const SizedBox(height: 8),

                Text(
                  'ราคา ${design.price.toStringAsFixed(0)} บาท '
                  '• ${design.durationMinutes} นาที',
                ),
                const SizedBox(height: 12),

                // แสดงปุ่มเฉพาะเมื่อมีการกำหนด onTap
                if (onTap != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      child: Text(actionLabel),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
