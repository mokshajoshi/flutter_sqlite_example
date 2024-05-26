import 'dart:convert';

import 'package:databaselogin/database/usersData.dart';
import 'package:databaselogin/screens/home_screen.dart';
import 'package:databaselogin/screens/signup_screen.dart';
import 'package:databaselogin/utility/utility.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageScreen extends StatefulWidget {
  const LoginPageScreen({super.key});

  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  late TextEditingController _eMailController, _pswController;
  bool isShow = false;

  @override
  void initState() {
    super.initState();

    _eMailController = TextEditingController();
    _pswController = TextEditingController();
  }

  @override
  void dispose() {
    _eMailController.dispose();
    _pswController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amberAccent[700]),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              const Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Please sign in to continue.",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(
                height: 45,
              ),
              Utility().inputField(_eMailController, false,
                  Icons.mail_outline_sharp, "EMAIL", const Text("")),
              Utility().inputField(
                _pswController,
                !isShow,
                Icons.lock_outline_sharp,
                "PASSWORD",
                GestureDetector(
                  onTap: () {
                    isShow = !isShow;
                    notify();
                  },
                  child: Icon(
                    isShow ? Icons.visibility_off : Icons.visibility,
                    color: Colors.amber,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Utility().customButton(
                btnText: "LOGIN",
                onTap: () async {
                  if (_eMailController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please enter email");
                  } else if (!RegExp(r'\S+@\S+\.\S+')
                      .hasMatch(_eMailController.text)) {
                    Fluttertoast.showToast(msg: "Please enter valid email");
                  } else if (_pswController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please enter password");
                  } else if (!RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                      .hasMatch(_pswController.text)) {
                    Fluttertoast.showToast(msg: "Please enter valid password");
                  } else if ((await DatabaseHelper.instance.getUser(
                          _eMailController.text, _pswController.text)) ==
                      null) {
                    Fluttertoast.showToast(msg: "Invalid User");
                  } else {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString(
                        "user",
                        jsonEncode((await DatabaseHelper.instance.getUser(
                                _eMailController.text, _pswController.text))!
                            .toMap()));
                    Fluttertoast.showToast(msg: "Login successfully..");
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const HomePageScreen(),
                        ),
                        (Route<dynamic> route) => false);
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.grey[600])),
                      TextSpan(
                        text: "Sign up",
                        style: TextStyle(
                            color: Colors.amberAccent[700],
                            fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  notify() {
    if (mounted) setState(() {});
  }
}
