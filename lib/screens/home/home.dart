import 'package:animations/animations.dart';
import'package:flutter/material.dart';
import 'package:sabbar1/Home_Screen.dart';
import'package:sabbar1/tasks_page.dart';
import'package:sabbar1/questions_page.dart';
import'package:sabbar1/tips_page.dart';
import 'package:sabbar1/questions.dart';

class Home extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int index = 0;
  final screens = [
    HomeScreen(),
    TasksPage(),
    questions(),
    TipsPage(),
  ];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: PageTransitionSwitcher(
        duration: Duration(seconds: 1),
        transitionBuilder: (child, animation, secondaryAnimation) => 
        FadeThroughTransition(animation: animation, secondaryAnimation: secondaryAnimation,
        child: child,),

      child: screens[index],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          height: 70,
          selectedIndex: index,
          onDestinationSelected: (index) =>
              setState(() => this.index = index),
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.format_list_bulleted), label: 'المهام'),
            NavigationDestination(icon: Icon(Icons.chat_bubble), label: 'الأسئلة'),
            NavigationDestination(icon: Icon(Icons.lightbulb), label: 'نصائح'),
          ],
        ),
      ),
    );
  }

}