import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_time_db_firebase/utils/utils.dart';
import 'package:real_time_db_firebase/widgets/round_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    
    _emailController.dispose();
    super.dispose();
  }


  void _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      Utils.showToast('Please enter your email address');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      Utils.showToast(
          'We have sent you an email to recover your password. Please check your inbox.');
    } catch (error) {
      Utils.showToast(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 40),
            RoundButton(
              title: 'Reset Password',
              onTap: _resetPassword,
            ),
          ],
        ),
      ),
    );
  }
}
