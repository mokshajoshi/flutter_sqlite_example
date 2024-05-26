import 'package:databaselogin/database/usersData.dart';
import 'package:databaselogin/screens/login_screen.dart';
import 'package:databaselogin/utility/utility.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _fNameController,
      _eMailController,
      _pswController,
      _confirmController;
  bool isShow = false;
  bool isShowCnf = false;

  @override
  void initState() {
    super.initState();
    _fNameController = TextEditingController();
    _eMailController = TextEditingController();
    _pswController = TextEditingController();
    _confirmController = TextEditingController();
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _eMailController.dispose();
    _pswController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent[700],
        leading: Container(),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60,
            ),
            const Text(
              "Create Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            Utility().inputField(_fNameController, false, Icons.person,
                "FULL NAME", const Text("")),
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
            Utility().inputField(
              _confirmController,
              !isShowCnf,
              Icons.lock_outline_sharp,
              "CONFIRM PASSWORD",
              GestureDetector(
                onTap: () {
                  isShowCnf = !isShowCnf;
                  notify();
                },
                child: Icon(
                  isShowCnf ? Icons.visibility_off : Icons.visibility,
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Utility().customButton(
              btnText: "SIGN UP",
              onTap: () async {
                if (_fNameController.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Please enter first name");
                } else if (_eMailController.text.isEmpty) {
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
                } else if (_confirmController.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Please enter confirm password");
                } else if (_pswController.text != _confirmController.text) {
                  Fluttertoast.showToast(msg: "Password does not match");
                } else if ((await DatabaseHelper.instance.getEmail(
                      _eMailController.text,
                    )) !=
                    null) {
                  Fluttertoast.showToast(msg: "Email already exsists..");
                } else {
                  DatabaseHelper.instance.insertUser(User(
                      name: _fNameController.text,
                      email: _eMailController.text,
                      password: _pswController.text,
                      cnfpass: _confirmController.text));
                  Fluttertoast.showToast(msg: "Registered successfully..");
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const LoginPageScreen(),
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
                    text: TextSpan(children: [
                  TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.grey[600])),
                  TextSpan(
                      text: "Sign in",
                      style: TextStyle(
                          color: Colors.amberAccent[700],
                          fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => LoginPageScreen()));
                          Navigator.pop(context);
                        })
                ])))
          ],
        ),
      )),
    );
  }

  notify() {
    if (mounted) setState(() {});
  }
}
