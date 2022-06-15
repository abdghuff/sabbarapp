import 'questions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sabbar1/screens/home/home.dart';
import 'package:sabbar1/models/user_model.dart';
import 'package:uuid/uuid.dart';
import 'main.dart';

class addQuestion extends StatefulWidget {
  @override
  _addQuestionState createState() => _addQuestionState();
}

class _addQuestionState extends State<addQuestion> {
  TextEditingController title = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('questions');

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value){
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    const uuid = Uuid();

    return Scaffold(
      appBar: AppBar(
        actions: [
          MaterialButton(
            onPressed: () {
              ref.add({
                'title': title.text,
                'uid': "${loggedInUser.uid}",
                'questionID': uuid.v1(),
              }).whenComplete(() {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => Home()));
              });
            },
            child: Text(
              "أرسل",
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: TextField(
                  controller: title,
                  expands: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'أكتب سؤالك هنا',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
