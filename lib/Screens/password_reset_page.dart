import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healwiz/firebase/auth.dart';
import 'package:healwiz/themes/theme.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailcontroller = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final _size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
            onPressed: () => _navigatePop(context),
            icon: Icon(
              Icons.arrow_back_rounded,
              color: AppColor.kWhite,
            )),
        title: Text(
          'PasswordResetPage',
          style: TextStyle(
            color: AppColor.kWhite,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(_size.width / 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailcontroller,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('email to reset your password')),
                validator: (resetemail) {
                  if (resetemail == null ||
                      resetemail.isEmpty ||
                      !resetemail.contains("@")) {
                    return "Please enter some valid email address";
                  }
                  return null;
                },
              ),
              const Gap(10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    AuthMethods().resetPassword(
                      email: emailcontroller.text.trim().toLowerCase(),
                      context: context,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password reset email sent !!'),
                      ),
                    );
                    _navigatePop(context);
                  }
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.deepPurple),
                ),
                child: Text(
                  'Reset Password',
                  style: TextStyle(color: AppColor.kWhite, fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _navigatePop(BuildContext context) {
  Navigator.of(context).pop();
}
