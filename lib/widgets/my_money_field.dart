import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyMoneyTextField extends StatefulWidget {
  final TextEditingController controller;

  const MyMoneyTextField({super.key, required this.controller});

  @override
  State<MyMoneyTextField> createState() => _MyMoneyTextFieldState();
}

class _MyMoneyTextFieldState extends State<MyMoneyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        labelText: "Amount RM ${(double.tryParse(widget.controller.text) ?? 0.0)}",
        prefix: const Text("RM "),
        filled: true,
        fillColor: Colors.grey[100],
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [MoneyFormatter(separator: ".")],
    );
  }
}

class MoneyFormatter extends TextInputFormatter {
  final String separator;
  MoneyFormatter({
    required this.separator,
  });
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    newValue = TextEditingValue(
      text: int.tryParse(newValue.text.replaceAll(".", "")).toString(),
      selection: TextSelection.collapsed(
        offset: newValue.selection.end + 1,
      ),
    );
    debugPrint(newValue.text);
    if (newValue.text.length > 2) {
      return TextEditingValue(
        text: '${newValue.text.substring(0, newValue.text.length - 2)}$separator${newValue.text.substring(newValue.text.length - 2)}',
        selection: TextSelection.collapsed(
          offset: newValue.selection.end + 1,
        ),
      );
    } else if (newValue.text.length == 2) {
      return TextEditingValue(
        text: "0$separator${newValue.text}",
        selection: TextSelection.collapsed(
          offset: newValue.selection.end + 1,
        ),
      );
    } else if (newValue.text.length == 1) {
      return TextEditingValue(
        text: "0${separator}0${newValue.text}",
        selection: TextSelection.collapsed(
          offset: newValue.selection.end + 3,
        ),
      );
    } else {
      return TextEditingValue(
        text: "0${separator}0",
        selection: TextSelection.collapsed(
          offset: newValue.selection.end + 3,
        ),
      );
    }
  }
}
