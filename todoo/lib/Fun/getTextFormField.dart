import 'package:flutter/material.dart';

class genTextFormField extends StatelessWidget {
  TextEditingController controller;
  String hintName;
  IconData iconData;
  TextInputType textInputType;

  genTextFormField(
      {required this.controller,
      required this.hintName,
      required this.iconData,
      this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
          icon: Icon(iconData),
          hintText: hintName,
          labelText: "$hintName",
          fillColor: Colors.grey[100],
          filled: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Escreva uma $hintName';
        }
      },
    );
  }
}
