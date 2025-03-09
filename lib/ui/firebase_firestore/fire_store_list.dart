import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_time_db_firebase/ui/auth/login_screen.dart';
import 'package:real_time_db_firebase/ui/firebase_firestore/inser_fire_store.dart';
import 'package:real_time_db_firebase/utils/utils.dart';

class ShowFireStorePostScreen extends StatefulWidget {
  const ShowFireStorePostScreen({super.key});

  @override
  State<ShowFireStorePostScreen> createState() => _ShowFireStorePostScreenState();
}

class _ShowFireStorePostScreenState extends State<ShowFireStorePostScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _firestoreStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  /// Signs out the user and navigates back to the Login screen.
  void _signOut() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      Utils.showToast(error.toString());
    }
  }

  /// Deletes a user document in Firestore.
  Future<void> _deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
      Utils.showToast("User deleted successfully.");
    } catch (error) {
      Utils.showToast("Failed to delete user: $error");
    }
  }

  /// Updates a user's full name in Firestore.
  Future<void> _updateUserName(String userId, String newName) async {
    try {
      await _usersCollection.doc(userId).update({'full_name': newName});
      Utils.showToast("User updated successfully.");
    } catch (error) {
      Utils.showToast("Failed to update user: $error");
    }
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
          const SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final data = document.data()! as Map<String, dynamic>;
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InsertFireStoreScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
