import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_project/pages/admin/admin_home.dart';
import 'package:vaccine_project/pages/admin/admin_settings.dart';
import 'package:vaccine_project/pages/admin/request_approvel.dart';
import 'package:vaccine_project/pages/home.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  int selectedIndex = 0;
  List<Widget> widgetOptions = <Widget>[
    const AdminHome(),
    const AdminSetting(),
    const RequestApprovel()
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> logout(BuildContext context) async {
      const CircularProgressIndicator();
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Admin",
            style: TextStyle(
              color: Color(0xff2FB176),
              fontSize: 20,
            ),
          ),
        ),
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu_open_rounded,
              color: Color(0xff000000),
            )),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/img1.jpg'),
          )
        ],
      ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         logout(context);
      //       },
      //       icon: const Icon(
      //         Icons.logout,
      //       ),
      //     )
      //   ],
      // ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: widgetOptions.elementAt(selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
            backgroundColor: Color(0xff2FB176),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: 'Profile',
            backgroundColor: Color(0xff2FB176),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.request_page,
              color: Colors.white,
            ),
            label: 'Requests',
            backgroundColor: Color(0xff2FB176),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            label: 'Notifications',
            backgroundColor: Color(0xff2FB176),
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        iconSize: 20,
        onTap: onItemTapped,
        elevation: 5,
      ),
    );
  }
}
