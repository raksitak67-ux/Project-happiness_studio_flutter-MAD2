import 'package:flutter/material.dart';

import '../../models/nail_design.dart';
import '../../models/user.dart';
import 'reference_screen.dart';

class NailDesignScreen extends StatefulWidget {
  final AppUser user;
  final NailDesign? initialDesign;

  const NailDesignScreen({super.key, required this.user, this.initialDesign});

  @override
  State<NailDesignScreen> createState() => _NailDesignScreenState();
}

class _NailDesignScreenState extends State<NailDesignScreen> {
  static const Color pink = Color(0xFFB45D83);
  static const Color darkPink = Color(0xFF75405A);
  static const Color background = Color(0xFFFFF8FB);

  String selectedStyle = 'ทั้งหมด';

  @override
  Widget build(BuildContext context) {
    final allDesigns = widget.initialDesign == null
        ? NailDesign.samples
        : [widget.initialDesign!];

    final styles = [
      'ทั้งหมด',
      ...allDesigns.map((design) => design.style).toSet(),
    ];

    final filteredDesigns = selectedStyle == 'ทั้งหมด'
        ? allDesigns
        : allDesigns.where((design) => design.style == selectedStyle).toList();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'บริการและลายเล็บ',
          style: TextStyle(color: darkPink, fontWeight: FontWeight.bold),
        ),
        backgroundColor: background,
        foregroundColor: darkPink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // หัวข้อหน้า
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ค้นหาลายเล็บในสไตล์ที่ชอบ 💗',
                style: TextStyle(
                  color: darkPink,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // ตัวกรองตามแนวลายเล็บ
          SizedBox(
            height: 54,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: styles.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final style = styles[index];
                final isSelected = selectedStyle == style;

                return ChoiceChip(
                  label: Text(style),
                  selected: isSelected,
                  selectedColor: pink,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : darkPink,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(
                    color: isSelected ? pink : const Color(0xFFE8B8CC),
                  ),
                  onSelected: (_) {
                    setState(() {
                      selectedStyle = style;
                    });
                  },
                );
              },
            ),
          ),

          // จำนวนลายเล็บ
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'พบ ${filteredDesigns.length} ลายเล็บ',
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ),
          ),

          // รายการลายเล็บ
          Expanded(
            child: filteredDesigns.isEmpty
                ? const Center(child: Text('ไม่พบลายเล็บในหมวดหมู่นี้'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                    itemCount: filteredDesigns.length,
                    itemBuilder: (context, index) {
                      final nail = filteredDesigns[index];

                      return Card(
                        color: Colors.white,
                        clipBehavior: Clip.antiAlias,
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Color(0xFFF1DDE6)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // รูปภาพลายเล็บ
                            Image.network(
                              nail.imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: const Color(0xFFFFEAF2),
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: pink,
                                    size: 48,
                                  ),
                                );
                              },
                            ),

                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ชื่อและหมวดหมู่
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          nail.name,
                                          style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: darkPink,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFEEF4),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          nail.style,
                                          style: const TextStyle(
                                            color: pink,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    nail.description,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      height: 1.5,
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // ราคาและระยะเวลา
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.payments_outlined,
                                        color: pink,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${nail.price.toStringAsFixed(0)} บาท',
                                        style: const TextStyle(
                                          color: darkPink,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.access_time,
                                        color: pink,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${nail.durationMinutes} นาที',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // เลือกลายเพื่อไปหน้าจองเดิม
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ReferenceScreen(
                                              user: widget.user,
                                              design: nail,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.calendar_month_outlined,
                                      ),
                                      label: const Text('เลือกแบบนี้'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: pink,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
