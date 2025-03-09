import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:real_time_db_firebase/utils/utils.dart';
import 'package:real_time_db_firebase/widgets/round_button.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  Future<void> addPost() async {
    if (postController.text.trim().isEmpty) {
      Utils.showToast('Please enter some text');
      return;
    }

    setState(() {
      loading = true;
    });

    String id = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await databaseRef.child(id).set({
        'title': postController.text.trim(),
        'id': id,
      });
      Utils.showToast('Post added');
      postController.clear();
    } catch (error) {
      Utils.showToast(error.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: const InputDecoration(
                hintText: 'What is on your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            RoundButton(
              title: 'Add',
              loading: loading,
              onTap: addPost,
            ),
          ],
        ),
      ),
    );
  }
}