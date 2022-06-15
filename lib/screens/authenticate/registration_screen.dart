import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sabbar1/models/user_model.dart';
import 'package:sabbar1/screens/home/home.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final firstNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  final phoneEditingController = new TextEditingController();
  final userTypeEditingController = new TextEditingController();
  //final provinceEditingController = new TextEditingController();

  List<String> items = ['عامل', 'مدير'];
  String? selectedItem = 'عامل';

  @override
  Widget build(BuildContext context) {

    //first name
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.emailAddress,

      onSaved: (value)
      {
        firstNameEditingController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "الاسم",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //email
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value)
      {
        if(value!.isEmpty)
        {
          return ("الرجاء إدخال بريدك الإلكتروني");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-z0-9.-]+.[a-z]").hasMatch(value)){
          return ("الرجاء إدخال بريد إلكتروني صحيح");
        }

        return null;
      },
      onSaved: (value)
      {
        emailEditingController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "البريد الإلكتروني",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //phone
    final phoneField = TextFormField(
      autofocus: false,
      controller: phoneEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("الرجاء إدخال رقم الهاتف");
        }
      },
      onSaved: (value)
      {
        phoneEditingController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "رقم الهاتف",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //password
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("الرجاء إدخال رقمك السري");
        }
        if (!regex.hasMatch(value)) {
          return ("الرجاء إدخال رقم سري مكون من ٦ أحرف أو أكثر");
        }
      },
      onSaved: (value)
      {
        passwordEditingController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "الرقم السري",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //confirm password
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value)
      {
        if(confirmPasswordEditingController.text!=passwordEditingController.text)
          {
            return ("passwords don't match");
          }
        return null;
      },
      onSaved: (value)
      {
        confirmPasswordEditingController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "تأكيد الرقم السري",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //user type
    final userTypeField = TextFormField(
      autofocus: false,
      controller: userTypeEditingController,
      obscureText: true,
      onSaved: (value)
      {
        userTypeEditingController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    final signUpButton = Material(
        borderRadius: BorderRadius.circular(30),
        color: Colors.lightGreen,
        child: MaterialButton(
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: Text("أنشئ الحساب",
          textAlign: TextAlign.center,),
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        )

    );

    body: Center(
      child: DropdownButton<String>(
        value: selectedItem,
        items: items.map((item)=> DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: TextStyle(fontSize: 24)),
        )).toList(),
        onChanged: (item) => setState(() => selectedItem = item),
      )
    );


    return Scaffold(
        body: Center(
            child:SingleChildScrollView(
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
                                height: 100,
                                child: Image.asset('assets/images/SabbarLogoBlack.png',
                                  fit: BoxFit.contain,)
                            ),
                            SizedBox(height: 45),

                            firstNameField,
                            SizedBox(height: 25),

                            emailField,
                            SizedBox(height: 25),

                            phoneField,
                            SizedBox(height: 25),

                            passwordField,
                            SizedBox(height: 25),

                            confirmPasswordField,
                            SizedBox(height: 25),

                            DropdownButton<String>(
                              value: selectedItem,
                              items: items.map((item)=> DropdownMenuItem<String>(
                                value: item,
                                child: Text(item, style: TextStyle(fontSize: 24)),
                              )).toList(),
                              onChanged: (item) => setState(() => selectedItem = item),
                            ),

                            signUpButton,
                            SizedBox(height: 25),

                            Row(
                                children: [
                                  SizedBox(width: 45),
                                  TextButton(
                                      child: const Text('قم بتسجيل الدخول',
                                        textAlign: TextAlign.right,),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()));
                                      }
                                  ),
                                  Text('لديك حساب؟',
                                    textAlign: TextAlign.left,),
                                ]),

                          ],

                        )
                    ),
                  ),
                )
            )
        )
    );
  }

  void signUp(String email, String password) async
  {
    if(_formKey.currentState!.validate())
      {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e)
        {
          Fluttertoast.showToast(msg: e!.message);
        });
      }
  }

  postDetailsToFirestore() async
  {

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.phone = phoneEditingController.text;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    if(selectedItem == "مدير") {
      userModel.userType = "Owner";
    }
    else {
      userModel.userType = "Worker";
    }

    await firebaseFirestore
    .collection("users")
    .doc(user.uid)
    .set(userModel.toMap());
    Fluttertoast.showToast(msg: "تم إنشاء الحساب بنجاح");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => Home()),
            (route) => false);
  }
}