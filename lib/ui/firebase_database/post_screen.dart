import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:real_time_db_firebase/ui/auth/login_screen.dart';
import 'package:real_time_db_firebase/ui/firebase_database/add_posts.dart';
import 'package:real_time_db_firebase/utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('Post');

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (error) {
      Utils.showToast(error.toString());
    }
  }

  Future<void> _updatePost(String postId) async {
    try {
      await _ref.child(postId).update({'title': 'nice world'});
      Utils.showToast('Post updated successfully.');
    } catch (error) {
      Utils.showToast(error.toString());
    }
  }

  Future<void> _deletePost(String postId) async {
    try {
      await _ref.child(postId).remove();
      Utils.showToast('Post deleted successfully.');
    } catch (error) {
      Utils.showToast(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: _ref,
              defaultChild: const Center(child: CircularProgressIndicator()),
              itemBuilder: (context, snapshot, animation, index) {
                final String? postId = snapshot.child('id').value?.toString();
                final String title = snapshot.child('title').value?.toString() ?? 'No title';

                if (postId == null) {
                  return const SizedBox.shrink();
                }

                return ListTile(
                  title: Text(title),
                  subtitle: Text(postId),
                  trailing: PopupMenuButton<int>(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 1) {
                        _updatePost(postId);
                      } else if (value == 2) {
                        _deletePost(postId);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPostScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
