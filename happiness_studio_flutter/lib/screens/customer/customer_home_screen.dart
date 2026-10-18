import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/nail_design.dart';
import 'nail_design_screen.dart';
import 'booking_status_screen.dart';

class CustomerHomeScreen extends StatelessWidget {
  final AppUser user;
  const CustomerHomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Happiness Studio'),
          actions: [
            IconButton(
              tooltip: 'ออกจากระบบ',
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFFF8DCE8), Color(0xFFFFF2E8)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('สวัสดี, ${user.name} 💗',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('เติมความสุขให้ปลายนิ้วของคุณ'),
                  const SizedBox(height: 14),
                  const Text('ค้นหาลายเล็บที่ใช่ แล้วออกแบบสไตล์ของคุณเอง'),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text('บริการแนะนำ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...NailDesign.samples.take(2).map((nail) => Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFF8DCE8),
                      child: Icon(Icons.spa, color: Color(0xFFB85C83)),
                    ),
                    title: Text(nail.name),
                    subtitle: Text('เริ่มต้น ${nail.startingPrice.toStringAsFixed(0)} บาท'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NailDesignScreen(user: user, initialDesign: nail),
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.palette_outlined),
              label: const Text('ดูลายเล็บทั้งหมด'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NailDesignScreen(user: user)),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              icon: const Icon(Icons.event_note),
              label: const Text('การจองของฉัน'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookingStatusScreen(email: user.email)),
              ),
            ),
          ],
        ),
      );
}
