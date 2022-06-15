import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sabbar1/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sabbar1/models/user_model.dart';

class AddWorker extends StatefulWidget {
  const AddWorker({Key? key}) : super(key: key);


  @override
  _AddWorkerState createState() => _AddWorkerState();
}


class _AddWorkerState extends State<AddWorker> {

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

  final  databaseService = DatabaseService();
  final workerEmailController = TextEditingController();
  String? message = null;

  void addWorker() {
    // IMPLEMENT
    final String? value = workerEmailController.text;
    if(value == '') {
      setState(() {
        message = "قم بكتابة ايميل العامل";
      });
      return;
    }

    // Add worker
    databaseService.userCollection.where("email", isEqualTo: value).get().then((QuerySnapshot querySnapshot){
      if(querySnapshot.docs.isEmpty) {
        setState(() {
        message = "تأكد من صحة ايميل العامل";
      });
      }else {
        Map<String, dynamic> workerDetails = querySnapshot.docs[0].data() as  Map<String, dynamic>;
        String uid = workerDetails['uid'];
        databaseService.addOwnerUser(uid, "${loggedInUser.uid}");
        setState(() {
        message = "تم إضافة العامل بنجاح";
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("أضف عامل"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40, bottom: 40),
        child: Column(
      children: [
        TextFormField(
          controller: workerEmailController,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'ايميل العامل',
        ),
      ),
      Text(message ?? ""),
    ElevatedButton(
              onPressed: () => addWorker(),
              child: const Text('أضف'),
            ),
      ],
      )
    )
    );
  }
}