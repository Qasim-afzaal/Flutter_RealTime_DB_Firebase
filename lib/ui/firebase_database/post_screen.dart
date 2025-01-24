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
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              }).catchError((error) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              defaultChild: Center(child: CircularProgressIndicator()),
              itemBuilder: (context, snapshot, animation, index) {
                return ListTile(
                  title: Text(snapshot.child('title').value.toString()),
                  subtitle: Text(snapshot.child('id').value.toString()),
                  trailing: PopupMenuButton(
                    color: Colors.white,
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            ref.child(snapshot.child('id').value.toString()).update({'title': 'nice world'}).then((_) {
                              Utils().toastMessage('Post updated successfully.');
                            }).catchError((error) {
                              Utils().toastMessage(error.toString());
                            });
                          },
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            ref.child(snapshot.child('id').value.toString()).remove().then((_) {
                              Utils().toastMessage('Post deleted successfully.');
                            }).catchError((error) {
                              Utils().toastMessage(error.toString());
                            });
                          },
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
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
