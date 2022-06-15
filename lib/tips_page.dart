import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TipsPage extends StatefulWidget {
  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {

  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('tips').snapshots();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(268.0, 70.0, 0.0, 0.0),
              child: Text('نصائح',
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
                        onTap: () {},
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
                                        leading: Icon(Icons.lightbulb_outline),
                                        contentPadding: EdgeInsets.all(15),
                                        title: Text(
                                          snapshot.data!.docChanges[index].doc['title'],
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                          textDirection: TextDirection.rtl,
                                        ),
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
          ],
        ),
      ),
    );
  }
}