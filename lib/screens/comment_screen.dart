import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import DateFormat

import '../widgets/comments_card.dart';
// Import the modified CommentCard widget

class CommentScreen extends StatefulWidget {
  final String profilePicUrl;
  final String username;
  final String postId;
  final String imageUrl;

  CommentScreen({
    required this.profilePicUrl,
    required this.username,
    required this.postId,
    required this.imageUrl,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  void _postComment() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String commentId =
        FirebaseFirestore.instance.collection('posted').doc().id;
    String text = _commentController.text;
    String datePublished = DateFormat.yMMMd().format(DateTime.now()); // Format the date

    // Reference to the comments subcollection under the specified post
    CollectionReference commentsRef = FirebaseFirestore.instance
        .collection('posted')
        .doc(widget.postId)
        .collection('comments');

    // Add comment data to Firestore
    await commentsRef.doc(commentId).set({
      'uid': uid,
      'commentId': commentId,
      'profilePic': widget.profilePicUrl,
      'name': widget.username,
      'text': text,
      'datePublished': datePublished,
      'isLiked': false, // Default like status is set to false
    });

    // Clear the comment input field after posting
    _commentController.clear();
  }

  void _toggleLikeStatus(String commentId, bool currentStatus) async {
    // Reference to the specific comment document
    DocumentReference commentDocRef = FirebaseFirestore.instance
        .collection('posted')
        .doc(widget.postId)
        .collection('comments')
        .doc(commentId);

    // Update the like status of the comment in Firestore
    await commentDocRef.update({'isLiked': !currentStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Comments',style:
          TextStyle(
            color: Colors.white
          ),),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posted')
            .doc(widget.postId)
            .collection('comments')
             .orderBy('datePublished',descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var commentData = snapshot.data!.docs[index].data();
              return CommentCard(
                imageUrl: commentData['profilePic'],
                username: commentData['name'],
                commentText: commentData['text'],
                isLiked: commentData['isLiked'] ?? false,
                datePublished: commentData['datePublished'],
                onLikePressed: (isLiked) {
                  _toggleLikeStatus(commentData['commentId'], isLiked);
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.profilePicUrl,
                ),
                radius: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: TextField(
                    controller: _commentController,
                    style: TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      hintText: "Comment as ${widget.username}",
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
              InkWell(
                onTap: _postComment,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
