import 'package:flutter/material.dart';
import 'package:healwiz/themes/theme.dart'; 

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'About Us',
          style: TextStyle(color: AppColor.kWhite),
        ),
      ),
      body:const Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( 
              'Welcome to Our App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'About Our Project:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Our project focuses on disease detection using machine learning techniques. We utilize MRI data to analyze and diagnose diseases with high accuracy.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Team Members:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Our team consists of:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '- Adithyan M',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- Adhithyan s',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- Gautham SB',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '- Sreehari AL',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Contact Us:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'If you have any questions or feedback, please feel free to reach out to us at contact@yourdomain.com.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
