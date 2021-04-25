import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardButton extends StatelessWidget {
  final Color? fill;
  final String? text;
  final Function? onPressed;

  OnboardButton({this.fill, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: RawMaterialButton(
        fillColor: fill,
        splashColor: Colors.yellowAccent,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Text(text!,
                maxLines: 1,
                style: TextStyle(
                    color:
                        (fill == Colors.white ? Colors.yellow : Colors.white),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
        ),
        onPressed: onPressed as void Function()?,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}

class SignInField extends StatefulWidget {
  final String? hint, label, initialText;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final bool obscure, isLast;
  final TextInputType inputType;
  final TextEditingController? controller;

  SignInField(
      {required this.validator,
      required this.onChanged,
      required this.obscure,
      required this.hint,
      required this.isLast,
      required this.inputType,
      this.label,
      this.initialText,
      this.controller});

  @override
  _SignInFieldState createState() => _SignInFieldState();
}

/// Widget to create and style a field form
class _SignInFieldState extends State<SignInField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        initialValue: widget.initialText,
        textInputAction:
            widget.isLast ? TextInputAction.done : TextInputAction.next,
        onFieldSubmitted: (v) {
          if (!widget.isLast) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          focusColor: Colors.deepPurple,
          labelText: widget.label,
        ),
        keyboardType: widget.inputType,
        onChanged: widget.onChanged,
        obscureText: widget.obscure,
        validator: widget.validator,
      ),
    );
  }

  String getLabel() {
    return widget.label ?? '';
  }
}
