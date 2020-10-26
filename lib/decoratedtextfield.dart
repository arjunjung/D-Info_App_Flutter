 import 'package:flutter/material.dart';

 Widget textfieldUsername(String text, TextEditingController controller) {
    return TextField(
      obscureText: true,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        fillColor: Colors.blue[40],
        labelText: text,
      ),
    );
  }

  Widget textfieldPassword(String text, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        fillColor: Colors.blue[40],
        labelText: text,
      ),
    );
  }