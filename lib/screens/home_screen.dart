import 'dart:convert';

import 'package:databaselogin/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/usersData.dart';
import 'login_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  User? user;
  TextStyle titleStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.black,
  );
  TextStyle dataStyle = const TextStyle(
    fontSize: 14,
    color: Colors.black45,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("user"));
    user = User.fromMap(jsonDecode(prefs.getString("user")!));
    notify();
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          )
        : Scaffold(
            appBar: AppBar(backgroundColor: Colors.amberAccent[700]),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    title("Name"),
                    const SizedBox(
                      height: 8,
                    ),
                    dataWidget(user!.name!),
                    const SizedBox(
                      height: 18,
                    ),
                    title("Email"),
                    const SizedBox(
                      height: 8,
                    ),
                    dataWidget(user!.email!),
                    const SizedBox(
                      height: 50,
                    ),
                    Utility().customButton(
                      btnText: "LOGOUT",
                      onTap: () async {
                        showAlert();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  showAlert() {
    showDialog(
      // barrierDismissible: false,
      useSafeArea: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout?"),
          content: Text("Are you sure you want to Logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                logout();
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.amber),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
        );
      },
    );
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginPageScreen(),
        ),
        (Route<dynamic> route) => false);
  }

  Widget title(String titleText) {
    return Text(
      titleText,
      style: titleStyle,
    );
  }

  Widget dataWidget(String data) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        data,
        style: dataStyle,
      ),
    );
  }

  notify() {
    if (mounted) setState(() {});
  }
}
