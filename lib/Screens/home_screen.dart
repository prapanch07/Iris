import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:healwiz/firebase/auth.dart';
import 'package:healwiz/Screens/onboarding_screen.dart';
import 'package:healwiz/Screens/disease%20screens/chest%20disease.dart';
import 'package:healwiz/Screens/disease%20screens/alzheimer.dart';
import 'package:healwiz/Screens/disease%20screens/arthritis.dart';
import 'package:healwiz/Screens/about.dart';
import 'package:healwiz/Screens/contact.dart';
import 'package:healwiz/themes/theme.dart';
import 'package:healwiz/Screens/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                .collection('users')
                .doc(user.uid)
                .get();

        // Check if the widget is still mounted before updating the state
        if (mounted) {
          // Get the user's name field from the document
          setState(() {
            _userName = snapshot['username'];
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  // Future<void> _signout() async {
  //   Auth().signOut();

  //   Navigator.of(context).pushReplacement(MaterialPageRoute(
  //     builder: (context) => SignInScreen(),
  //   ));
  // }
  void _customSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: const Text(''),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.brown,
                backgroundImage: AssetImage('assets/avatar.jpg'),
              ),
            ),
            CustomTextDrawer(
              drawertext: 'About us',
              function: () => _navigateToAboutUs(context),
            ),
            CustomTextDrawer(
              drawertext: 'Contact us',
              function: () => _navigateTocontactUsPage(context),
            ),
            CustomTextDrawer(
              drawertext: 'sign out',
              function: () {
                AuthMethods().signout();
                _customSnackBar(context, 'logged out');
                _navigateToIntroductionPageView(context);
              },
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose the Disease',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const Gap(10),
              CustomListTile(
                predictFunction: () => _navigateToArthretis(context),
                diseaseName: 'Chest',
                imagePath: 'assets/11.png',
              ),
              CustomListTile(
                predictFunction: () => _navigateToPnemonia_Covid(context),
                diseaseName: 'Alzheimer',
                imagePath: 'assets/13.png',
              ),
              CustomListTile(
                predictFunction: () => _navigateToParkinsons(context),
                diseaseName: 'Parkinson',
                imagePath: 'assets/12.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String diseaseName;
  final String imagePath;
  final VoidCallback predictFunction;

  const CustomListTile({
    Key? key,
    required this.diseaseName,
    required this.imagePath,
    required this.predictFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: GestureDetector(
        onTap: () => predictFunction(),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(30), // Clip the image with curved borders
          child: Image.asset(
            imagePath,
            width: 350,
            height: 220,
            fit: BoxFit.fill,
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
      builder: (context) => const ScreenChestDisease(),
    ),
  );
}

void _navigateToPnemonia_Covid(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const ScreenAlzheimer(),
    ),
  );
}

void _navigateToParkinsons(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const ScreenArthritis(),
    ),
  );
}

void _navigateToAboutUs(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => AboutUsPage(),
    ),
  );
}

void _navigateTocontactUsPage(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ContactUsPage(),
    ),
  );
}

void _navigateToIntroductionPageView(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const IntroductionPageView(),
    ),
  );
}

class CustomTextDrawer extends StatelessWidget {
  final String drawertext;
  final VoidCallback function;
  const CustomTextDrawer(
      {super.key, required this.drawertext, required this.function});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function, // Invoke the function with BuildContext parameter
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 24), // Adjust padding here
        child: Text(
          drawertext,
          style: TextStyle(fontSize: 18), // Adjust text size here
        ),
      ),
    );
  }
}
