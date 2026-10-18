import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/nail_design.dart';
import '../../models/nail_request.dart';
import '../../models/price_estimate.dart';
import '../../models/user.dart';
import 'estimate_screen.dart';

class ReferenceScreen extends StatefulWidget {
  final AppUser user;
  final NailDesign design;
  const ReferenceScreen({super.key, required this.user, required this.design});

  @override
  State<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  final _details = TextEditingController();
  String _shape = 'Almond';
  bool _pvc = false;
  String? _referencePath;

  Future<void> _pickReference() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null && mounted) setState(() => _referencePath = image.path);
  }

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('รายละเอียดและ Reference')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(widget.design.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _shape,
              decoration: const InputDecoration(labelText: 'ทรงเล็บ'),
              items: const ['Almond', 'Square', 'Round', 'Coffin', 'Oval']
                  .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => _shape = v ?? 'Almond'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('ต้องการต่อเล็บ PVC'),
              value: _pvc,
              onChanged: (v) => setState(() => _pvc = v),
            ),
            TextField(
              controller: _details,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'รายละเอียดเพิ่มเติม',
                hintText: 'เช่น ขอเปลี่ยนสีหรือเพิ่มลายเล็กน้อย',
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _pickReference,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('เลือกรูป Reference จากเครื่อง'),
            ),
            if (_referencePath != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(File(_referencePath!), height: 180, fit: BoxFit.cover),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final request = NailRequest(
                  nailDesignId: widget.design.id,
                  nailShape: _shape,
                  usePvc: _pvc,
                  details: _details.text,
                  referencePath: _referencePath,
                );
                final estimate = PriceEstimate.calculate(
                  basePrice: widget.design.startingPrice,
                  usePvc: _pvc,
                  nailShape: _shape,
                  style: widget.design.style,
                  details: _details.text,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EstimateScreen(
                      user: widget.user,
                      design: widget.design,
                      request: request,
                      estimate: estimate,
                    ),
                  ),
                );
              },
              child: const Text('ดูคำแนะนำและประเมินราคา'),
            ),
          ],
        ),
      );
}
