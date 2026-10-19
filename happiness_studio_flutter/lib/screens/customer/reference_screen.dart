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
  final NailDesign? design;

  const ReferenceScreen({super.key, required this.user, this.design});

  @override
  State<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _detailsController = TextEditingController();

  String? _referencePath;
  String _nailShape = 'Almond';
  String _accessoryLevel = 'none';
  String _service = 'plain';
  bool _usePvc = false;

  final Map<String, Map<String, dynamic>> _services = {
    'plain': {
      'name': 'ทาสีพื้น',
      'price': 150.0,
      'duration': 60,
      'style': 'เรียบง่าย',
    },
    'syrup': {
      'name': 'ทาสีไซรัป',
      'price': 199.0,
      'duration': 60,
      'style': 'หวานละมุน',
    },
    'cat_eye': {
      'name': 'ทาสีลูกแก้ว',
      'price': 299.0,
      'duration': 75,
      'style': 'ประกายมิติ',
    },
    'flash': {
      'name': 'ทาสีแฟลช',
      'price': 279.0,
      'duration': 60,
      'style': 'แวววาว',
    },
    'pvc': {
      'name': 'ต่อเล็บ PVC เว้นโคน',
      'price': 350.0,
      'duration': 90,
      'style': 'ต่อเล็บ',
    },
    'art': {
      'name': 'เพ้นท์ลาย',
      'price': 250.0,
      'duration': 90,
      'style': 'ตาม Reference',
    },
  };

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (!mounted || image == null) return;

      setState(() {
        _referencePath = image.path;
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เลือกรูปไม่สำเร็จ กรุณาลองอีกครั้ง')),
      );
    }
  }

  bool get _isPvcService => widget.design == null && _service == 'pvc';

  double get _basePrice {
    if (widget.design != null) {
      return widget.design!.price;
    }
    return _services[_service]!['price'] as double;
  }

  String get _serviceName {
    if (widget.design != null) {
      return widget.design!.name;
    }
    return _services[_service]!['name'] as String;
  }

  int get _duration {
    if (widget.design != null) {
      return widget.design!.durationMinutes;
    }
    return _services[_service]!['duration'] as int;
  }

  String get _style {
    if (widget.design != null) {
      return widget.design!.style;
    }
    return _services[_service]!['style'] as String;
  }

  double get _pvcPrice {
    if (_isPvcService) return 0;
    return _usePvc ? 200.0 : 0.0;
  }

  double get _accessoryPrice {
    switch (_accessoryLevel) {
      case 'few':
        return 50.0;
      case 'many':
        return 100.0;
      default:
        return 0.0;
    }
  }

  double get _totalPrice => _basePrice + _pvcPrice + _accessoryPrice;

  void _selectService(String? value) {
    if (value == null) return;

    setState(() {
      _service = value;

      // บริการต่อ PVC ราคา 350 บาทรวมการต่อไว้แล้ว
      if (_isPvcService) {
        _usePvc = false;
      }
    });
  }

  void _selectAccessory(String? value) {
    if (value == null) return;

    setState(() {
      _accessoryLevel = value;
    });
  }

  void _continueToEstimate() {
    final design =
        widget.design ??
        NailDesign(
          id: 'custom_$_service',
          name: _serviceName,
          description: 'บริการที่ลูกค้าเลือกเอง',
          price: _basePrice,
          durationMinutes: _duration,
          style: _style,
          imageUrl: '',
        );

    final request = NailRequest(
      nailDesignId: design.id,
      nailShape: _nailShape,
      usePvc: _isPvcService || _usePvc,
      details: _detailsController.text.trim(),
      referencePath: _referencePath,
      accessoryLevel: _accessoryLevel,
    );

    final estimate = PriceEstimate.calculate(
      basePrice: _basePrice,
      usePvc: _usePvc && !_isPvcService,
      nailShape: _nailShape,
      style: _style,
      details: _detailsController.text.trim(),
      accessoryLevel: _accessoryLevel,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EstimateScreen(
          user: widget.user,
          design: design,
          request: request,
          estimate: estimate,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _serviceOption(String value, String title, String subtitle) {
    return RadioListTile<String>(
      value: value,
      title: Text(title),
      subtitle: Text(subtitle),
      activeColor: const Color(0xFFB45D83),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _accessoryOption(String value, String title, String subtitle) {
    return RadioListTile<String>(
      value: value,
      title: Text(title),
      subtitle: Text(subtitle),
      activeColor: const Color(0xFFB45D83),
      contentPadding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ส่ง Reference และรายละเอียด'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'ย้อนกลับ',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'ส่งรูปแบบเล็บที่ต้องการ หรือเลือกบริการของร้านได้เลย',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 12),

          // 1. เลือกรูป Reference
          _sectionTitle('1. รูป Reference (ไม่บังคับ)'),

          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('เลือกรูปจากแกลเลอรี'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),

          if (_referencePath != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_referencePath!),
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('ไม่สามารถแสดงรูปได้'),
                  );
                },
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _referencePath = null;
                });
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('นำรูปออก'),
            ),
          ],

          const SizedBox(height: 12),

          // 2. เลือกบริการของร้าน
          if (widget.design == null) ...[
            _sectionTitle('2. เลือกบริการ'),

            RadioGroup<String>(
              groupValue: _service,
              onChanged: _selectService,
              child: Column(
                children: [
                  ..._services.entries.map((entry) {
                    final service = entry.value;
                    final price = service['price'] as double;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: _serviceOption(
                        entry.key,
                        service['name'] as String,
                        entry.key == 'art'
                            ? 'เริ่มต้น ${price.toStringAsFixed(0)} บาท'
                            : '${price.toStringAsFixed(0)} บาท',
                      ),
                    );
                  }),
                ],
              ),
            ),
          ] else ...[
            _sectionTitle('2. ลายเล็บที่เลือก'),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: Color(0xFFB45D83),
                ),
                title: Text(widget.design!.name),
                subtitle: Text(
                  '${widget.design!.price.toStringAsFixed(0)} บาท',
                ),
              ),
            ),
          ],

          // 3. เลือกทรงเล็บ
          _sectionTitle('3. เลือกทรงเล็บ'),

          DropdownButtonFormField<String>(
            initialValue: _nailShape,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'ทรงเล็บ',
            ),
            items: const [
              DropdownMenuItem(
                value: 'Almond',
                child: Text('Almond (อัลมอนด์)'),
              ),
              DropdownMenuItem(
                value: 'Square',
                child: Text('Square (เหลี่ยม)'),
              ),
              DropdownMenuItem(value: 'Round', child: Text('Round (มน)')),
              DropdownMenuItem(value: 'Coffin', child: Text('Coffin (คอฟฟิน)')),
              DropdownMenuItem(value: 'Oval', child: Text('Oval (วงรี)')),
            ],
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _nailShape = value;
              });
            },
          ),

          // เลือกต่อ PVC เพิ่มเติม
          if (!_isPvcService) ...[
            const SizedBox(height: 12),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _usePvc,
              activeColor: const Color(0xFFB45D83),
              title: const Text('ต้องการต่อเล็บ PVC'),
              subtitle: const Text('เพิ่ม 200 บาท'),
              onChanged: (value) {
                setState(() {
                  _usePvc = value ?? false;
                });
              },
            ),
          ],

          // 4. เลือกอะไหล่ตกแต่ง
          _sectionTitle('4. เลือกอะไหล่ตกแต่ง'),

          RadioGroup<String>(
            groupValue: _accessoryLevel,
            onChanged: _selectAccessory,
            child: Column(
              children: [
                _accessoryOption('none', 'ไม่เพิ่มอะไหล่', 'เพิ่ม 0 บาท'),
                _accessoryOption('few', 'อะไหล่เล็กน้อย', 'เพิ่ม 50 บาท'),
                _accessoryOption('many', 'อะไหล่หลายชิ้น', 'เพิ่ม 100 บาท'),
              ],
            ),
          ),

          // 5. รายละเอียดเพิ่มเติม
          _sectionTitle('5. รายละเอียดเพิ่มเติม (ไม่บังคับ)'),

          TextField(
            controller: _detailsController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText:
                  'เช่น อยากได้โทนชมพูอ่อน ขอแบบเรียบ ๆ '
                  'หรือรายละเอียดอื่นที่ต้องการ',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 18),

          // แสดงราคาโดยประมาณ
          Card(
            color: const Color(0xFFFFF4F8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ราคาโดยประมาณ',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('ค่าบริการ: ${_basePrice.toStringAsFixed(0)} บาท'),
                  Text('ค่าต่อ PVC: ${_pvcPrice.toStringAsFixed(0)} บาท'),
                  Text('ค่าอะไหล่: ${_accessoryPrice.toStringAsFixed(0)} บาท'),
                  const Divider(),
                  Text(
                    'รวมประมาณ ${_totalPrice.toStringAsFixed(0)} บาท',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB45D83),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'มัดจำ 100 บาท ราคาจริงอาจเปลี่ยนตามรายละเอียดงาน',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ไปหน้าสรุปราคา
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _continueToEstimate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB45D83),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('ตรวจสอบราคาและดำเนินการต่อ'),
            ),
          ),
        ],
      ),
    );
  }
}
