import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gpt/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  final String profilePicUrl;
  final String username;


  FeedScreen({required this.profilePicUrl, required this.username});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: false,
          title: Container(
            margin: EdgeInsets.only(top: 16.0),
            // Adjust the top margin as needed
            child: SvgPicture.asset(
              'android/assets/ic_instagram.svg',
              color: Colors.white,
              height: 32,
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(top: 16.0),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.message_outlined),
                color: Colors.white,
              ),
            )
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posted').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => PostCard(
                    snap: snapshot.data!.docs[index].data(), profilePicUrl: widget.profilePicUrl, username: widget.username,
                  ),
              );
            }
            )
    );
  }
}
