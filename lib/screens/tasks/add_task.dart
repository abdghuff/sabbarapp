import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sabbar1/screens/maps/map.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:sabbar1/services/database.dart';


class Address {
  num? long;
  num? lat;

  Address({this.long, this.lat});
}


const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  

  @override
  _AddTaskState createState() => _AddTaskState();
}


class _AddTaskState extends State<AddTask> {
  var currentUser = FirebaseAuth.instance.currentUser;
  final  databaseService = DatabaseService();


  Address address = Address(lat:0,long:0);
  DateTime selectedDate = DateTime.now();
  String dropdownValue = "";
  List<Map<String, dynamic>> workersItems = [];


  // Inputs
    final titleController = TextEditingController();
    final descController = TextEditingController();



  @override
  void initState() {
    super.initState();
    getWorkersData();
  }

    getWorkersData() {
      databaseService.ownerUsersCollection.where("owner", isEqualTo: currentUser?.uid).get().then((snapshot) {
        List<Map<String, dynamic>> usrsList = [];
        for (var worker in snapshot.docs) {
          Map<String, dynamic> temp = worker.data() as Map<String, dynamic>;
          databaseService.userCollection.where("uid", isEqualTo: temp['worker']).get().then((QuerySnapshot usr) {
            Map<String, dynamic> usrDetails = usr.docs[0].data() as Map<String, dynamic>;
            usrsList.add({
              "uid": usrDetails['uid'],
              "firstName": usrDetails['firstName'],
              "phone": usrDetails['phone'],
              "email": usrDetails['email']
            });
            setState(() {
              workersItems = usrsList;
              dropdownValue = usrDetails['uid'];
            });
          });
        }
      });
  }

  addTask() {
    String taskId = dropdownValue + titleController.text +  getRandomString(15);
    Map<String, dynamic> taskdata ={
      "address":  {"long": address.long, "lat": address.lat},
      "description": descController.text,
      "isFinished": false,
      "owner": currentUser?.uid,
      "taskId": taskId,
      "title": titleController.text,
      "worker": dropdownValue,
      "date": selectedDate 
    };
    databaseService.addTasks(taskdata);
  }

    changeAddress(num long, num lat) {
    Address newAddress = Address(lat: lat, long:long);
    print("ENTERED");
    print(long.toString());
    print(lat.toString());

    setState(() {
      address = newAddress;
    });
    return newAddress;
  }


  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


    return Scaffold(
      appBar: AppBar(
        title: const Text("أضف مهمة"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40, bottom: 40),
        child: Column(
      children: [
        TextFormField(
          controller: titleController,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'العنوان',
        ),
      ),

      TextFormField(
        controller: descController,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'وصف',
        ),
      ),
      Card(
        child: Row(
          children: [
            Text(formattedDate),
            ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('تغير تاريخ العمل'),
                  ),
          ],
        ) ,
      ),
      
      DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: workersItems
          .map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
        return DropdownMenuItem<String>(
          value: value['uid'] ?? "",
          child: Text(value['firstName'] ?? ""),
        );
      }).toList(),
    ),
    ElevatedButton(
      
      onPressed: () => addTask(),
      child: const Text('اضف مهمة'),
    ),
    SizedBox(
      height: 300,
      width: 500,
      child: MapView(changeAddress: changeAddress,),
    )
    
      ],
      )
    )
    );
  }
}