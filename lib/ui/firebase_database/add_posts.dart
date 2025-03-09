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
  final TextEditingController _postController = TextEditingController();
  bool _loading = false;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _addPost() async {
    final String postText = _postController.text.trim();
    if (postText.isEmpty) {
      Utils.showToast('Please enter some text');
      return;
    }

    setState(() => _loading = true);
    final String id = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      await _databaseRef.child(id).set({'title': postText, 'id': id});
      Utils.showToast('Post added');
      _postController.clear();
    } catch (error) {
      Utils.showToast(error.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Post')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextFormField(
              maxLines: 4,
              controller: _postController,
              decoration: const InputDecoration(
                hintText: 'What is on your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            RoundButton(
              title: 'Add',
              loading: _loading,
              onTap: _addPost,
            ),
          ],
        ),
      ),
    );
  }
}
