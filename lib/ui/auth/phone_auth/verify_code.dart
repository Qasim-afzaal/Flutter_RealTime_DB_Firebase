import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_time_db_firebase/utils/utils.dart';
import '../../../widgets/round_button.dart';
import '../../firebase_database/post_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final TextEditingController verificationCodeController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Code')),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter 6-digit code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 50),
            RoundButton(
              title: 'Verify',
              loading: loading,
              onTap: () async {
                if (verificationCodeController.text.trim().length != 6) {
                  Utils.showToast('Enter a valid 6-digit code');
                  return;
                }

                setState(() => loading = true);
                final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: verificationCodeController.text.trim(),
                );

                try {
                  await auth.signInWithCredential(credential);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PostScreen()),
                  );
                } on FirebaseAuthException catch (e) {
                  Utils.showToast(e.message ?? 'Verification failed');
                } catch (e) {
                  Utils.showToast('An unexpected error occurred');
                } finally {
                  setState(() => loading = false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
