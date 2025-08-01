import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mecha_connect/bottom_bar/OrderScreen.dart';
// import 'package:mecha_connect/Login.dart';
import 'package:mecha_connect/Starting_screen/home.dart';
import 'package:mecha_connect/bottom_bar/chatboard.dart';
import 'package:mecha_connect/main.dart';
// import 'package:mecha_connect/home.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:healthish/group.dart';
// import 'package:healthish/home.dart';
// import 'package:healthish/person.dart';
// import 'package:healthish/wish.dart';
import 'package:mecha_connect/parts/parts_screen.dart';

/*class BottomNavigation extends StatefulWidget {
  const BottomNavigation ({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationtate();
}

class _BottomNavigationtate extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}*/
class BottomNavigation extends StatefulWidget {
  const BottomNavigation ({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
   int _currentIndex = 0;
  final List<Widget>  _navitems =[
    ServiceSelectionScreen(),
   PartsScreen(),
   ChatBot(),
   Orderscreen()
   //Group(),
   //Group() 
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    body: _navitems[_currentIndex],
    bottomNavigationBar:GNav(
       backgroundColor: AppColors.backgroundWhite,
      
      
      tabBackgroundColor: Colors.grey.shade50,
      tabBorderRadius: 40,
      onTabChange: (value) {
        if(_currentIndex != value){
          setState(() {
           _currentIndex = value;    
          }
          );
        }
      },
      tabs: [  
      GButton(icon: Icons.home,text: "Home",),
      GButton(icon: Icons.build,text: "Store",),
      GButton(icon: Icons.person,text: "AI",),
      GButton(icon: Icons.shopping_bag,text: "Orders",),    
    ]),
    );
  }
}