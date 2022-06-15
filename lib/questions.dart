import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sabbar1/models/user_model.dart';
import 'package:flutter/material.dart';
import 'add_question.dart';
import 'edit_question.dart';
import 'comments_screen.dart';

class questions extends StatefulWidget {
  @override
  _questionsState createState() => _questionsState();
}

class _questionsState extends State<questions> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('questions').snapshots();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => addQuestion()));
        },
        child: Icon(
          Icons.add,
        ),
      ),
      //appBar: AppBar(
        //title: Text('الأسئلة'),
      //),

      body:

      SingleChildScrollView(
          child: Column(
            children: [
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

                StreamBuilder(
                  stream: _usersStream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("An error has occured");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                          return GestureDetector(
                            onTap: () {

                              if("${loggedInUser.uid}" == snapshot.data!.docChanges[index].doc['uid']){
                                Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      editQuestion(docid: snapshot.data!.docs[index]),
                                ),
                              );}
                            },
                            child: Column(
                              children:
                              [
                                SizedBox(
                                  height: 4,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 3,
                                    right: 3,
                                  ),
                                  child: Card(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(Icons.chat),
                                            title: Text(
                                              snapshot.data!.docChanges[index].doc['title'],
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                TextButton(
                                                  child: const Text('التعليقات'),
                                                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentsScreen(),
                                                  ),
                                                  ),
                                                ),
                                                const SizedBox(width: 15),
                                              ]
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              const SizedBox(height: 90),
            ],
          ),
      ),
    );
  }
}