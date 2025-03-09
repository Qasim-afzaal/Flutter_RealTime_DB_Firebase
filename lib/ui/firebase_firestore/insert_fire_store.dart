import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_time_db_firebase/ui/auth/login_screen.dart';
import 'package:real_time_db_firebase/utils/utils.dart';

class InsertFireStoreScreen extends StatefulWidget {
  const InsertFireStoreScreen({super.key});

  @override
  State<InsertFireStoreScreen> createState() => _InsertFireStoreScreenState();
}

class _InsertFireStoreScreenState extends State<InsertFireStoreScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStoreCollection = FirebaseFirestore.instance.collection('users');

  void _signOut() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      Utils.showToast(e.toString());
    }
  }

  Future<void> _addFirestoreDocument() async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await _fireStoreCollection.doc(id).set({
        'full_name': "Sample Name",
        'company': "Sample Company",
        'age': 25,
        'id': id,
      });
      Utils.showToast('Data added successfully to Firestore');
    } catch (e) {
      Utils.showToast('Failed to add data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Example'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Press the + button to add data to Firestore',
          style: TextStyle(fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFirestoreDocument,
        child: const Icon(Icons.add),
      ),
    );
  }
}
