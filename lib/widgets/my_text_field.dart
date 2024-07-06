import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hint;
  final Function validator;
  final TextEditingController controller;

  const MyTextField({super.key, required this.hint, required this.validator, required this.controller});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.always,
          validator: (value) => widget.validator(value),
          controller: widget.controller,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(16.0),
              ),
              focusColor: Colors.amber[100],
              hintText: widget.hint,
              hintStyle: const TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}
