import 'package:flutter/material.dart';
import '../../models/nail_design.dart';
import '../../models/user.dart';
import 'reference_screen.dart';

class NailDesignScreen extends StatelessWidget {
  final AppUser user;
  final NailDesign? initialDesign;
  const NailDesignScreen({super.key, required this.user, this.initialDesign});

  @override
  Widget build(BuildContext context) {
    final designs = initialDesign == null ? NailDesign.samples : [initialDesign!];
    return Scaffold(
      appBar: AppBar(title: const Text('บริการและลายเล็บ')),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: designs.length,
        itemBuilder: (context, index) {
          final nail = designs[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  nail.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: const Color(0xFFF8DCE8),
                    child: const Center(child: Icon(Icons.image_not_supported, size: 48)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nail.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(nail.description),
                      const SizedBox(height: 8),
                      Text('เริ่มต้น ${nail.startingPrice.toStringAsFixed(0)} บาท • ${nail.durationMinutes} นาที'),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReferenceScreen(user: user, design: nail),
                            ),
                          ),
                          child: const Text('เลือกแบบนี้'),
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
    );
  }
}
