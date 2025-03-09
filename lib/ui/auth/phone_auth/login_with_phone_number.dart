import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_time_db_firebase/ui/auth/phone_auth/verify_code.dart';
import 'package:real_time_db_firebase/utils/utils.dart';
import 'package:real_time_db_firebase/widgets/round_button.dart';


class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String? validatePhoneNumber(String value) {
    if (value.isEmpty || !RegExp(r'^\+[1-9]\d{1,14}$').hasMatch(value)) {
      return 'Enter a valid phone number with country code';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Phone'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '+1 234 567 890',
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validatePhoneNumber(value!),
              ),
            ),
            const SizedBox(height: 80),
            loading
                ? const CircularProgressIndicator()
                : RoundButton(
                    title: 'Login',
                    loading: loading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        auth.verifyPhoneNumber(
                          phoneNumber: phoneNumberController.text,
                          verificationCompleted: (_) {
                            setState(() {
                              loading = false;
                            });
                          },
                          verificationFailed: (e) {
                            setState(() {
                              loading = false;
                            });
                            String errorMessage = e.code == 'invalid-phone-number'
                                ? 'The phone number entered is invalid.'
                                : 'Verification failed. Please try again later.';
                            Utils.showToast(errorMessage);
                          },
                          codeSent: (String verificationId, int? token) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifyCodeScreen(
                                    verificationId: verificationId),
                              ),
                            );
                            setState(() {
                              loading = false;
                            });
                          },
                          codeAutoRetrievalTimeout: (e) {
                            Utils.showToast(
                                'The OTP process timed out. Please try again.');
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
