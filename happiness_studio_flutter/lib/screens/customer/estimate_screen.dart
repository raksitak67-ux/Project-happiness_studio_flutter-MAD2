import 'package:flutter/material.dart';
import '../../models/nail_design.dart';
import '../../models/nail_request.dart';
import '../../models/price_estimate.dart';
import '../../models/user.dart';
import 'booking_screen.dart';

class EstimateScreen extends StatelessWidget {
  final AppUser user;
  final NailDesign design;
  final NailRequest request;
  final PriceEstimate estimate;

  const EstimateScreen({
    super.key,
    required this.user,
    required this.design,
    required this.request,
    required this.estimate,
  });

  Widget _line(String label, double amount) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Text('${amount.toStringAsFixed(0)} บาท'),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('คำแนะนำและราคา')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('คำแนะนำสำหรับคุณ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(estimate.recommendation),
                    const SizedBox(height: 10),
                    Text('อะไหล่ที่แนะนำ: ${estimate.accessorySuggestion}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _line('ราคาเริ่มต้น (${design.name})', estimate.basePrice),
                    _line('ค่าต่อ PVC', estimate.pvcPrice),
                    _line('ค่าใช้จ่ายเพิ่มเติม', estimate.extraPrice),
                    _line('ค่าอะไหล่/ของตกแต่ง', estimate.accessoryPrice),
                    const Divider(),
                    _line('ราคารวมโดยประมาณ', estimate.total),
                    _line('มัดจำ 30%', estimate.deposit),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'หมายเหตุ: เป็นราคาจำลองจากเงื่อนไขในแอป ไม่ใช่การประเมินจากช่างจริง และยังไม่ใช่ยอดชำระเงินจริง',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingScreen(
                    user: user,
                    design: design,
                    request: request,
                    estimate: estimate,
                  ),
                ),
              ),
              child: const Text('เลือกวันและเวลาจอง'),
            ),
          ],
        ),
      );
}
