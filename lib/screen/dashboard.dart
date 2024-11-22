import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/screen/graph_screen.dart';
import 'package:flutter_application_4/screen/home_screen.dart';
import 'package:flutter_application_4/screen/login.dart';
import 'package:flutter_application_4/widgets/navbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var isLogoutLoading = false;
  int currentIndex = 0;
  var pageViewList = [
    HomeScreen(),
    //Center(child: Text("Graphs Page")),
    Graph(),
  ];

   logOut() async {
    setState((){
     isLogoutLoading = true;
    }

    );
    await FirebaseAuth.instance.signOut();
    Navigator.push(
       context,
        MaterialPageRoute(builder: (context) => LoginView()),
    );
    setState((){
      isLogoutLoading = false;
    }

    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff368983),
        actions: [IconButton(onPressed: () {
          logOut();

        }, icon: isLogoutLoading
        ? CircularProgressIndicator():
        Icon(Icons.exit_to_app))],
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: currentIndex, 
        onDestinationSelected: (int value) {  
          setState(() {
            currentIndex = value;
          });
        },),
      
      body: pageViewList[currentIndex],
    );
  }
}