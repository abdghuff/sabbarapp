
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Services
import '../../services/database.dart';

class OwnerUsersListItemItem extends StatefulWidget {
  const OwnerUsersListItemItem({Key? key, this.item}) : super(key: key);

  final dynamic item;
  @override
  _OwnerUsersListItemState createState() => _OwnerUsersListItemState();
}

class _OwnerUsersListItemState extends State<OwnerUsersListItemItem> {
  final  databaseService = DatabaseService();
  var currentUser = FirebaseAuth.instance.currentUser;


  Map<String, dynamic> worker = {};

  void getWorkerData() {
    databaseService.userCollection.where("uid", isEqualTo: widget.item['worker']).get().then((QuerySnapshot querySnapshot) => {
      setState(() {
        worker = querySnapshot.docs[0].data() as Map<String, dynamic>;
      })
    });
  }


  @override
  void initState() {
    super.initState();
    getWorkerData();
  }

  removeWorker() {
    databaseService.deleteOwnerUser(widget.item['worker'], currentUser?.uid);
    getWorkerData();
  }
  
  @override
  Widget build(BuildContext context){
    return Container(
    padding: const EdgeInsets.all(5.0),
    child: 
        Card(
          child: 
            ListTile(
              title: Text(worker['firstName'] ?? ""), 
              subtitle: Text(worker['email'] ?? ""),
              trailing: ElevatedButton(child: const Text("ازاله"), onPressed: ()=>removeWorker(),)
            )
        ),
    );
  }
}