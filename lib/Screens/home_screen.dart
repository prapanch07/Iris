import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:healwiz/Screens/auth.dart';
import 'package:healwiz/Screens/disease%20screens/arthretis_screen.dart';
import 'package:healwiz/Screens/disease%20screens/covid_screen.dart';
import 'package:healwiz/Screens/disease%20screens/parkinson_screen.dart';
import 'package:healwiz/screens/disease%20screens/about.dart';
import 'package:healwiz/Screens/login.dart';
import 'package:healwiz/themes/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  String _userName = ''; // Variable to hold user's first name

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Get the user document from Firestore
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .get();

        // Check if the widget is still mounted before updating the state
        if (mounted) {
          // Get the user's name field from the document
          setState(() {
            _userName = snapshot['name'];
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<void> _signout() async {
    Auth().signOut();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => SignInScreen(),
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurple),
              accountName: Text(
                _userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.brown,
              ),
            ),
            CustomTextDrawer(
              drawertext: 'About us',
              function: () {},
            ),
            CustomTextDrawer(
              drawertext: 'Contact us',
              function: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'IRIS',
          style: TextStyle(color: AppColor.kWhite, letterSpacing: 1),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Auth().signOut();
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Predict Your Dieseas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const Gap(20),
            CustomListTile(
              predictfunction: () => _navigateToArthretis(context),
              diseasname: 'arthretis',
              icon: Icons.local_hospital,
            ),
            CustomListTile(
              predictfunction: () => _navigateToPnemonia_Covid(context),
              diseasname: 'pnewumonia/covid',
              icon: Icons.local_hospital,
            ),
            CustomListTile(
              predictfunction: () => _navigateToParkinsons(context),
              diseasname: 'parkinson',
              icon: Icons.local_hospital,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String diseasname;
  final IconData icon;
  final VoidCallback predictfunction;
  const CustomListTile(
      {super.key,
      required this.diseasname,
      required this.icon,
      required this.predictfunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.black26,
        ),
        child: Center(
          child: ListTile(
            leading: Icon(icon),
            title: Text(diseasname),
            trailing: PredictButton(
              function: predictfunction,
            ),
          ),
        ),
      ),
    );
  }
}

class PredictButton extends StatelessWidget {
  final VoidCallback function;
  const PredictButton({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        height: 38,
        width: 85,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Align(
          alignment: Alignment.center,
          child: Text(
            'Predict',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

void _navigateToArthretis(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ScreenArthreris(),
    ),
  );
}

void _navigateToPnemonia_Covid(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ScreenPnewmonia_Covid(),
    ),
  );
}

void _navigateToParkinsons(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ScreenParkinson(),
    ),
  );
}

class CustomTextDrawer extends StatelessWidget {
  final String drawertext;
  final VoidCallback function;
  const CustomTextDrawer(
      {Key? key, required this.drawertext, required this.function})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Text(drawertext),
    );
  }
}

void _navigateToAboutUs(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => AboutUsPage(),
    ),
  );
}
