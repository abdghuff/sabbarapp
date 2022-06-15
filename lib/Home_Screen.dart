import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sabbar1/models/user_model.dart';
import 'package:sabbar1/screens/authenticate/login_screen.dart';
import 'tasks_page.dart';
import 'tasks_page_owner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sabbar1/screens/tasks/tasks_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    if ("${loggedInUser.userType}" == "Owner") {
      Fluttertoast.showToast(msg: "تم تسجيل الدخول بنجاح");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => TasksPageOwner()));
    } else if ("${loggedInUser.userType}" == "Worker") {
      Fluttertoast.showToast(msg: "تم تسجيل الدخول بنجاح كعامل");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => TasksPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(137.0, 70.0, 0.0, 0.0),
          child: Text(
            'الشاشة الرئيسية',
            style: TextStyle(
              fontSize: 30.0,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Row (
          children: [
            TextButton(onPressed: (){}, child: TextButton.icon(onPressed: (){}, icon: Icon(Icons.person),
                label: Text('${loggedInUser.firstName}'))),
          ],
        ),

        Card(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.format_list_bulleted),
              title: Text('المهام المتبقية'),
            ),
          ],
        )),

        if ("${loggedInUser.userType}" == "Worker")
        TasksList(),
        Card(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.outgoing_mail),
              title: Text('هل لديك اقتراحات أو شكاوى؟'),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              TextButton(
                child: const Text('أرسل الآن'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const FeedbackDialog());
                },
              ),
              const SizedBox(width: 15),
            ]),
          ],
        )),
        SizedBox(height: 15.0),
        Image.asset(
          'assets/images/SabbarLogoBlack.png',
          width: 50,
          color: Colors.black12,
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          logout(context);
        },
        child: const Icon(Icons.logout),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({Key? key}) : super(key: key);

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: 'أكتب الاقتراحات والشكاوى هنا',
              filled: true,
            ),
            maxLines: 5,
            maxLength: 4096,
            textInputAction: TextInputAction.done,
            validator: (String? text) {
              if (text == null || text.isEmpty) {
                return 'قم بكتابة اقتراحات أو شكاوى';
              }
              return null;
            },
          )),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء')),
        TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String message;

                try {
                  final collection =
                      FirebaseFirestore.instance.collection('feedback');
                  await collection.doc().set({
                    'timestamp': FieldValue.serverTimestamp(),
                    'feedback': _controller.text,
                  });

                  message = 'تم الإرسال بنجاح';
                } catch (_) {
                  message = 'لم يتم الإرسال بنجاح';
                }

                Fluttertoast.showToast(msg: message);
                Navigator.pop(context);
              }
            },
            child: const Text('أرسل')),
      ],
    );
  }
}
