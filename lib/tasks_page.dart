import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sabbar1/models/task.dart';
import 'package:sabbar1/screens/owner_users/owner_users_list.dart';
import 'package:sabbar1/screens/tasks/add_task.dart';
import 'package:sabbar1/screens/tasks/tasks_list.dart';
// Services
import '../../services/database.dart';

class TasksPage extends StatefulWidget {

  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}


class _TasksPageState extends State<TasksPage> {
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


  renderOwnerFloatingButton() {
    if(userType == "Worker") {
      return <Widget> [Container()];
    }

    return <Widget>[Container(
            // margin:EdgeInsets.all(10),
            margin:const EdgeInsets.only(bottom: 15),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "AddTask",
              onPressed: (){
                  //action code for button 2
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTask()),
                );
              },
              //backgroundColor: const Color.fromARGB(255, 59, 25, 150),
              child: const Icon(Icons.add),
            )
          ), // button second
          Container(
            margin:const EdgeInsets.only(left: 30),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "Owner User",
              onPressed: (){
                  //action code for button 1
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OwnerUsersList()),
                  );
              },
              child: const Icon(Icons.person),
            )
          ), //button first
          ];
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    body: SingleChildScrollView(
      child: Column(
          children: [
      Padding(
      padding: const EdgeInsets.fromLTRB(268.0, 70.0, 0.0, 0.0),
      child: Text('المهام',
        style: TextStyle(
          fontSize: 30.0,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
            TasksList(),
  ]),

    ),
    floatingActionButton:Wrap( //will break to another line on overflow
    direction: Axis.horizontal, //use vertical to show  on vertical axis
    children:  renderOwnerFloatingButton()

    ),
  );
}