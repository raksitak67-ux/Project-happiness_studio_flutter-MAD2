import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/aquth_service.dart';
import '../customer/customer_home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final AppUser? user = await AuthService().login(_email.text, _password.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('อีเมลหรือรหัสผ่านไม่ถูกต้อง')),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => CustomerHomeScreen(user: user)),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.spa, size: 64, color: Color(0xFFB85C83)),
                    const SizedBox(height: 12),
                    const Text('Happiness Studio',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const Text('Your little moment of beauty',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'อีเมล'),
                      validator: (v) => v == null || !v.contains('@')
                          ? 'กรุณากรอกอีเมลให้ถูกต้อง'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'รหัสผ่าน'),
                      validator: (v) => v == null || v.isEmpty
                          ? 'กรุณากรอกรหัสผ่าน'
                          : null,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: _busy ? null : _login,
                      child: Text(_busy ? 'กำลังเข้าสู่ระบบ...' : 'เข้าสู่ระบบ'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      ),
                      child: const Text('ยังไม่มีบัญชี? สมัครสมาชิก'),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'เวอร์ชันสาธิต: บัญชีถูกเก็บไว้ในอุปกรณ์นี้',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
