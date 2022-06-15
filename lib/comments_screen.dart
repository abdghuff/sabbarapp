import 'package:flutter/material.dart';
import 'comment_card.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("التعليقات"),
      ),

      body: CommentCard(),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                    decoration: InputDecoration(
                      hintText: 'أكتب تعليقك هنا',
                      border: InputBorder.none,
                    )
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8,),
                  child: const Text('أرسل', style: TextStyle(
                    color: Colors.green,
                  )),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
