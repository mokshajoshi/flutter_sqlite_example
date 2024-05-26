import 'package:flutter/material.dart';

class Utility {
  Widget inputField(TextEditingController controller, bool obscureText,
      IconData icon, String titleText, Widget widget) {
    return Card(
      color: Colors.grey[100],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: titleText,
                labelStyle: TextStyle(
                    color: Colors.grey[700], fontWeight: FontWeight.bold))),
        trailing: widget,
      ),
    );
  }

  Widget customButton({String btnText = "", Function()? onTap}) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 200),
        padding: const EdgeInsets.all(12),
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: Colors.amberAccent[700],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              btnText,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.arrow_forward_sharp,
              color: Colors.white,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
