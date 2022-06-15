import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Services
import '../../services/database.dart';

class WorkerTasks extends StatefulWidget {
  const WorkerTasks({Key? key}) : super(key: key);

  @override
  _WorkerTasksState createState() => _WorkerTasksState();
}

class _WorkerTasksState extends State<WorkerTasks> {
  final  databaseService = DatabaseService();
  var currentUser = FirebaseAuth.instance.currentUser;

  finishedTask(String docId) {
    databaseService.finishTask(docId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: StreamBuilder(
        stream: databaseService.tasksCollection.where("worker", isEqualTo: currentUser?.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if((snapshot.data != null && snapshot.data!.docs.isEmpty) || (snapshot.data == null)) {
            return const Text("لا يوجد مهام مطلوبة منك حاليا");
          }

          return ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: snapshot.data!.docs.map((task) {
              return Container(
                child: 
                    Card(
                      child: 
                        ListTile(
                          title: Text(task['title'] ?? ""), 
                          subtitle: Text(task['description'] ?? ""),
                          trailing: ElevatedButton(child: const Text("انتهيت"), onPressed: ()=>finishedTask(task.id),)
                        )
                    ),
                );
              }
            ).toList()
          );
        },
      )
    );
  }
}

