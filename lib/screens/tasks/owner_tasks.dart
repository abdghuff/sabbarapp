import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Services
import '../../services/database.dart';

class OwnerTasks extends StatefulWidget {
  const OwnerTasks({Key? key}) : super(key: key);

  @override
  _OwnerTasksState createState() => _OwnerTasksState();
}

class _OwnerTasksState extends State<OwnerTasks> {
  final  databaseService = DatabaseService();
  var currentUser = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: StreamBuilder(
        stream: databaseService.tasksCollection.where("owner", isEqualTo:currentUser?.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if((snapshot.data != null && snapshot.data!.docs.isEmpty) || (snapshot.data == null)) {
            return const Text("لا يوجد مهام مضافة. أضف مهاما بالضغط على +", textDirection: TextDirection.rtl,);
          }
          return ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: snapshot.data!.docs.map((task) {
              return  Container(
                child: 
                    Card(
                      child: 
                        ListTile(
                          title: Text(task['title'] ?? ""), 
                          subtitle: Text(task['description'] ?? "")
                        )
                    ),
                );
            }).toList()
          );
        },
      )
    );
  }
}

