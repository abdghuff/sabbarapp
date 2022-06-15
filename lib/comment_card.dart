import 'package:flutter/material.dart';
import 'post_comment.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({Key? key}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children : [
          Padding(
            padding: const EdgeInsets.only(left: 16, ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Name',
                        style: const TextStyle(color:Colors.lightGreen, fontWeight: FontWeight.bold,),
                    ),
                  ],
                )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('Comment'),
                ),
              ]
            )
          )
        ]
      ),
    );
  }
}
