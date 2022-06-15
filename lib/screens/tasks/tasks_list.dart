import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sabbar1/screens/tasks/owner_tasks.dart';
import 'package:sabbar1/screens/tasks/worker_tasks.dart';
import 'package:sabbar1/services/database.dart';

class TasksList extends StatefulWidget {
  const TasksList({Key? key}) : super(key: key);

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
    var currentUser = FirebaseAuth.instance.currentUser;
    final  databaseService = DatabaseService();
    var userType = "";


  initialize() {
    databaseService.userCollection.where("uid", isEqualTo: currentUser?.uid).get().then((QuerySnapshot usr) {
      Map<String, dynamic> usrDetails = usr.docs[0].data() as Map<String, dynamic>;
      setState(() {
        userType = usrDetails['userType'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }


  @override
  Widget build(BuildContext context){
    
    if(userType == "Worker") {
      return const WorkerTasks();
    }else {
      return const OwnerTasks();
    }
  }
}

