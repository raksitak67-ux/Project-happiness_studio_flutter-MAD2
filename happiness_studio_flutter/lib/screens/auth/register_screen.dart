import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final error = await AuthService().register(
      name: _name.text,
      email: _email.text,
      password: _password.text,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('สมัครสมาชิกสำเร็จ กรุณาเข้าสู่ระบบ')),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('สมัครสมาชิก')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'ชื่อที่ใช้แสดง'),
                validator: (v) => v == null || v.trim().isEmpty ? 'กรุณากรอกชื่อ' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'อีเมล'),
                validator: (v) => v == null || !v.contains('@') ? 'อีเมลไม่ถูกต้อง' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'รหัสผ่าน'),
                validator: (v) => v == null || v.length < 4 ? 'รหัสผ่านอย่างน้อย 4 ตัวอักษร' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _busy ? null : _register,
                child: Text(_busy ? 'กำลังสมัคร...' : 'สมัครสมาชิก'),
              ),
            ],
          ),
        ),
      );
}
