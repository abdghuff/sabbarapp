import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sabbar1/screens/home/home.dart';
import 'package:sabbar1/screens/authenticate/registration_screen.dart';
import 'package:sabbar1/models/user_model.dart';
import 'package:sabbar1/tasks_page_owner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("الرجاء إدخال بريدك الإلكتروني");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("الرجاء إدخال بريد إلكتروني صحيح");
        }

        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "البريد الالكتروني",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),

    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,

      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("الرجاء إدخال رقمك السري");
        }
        if (!regex.hasMatch(value)) {
          return ("الرجاء إدخال رقم سري مكون من ٦ أحرف أو أكثر");
        }
        else { return ("الرجاء التأكد من صحة الرقم السري"); }
      },

      onSaved: (value) {
        passwordController.text = value!;
      },

      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "الرقم السري",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),

    );

    final loginButton = Material(
        borderRadius: BorderRadius.circular(30),
        color: Colors.lightGreen,
        child: MaterialButton(
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: Text("تسجيل الدخول",
            textAlign: TextAlign.center,),
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        )

    );


    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Container(
                  //color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            SizedBox(
                                height: 200,
                                child: Image.asset(
                                  'assets/images/SabbarLogoBlack.png',
                                  fit: BoxFit.contain,)
                            ),
                            SizedBox(height: 45),

                            emailField,
                            SizedBox(height: 25),

                            passwordField,
                            SizedBox(height: 35),

                            loginButton,
                            SizedBox(height: 15),

                            Row(
                                children: <Widget>[
                                  Text(""),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationScreen()));
                                      },
                                      child: Text("قم بإنشاء حساب")
                                  )
                                ]
                            ),
                          ],
                        )
                    ),
                  ),
                )
            )
        )
    );
  }

  void signIn(String email, String password) async
  {
    if (_formKey.currentState!.validate()) {
      await _auth.signInWithEmailAndPassword(email: email, password: password)
          .then((uid) =>
      {
        Fluttertoast.showToast(msg: "تم تسجيل الدخول بنجاح"),
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Home()))
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        }),
      }
      );
    }
  }
}