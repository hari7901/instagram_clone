import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gpt/screens/comment_screen.dart';
import 'package:gpt/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  final String profilePicUrl;
  final String username;

  PostCard({required this.snap,
    required this.profilePicUrl,
    required this.username,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  bool isAnimating = false;
  bool isLiked = false;
  int commentLen = 0;
  bool isDeleteButtonVisible = true;
  bool isPostDeleted = false;// Track delete button visibility


  @override
  void initState(){
    super.initState();
    getComments();
  }

  void getComments () async{
    try{
      QuerySnapshot snap = await FirebaseFirestore
          .instance.
      collection('posted').
      doc(widget.snap['postId']).
      collection('comments').get();
      commentLen = snap.docs.length;
    }catch(e){
      showSnackBar(e.toString(), context);
    }
    setState(() {

    });
  }
  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Snackbar display duration
      ),
    );
  }

  void _likePost() async {
    String postId = widget.snap['postId'];
    String userId = FirebaseAuth.instance.currentUser!.uid;
    List<dynamic> likedBy = List.from(widget.snap['likedBy'] ?? []);

    if (!likedBy.contains(userId)) {
      // User has not liked the post, allow liking
      likedBy.add(userId);
      // Update Firestore to add the user ID to the 'likedBy' list
      await FirebaseFirestore.instance.collection('posted').doc(postId).update({
        'likedBy': likedBy,
        'likes': FieldValue.increment(1),
      });

      setState(() {
        isLikeAnimating = true;
      });

      // Reset animation state after a delay to stop the animation
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {
          isLikeAnimating = false;
        });
      });
    }
  }


  void _handlePictureTap() {
    // When the user taps on the picture, like the post
    _likePost();
    // Set animation state to trigger the like animation
    setState(() {
      isAnimating = true;
    });
    // Reset animation state after a delay to stop the animation
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        isAnimating = false;
      });
    });
  }

  Future<void> _deletePost() async {
    try {
      setState(() {
      isDeleteButtonVisible = false; // Hide the delete button immediately
    });

      // Get the post ID
      String postId = widget.snap['postId'];

      // Delete the post document from the 'posted' collection
      await FirebaseFirestore.instance.collection('posted').doc(postId).delete();

      // Close the dialog if it is open
      Navigator.of(context).pop();
      showSnackBar('Post deleted successfully', context);

      setState(() {
        isPostDeleted = true;
      });

    } catch (e) {
      // Handle errors (show error message)
      showSnackBar('Error deleting post: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var imageUrl = widget.snap['imageUrl'] ?? '';
    var user = widget.snap['username'] ?? '';
    var desc = widget.snap['description'] ?? '';
    var likes = widget.snap['likes'] ?? '';
    bool shouldAnimate = likes > 0;

    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                  .copyWith(right: 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(widget.profilePicUrl),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  )),
                  Visibility(
                    visible: isDeleteButtonVisible,
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: ListView(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      "Delete",
                                    ]
                                        .map((e) => InkWell(
                                              onTap: _deletePost ,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 16,
                                                ),
                                                child: Text(e),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ));
                      },
                      icon: const Icon(Icons.more_vert),
                    ),
                  ),
                ],
              ),
          ),
          GestureDetector(
           onDoubleTap: _likePost,
            onTap: _handlePictureTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.35,
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(
                    milliseconds: 200
                  ),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(child: const Icon(Icons.favorite, color: Colors.white,size: 120,),
                      isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: (){
                     setState(() {
                       isLikeAnimating = false;
                     });
                    },
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                  child: IconButton(
                    onPressed: _likePost,
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                  isAnimating: shouldAnimate,
                smallLike: true,
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentScreen(
                  profilePicUrl: widget.profilePicUrl,
                  username: widget.username,
                  postId: widget.snap['postId'],
                  imageUrl: imageUrl,)
                )),
                icon: const Icon(
                   FontAwesomeIcons.comment,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: (){},
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
              Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: (){},
                      icon: Icon(FontAwesomeIcons.bookmark),
                      color: Colors.white,
                    ),
                  )
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white
                  ),
                  child: Text('${likes.toString()} likes', style: TextStyle(color: Colors.white,),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,

                      ),
                      children: [
                        TextSpan(
                          text: user ,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '  ${desc}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ]
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '28/10/2023',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
