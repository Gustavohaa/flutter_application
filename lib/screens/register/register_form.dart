import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../database/app_database.dart';

class RegisterForm extends StatefulWidget {
  final AppDatabase db;
  const RegisterForm({required this.db});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? error;

  void register() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await widget.db.createUser(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      Navigator.pop(context);
    } catch (_) {
      setState(() => error = "Email já cadastrado.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset('assets/icon/imgLoginScreen.png', height: 100),
            ),
            const SizedBox(height: 16),
            Text(
              'Crie sua conta',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            if (error != null) ...[
              Text(error!, style: const TextStyle(color: Colors.redAccent)),
              const SizedBox(height: 12),
            ],
            _buildField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email,
              validator: (v) => v != null && v.contains('@') ? null : 'Email inválido',
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: passwordController,
              label: 'Senha',
              icon: Icons.lock,
              obscure: true,
              validator: (v) => v != null && v.length >= 6 ? null : 'Mínimo 6 caracteres',
            ),
            const SizedBox(height: 24),
          
            _buildButton('Registrar', register),
            const SizedBox(height: 12),
            _buildButton('Voltar ao login', () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,            
          foregroundColor: const Color(0xFF0D47A1),  
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
