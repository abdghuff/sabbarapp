import 'package:flutter/material.dart';

class TasksPageOwner extends StatefulWidget {
  @override
  _TasksPageOwnerState createState() => _TasksPageOwnerState();
}

class _TasksPageOwnerState extends State<TasksPageOwner> {

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column( children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(278.0, 70.0, 0.0, 0.0),
        child: Text('المهام',
          style: TextStyle(
            fontSize: 30.0,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.playlist_add_check),
                title: Text('مهام اليوم'),
              ),
            ],
          )
      ),
      SizedBox(height: 15.0),
      Image.asset(
        'assets/images/SabbarLogoBlack.png',
        width: 50,
        color: Colors.black12,),
    ]),
    floatingActionButton: buildAddButton(),
  );
  Widget buildAddButton() => FloatingActionButton(
    child: Icon(Icons.add),
    onPressed: () {},
  );
}