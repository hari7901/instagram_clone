import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  final String imageUrl;
  final String username;
  final String commentText;
  final bool isLiked;
  final String datePublished;
  final Function(bool) onLikePressed;

  CommentCard({
    required this.imageUrl,
    required this.username,
    required this.commentText,
    required this.isLiked,
    required this.onLikePressed, required this.datePublished,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.imageUrl),
                radius: 25,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: widget.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '\n${widget.commentText}'),
                          TextSpan(
                            text: "\n${widget.datePublished}",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isLiked = !_isLiked;
                    widget.onLikePressed(_isLiked);
                  });
                },
                child: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
