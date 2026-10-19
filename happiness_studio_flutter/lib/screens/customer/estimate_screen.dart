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

  // แสดงชื่อรายการและราคา
  Widget _priceRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 12),
          Text(
            '${amount.toStringAsFixed(0)} บาท',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // แสดงรายละเอียดแต่ละรายการ
  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 115,
            child: Text(label, style: const TextStyle(color: Colors.black54)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('สรุปรายละเอียดและราคา')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. รายละเอียดบริการที่เลือก
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'บริการที่เลือก',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    design.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB45D83),
                    ),
                  ),

                  const SizedBox(height: 12),

                  _detailRow('ทรงเล็บ', request.nailShape),

                  _detailRow(
                    'ต่อเล็บ PVC',
                    request.usePvc ? 'ต้องการต่อ PVC' : 'ไม่ต่อ PVC',
                  ),

                  _detailRow(
                    'อะไหล่ตกแต่ง',
                    request.accessoryLevel == 'none'
                        ? 'ไม่เพิ่มอะไหล่'
                        : request.accessoryLevel == 'few'
                        ? 'อะไหล่เล็กน้อย'
                        : 'อะไหล่หลายชิ้น',
                  ),

                  // แสดงรายละเอียดเพิ่มเติมเมื่อมีข้อมูล
                  if (request.details.trim().isNotEmpty)
                    _detailRow('รายละเอียดเพิ่มเติม', request.details.trim()),

                  // แจ้งว่าลูกค้าแนบรูป Reference แล้ว
                  if (request.referencePath != null &&
                      request.referencePath!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 18),
                        SizedBox(width: 6),
                        Expanded(child: Text('แนบรูป Reference แล้ว')),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // 2. คำแนะนำสำหรับลูกค้า
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'คำแนะนำสำหรับคุณ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Text(estimate.recommendation),

                  const SizedBox(height: 10),

                  Text(
                    'คำแนะนำเรื่องอะไหล่: '
                    '${estimate.accessorySuggestion}',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // 3. สรุปราคา
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'สรุปราคาโดยประมาณ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // แสดงค่าบริการหลัก
                  _priceRow('ค่าบริการ ${design.name}', estimate.basePrice),

                  // แสดงค่าต่อ PVC เฉพาะเมื่อมีค่าใช้จ่าย
                  if (estimate.pvcPrice > 0)
                    _priceRow('ค่าต่อ PVC', estimate.pvcPrice),

                  // แสดงค่าใช้จ่ายเพิ่มเติมเมื่อมีค่าใช้จ่าย
                  if (estimate.extraPrice > 0)
                    _priceRow('ค่าใช้จ่ายเพิ่มเติม', estimate.extraPrice),

                  // แสดงค่าอะไหล่เมื่อมีค่าใช้จ่าย
                  if (estimate.accessoryPrice > 0)
                    _priceRow('ค่าอะไหล่และของตกแต่ง', estimate.accessoryPrice),

                  const Divider(height: 24),

                  // ราคารวม
                  _priceRow('ราคารวมโดยประมาณ', estimate.total),

                  const Divider(height: 24),

                  // เงินมัดจำ
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'เงินมัดจำเพื่อจองคิว',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '${estimate.deposit.toStringAsFixed(0)} บาท',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB45D83),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ยอดคงเหลือหลังหักเงินมัดจำ
                  Text(
                    'ยอดที่เหลือโดยประมาณ '
                    '${(estimate.total - estimate.deposit).clamp(0, double.infinity).toStringAsFixed(0)} บาท',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 4. หมายเหตุเกี่ยวกับราคา
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'หมายเหตุ: ราคานี้เป็นการประเมินเบื้องต้นจากบริการและตัวเลือกที่ระบุ '
              'ไม่ใช่การวิเคราะห์รูปด้วย AI และยังไม่ได้รับการยืนยันจากช่าง '
              'โดยเฉพาะงานเพ้นท์ลายที่ราคาเริ่มต้น 250 บาท '
              'ราคาอาจเปลี่ยนแปลงตามรายละเอียดของงาน',
              style: TextStyle(fontSize: 12),
            ),
          ),

          const SizedBox(height: 20),

          // 5. ไปหน้าจองวันและเวลา
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(
                      user: user,
                      design: design,
                      request: request,
                      estimate: estimate,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text('เลือกวันและเวลาจอง'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB45D83),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
