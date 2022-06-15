import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sabbar1/models/task.dart';

class DatabaseService {
  // Global Vars
  var currentUser = FirebaseAuth.instance.currentUser;
  //collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference tasksCollection = FirebaseFirestore.instance.collection('tasks');
  final CollectionReference ownerUsersCollection = FirebaseFirestore.instance.collection('ownerWorkers');

  // TASKS
  
  Future<List<Task>> getTasks() async {
    // Returns a list of tasks
    List<Task> list = [];
    tasksCollection.where(
      "owner", 
      isEqualTo: currentUser?.uid).get()
        .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.map((doc) {
              Task task = Task(
                address:doc['address'], 
                description:doc['description'],
                owner: doc['owner'],
                taskId: doc['taskId'],
                title: doc['title'],
                worker: doc['worker']);
                list.add(task);
            });
        });
      return list;
  } 

  Future<void> finishTask(String docId) {
    // Update a task to the tasks list
      return tasksCollection
          .doc(docId)
          .update({"isFinished": true})
          .then((value) => value)
          // ignore: invalid_return_type_for_catch_error, avoid_print
          .catchError((error) => print("Failed to add user: $error"));
  }

  dynamic addTasks(data) {
    // Add a task to the tasks list
    return tasksCollection
          .add(data)
          .then((value) => value)
          // ignore: invalid_return_type_for_catch_error, avoid_print
          .catchError((error) => print("Failed to add user: $error"));
  } 

  // OWNER USERS
  dynamic getOwnerUsers() {
    // Returns a list of owner users
    return ownerUsersCollection.where({'owner_id': currentUser?.uid}).get()
        .then((QuerySnapshot querySnapshot) {
           List list = [];
            for (var doc in querySnapshot.docs) {
                list.add(doc);
            }
            return list;
        });
  } 

  dynamic addOwnerUser(workerId, ownerId) {
    final now = DateTime.now();
    Map<String, dynamic> data = {
      "creation_date": now,
      "isDeleted": false,
      "owner": ownerId,
      "worker": workerId
    };
    return ownerUsersCollection
          .doc(ownerId + workerId)
          .set(data)
          .then((value) => value)
          // ignore: invalid_return_type_for_catch_error, avoid_print
          .catchError((error) => print("Failed to add user: $error"));
  } 

  dynamic deleteOwnerUser(workerId, ownerId) {
    return ownerUsersCollection
      .doc(ownerId + workerId)
      .delete()
      .then((value) => value)
      // ignore: invalid_return_type_for_catch_error, avoid_print
      .catchError((error) => print("Failed to add user: $error"));
  } 
}