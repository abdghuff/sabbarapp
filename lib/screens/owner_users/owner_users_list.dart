
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sabbar1/screens/owner_users/add_user.dart';
import 'package:sabbar1/screens/owner_users/owner_users_list_item.dart';
import '../../services/database.dart';

class OwnerUsersList extends StatefulWidget {
  const OwnerUsersList({Key? key}) : super(key: key);

  @override
  _OwnerUsersListState createState() => _OwnerUsersListState();
}

class _OwnerUsersListState extends State<OwnerUsersList> {
  final  databaseService = DatabaseService();
  var currentUser = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("العاملين")),
    body:Container(
      padding: const EdgeInsets.all(5.0),
      child: StreamBuilder(
        stream: databaseService.ownerUsersCollection.where("owner", isEqualTo: currentUser?.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.data == null) return const Text("");
          return  ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: snapshot.data == null ? [] : snapshot.data!.docs.map((worker) {
                  return OwnerUsersListItemItem(item: worker);
                }).toList()
          );
        },
      ),
    ),
    floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddWorker()),
          );
        },
        //backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
  );
  }