import 'package:flutter/material.dart';

import '../../models/nail_design.dart';
import '../../models/user.dart';
import 'nail_design_screen.dart';
import 'reference_screen.dart';
import 'customer_profile_screen.dart';

class CustomerHomeScreen extends StatelessWidget {
  final AppUser user;

  const CustomerHomeScreen({super.key, required this.user});

  static const Color pink = Color(0xFFB45D83);
  static const Color darkPink = Color(0xFF75405A);
  static const Color background = Color(0xFFFFF8FB);

  @override
  Widget build(BuildContext context) {
    final recommendedDesigns = NailDesign.samples.take(2).toList();

    return Scaffold(
      backgroundColor: background,

      // แถบด้านบนของหน้าหลัก
      appBar: AppBar(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Row(
          children: [
            Icon(Icons.spa_outlined, color: pink, size: 28),
            SizedBox(width: 8),
            Text(
              'Happiness Studio',
              style: TextStyle(
                color: darkPink,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
          ],
        ),

        // ปุ่มโปรไฟล์มุมขวาบน
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: IconButton(
              tooltip: 'โปรไฟล์ของฉัน',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CustomerProfileScreen(user: user),
                  ),
                );
              },
              icon: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8DCE8),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE8B8CC),
                    width: 1.5,
                  ),
                ),
                child: const Icon(Icons.person_rounded, color: pink, size: 25),
              ),
            ),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          // การ์ดต้อนรับลูกค้า
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFEAF2), Color(0xFFF7D5E3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to',
                  style: TextStyle(color: darkPink, fontSize: 15),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Happiness Studio ♡',
                  style: TextStyle(
                    color: darkPink,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'สวัสดีคุณ ${user.name} 💗',
                  style: const TextStyle(
                    color: darkPink,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'เติมความน่ารักให้ปลายนิ้วของคุณ '
                  'ด้วยลายเล็บที่ใช่ในสไตล์ของตัวเอง',
                  style: TextStyle(color: darkPink, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 18),

                // ปุ่มจองคิวทำเล็บ
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReferenceScreen(user: user),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: const Text('จองคิวทำเล็บ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // หัวข้อลายเล็บแนะนำ พร้อมปุ่มดูทั้งหมด
          Row(
            children: [
              const Expanded(
                child: Text(
                  'ลายเล็บแนะนำ ✨',
                  style: TextStyle(
                    color: darkPink,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NailDesignScreen(user: user),
                    ),
                  );
                },
                child: const Text(
                  'ดูทั้งหมด',
                  style: TextStyle(color: pink, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // แสดงลายเล็บแนะนำ 2 รายการ
          if (recommendedDesigns.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(
                child: Text(
                  'ยังไม่มีลายเล็บแนะนำ',
                  style: TextStyle(color: darkPink),
                ),
              ),
            )
          else
            ...recommendedDesigns.map((nail) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFF1DDE6)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEF4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: pink,
                      size: 26,
                    ),
                  ),
                  title: Text(
                    nail.name,
                    style: const TextStyle(
                      color: darkPink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      'เลือกชมรายละเอียดและจองลายเล็บนี้',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: pink),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            NailDesignScreen(user: user, initialDesign: nail),
                      ),
                    );
                  },
                ),
              );
            }),
        ],
      ),
    );
  }
}
