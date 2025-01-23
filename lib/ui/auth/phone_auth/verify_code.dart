import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_time_db_firebase/utils/utils.dart';
import '../../../widgets/round_button.dart';
import '../../firebase_database/post_screen.dart';



class VerifyCodeScreen extends StatefulWidget {
  final String verificationId ;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false ;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 80,),

            TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: '6 digit code'
              ),
            ),
            SizedBox(height: 80,),
            RoundButton(title: 'Verify',loading: loading, onTap: ()async{

              setState(() {
                loading = true ;
              });
              final crendital = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId, 
                  smsCode: verificationCodeController.text.toString()
              );
              
              try{
                
                await auth.signInWithCredential(crendital);
                
                Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
                
              }catch(e){
                setState(() {
                  loading = false ;
                });
                Utils().toastMessage(e.toString());
              }
            })

          ],
        ),
      ),
    );
  }
}
