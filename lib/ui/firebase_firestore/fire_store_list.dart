import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_time_db_firebase/ui/auth/login_screen.dart';
import 'package:real_time_db_firebase/ui/firebase_firestore/insert_fire_store.dart';
import 'package:real_time_db_firebase/utils/utils.dart';

class ShowFireStorePostScreen extends StatefulWidget {
  const ShowFireStorePostScreen({super.key});

  @override
  State<ShowFireStorePostScreen> createState() => _ShowFireStorePostScreenState();
}

class _ShowFireStorePostScreenState extends State<ShowFireStorePostScreen> {
  final _auth = FirebaseAuth.instance;
  final _usersCollection = FirebaseFirestore.instance.collection('users');

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

  Future<void> _deleteUser(String userId) async {
    final confirm = await _showDeleteConfirmationDialog();
    if (confirm) {
      try {
        await _usersCollection.doc(userId).delete();
        Utils.showToast("User deleted successfully.");
      } catch (e) {
        Utils.showToast("Failed to delete user: $e");
      }
    }
  }

  Future<void> _updateUserName(String userId, String newName) async {
    try {
      await _usersCollection.doc(userId).update({'full_name': newName});
      Utils.showToast("User updated successfully.");
    } catch (e) {
      Utils.showToast("Failed to update user: $e");
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text("Are you sure you want to delete this user?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Posts'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              final data = document.data() as Map<String, dynamic>? ?? {};
              final userId = document.id;

              return ListTile(
                title: Text(data['full_name'] ?? 'Unknown'),
                subtitle: Text(data['company'] ?? 'No company'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _updateUserName(userId, 'Updated Name'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteUser(userId),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InsertFireStoreScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
