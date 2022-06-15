import 'package:flutter/material.dart';

class QuestionsPage extends StatefulWidget {
  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {

  @override
  Widget build(BuildContext context) => Scaffold(
    body:
    Padding(
      padding: const EdgeInsets.fromLTRB(268.0, 70.0, 0.0, 0.0),
      child: Text('الأسئلة',
        style: TextStyle(
          fontSize: 30.0,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    floatingActionButton: buildAskButton(),
  );
  Widget buildAskButton() => FloatingActionButton.extended(
    icon: Icon(Icons.message),
    label: Text('اسأل سؤالا'),
    onPressed: () {},
  );
}