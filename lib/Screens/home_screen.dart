import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:healwiz/Screens/auth.dart';
import 'package:healwiz/Screens/onboarding_screen.dart';
import 'package:healwiz/Screens/disease%20screens/arthretis_screen.dart';
import 'package:healwiz/Screens/disease%20screens/covid_screen.dart';
import 'package:healwiz/Screens/disease%20screens/parkinson_screen.dart';
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

  Future<void> _signout()async {
    Auth().signOut();

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInScreen() ,));

  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(children:  [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurple
              
            ),
            accountName: Text(_userName ,style: TextStyle(fontWeight: FontWeight.bold,),), 
            accountEmail: Text(''),
            currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.brown,
            backgroundImage: AssetImage('assets/avatar.jpg'),          
            ),),
                 CustomTextDrawer(
              drawertext: 'About us',
              function: _navigateToAboutUs,
            ),
            CustomTextDrawer(
              drawertext: 'Contact us',
              function: _navigateTocontactUsPage,
            ),
            CustomTextDrawer(
              drawertext: 'sign out',
              function: _navigateToIntroductionPageView,
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
      body: Padding(
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
            const Gap(20),
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
    );
  }
}

class CustomListTile extends StatefulWidget {
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
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isTapped = true;
          });
          widget.predictFunction();
        },
        onTapCancel: () {
          setState(() {
            _isTapped = false;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isTapped = false;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: 220,
          width: 350,
          decoration: BoxDecoration(
            color: _isTapped ? Colors.deepPurple : Colors.black26,
            borderRadius: BorderRadius.circular(30), // Adjust the radius for curved edges
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30), // Clip the image with curved borders
            child: Center(
              child: Image.asset(
                widget.imagePath,
                width: 350,
                height: 220,
                fit: BoxFit.fill,
              ),
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
      builder: (context) => ScreenAlzheimer(),
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
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => IntroductionPageView(),
    ),
  );
}
class CustomTextDrawer extends StatelessWidget {
  final String drawertext;
  final void Function(BuildContext) function; // Accepts a function with BuildContext parameter
  const CustomTextDrawer({Key? key, required this.drawertext, required this.function})
      : super(key: key);

  @override
   Widget build(BuildContext context) {
    return InkWell(
      onTap: () => function(context), // Invoke the function with BuildContext parameter
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Adjust padding here
        child: Text(
          drawertext,
          style: TextStyle(fontSize: 18), // Adjust text size here
        ),
      ),
    );
  }
}
