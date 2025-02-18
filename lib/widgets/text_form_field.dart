import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  Function validation;
  Function onChange;
  TextEditingController controller;
  String text;
  TextInputType keyboardType;
  Icon icon;
  bool isPasswordField;
  bool hasSuffix;

  CustomTextField({required this.icon,
    required this.isPasswordField,required this.hasSuffix,
    required this.keyboardType,required this.validation,required this.onChange,required this.controller
    ,required this.text,
    super.key});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType:widget.keyboardType ,
      validator: (value) {
       return widget.validation(value);
      },
      onChanged:(value) {
        return widget.onChange();
      },
      controller: widget.controller,
      obscureText: widget.isPasswordField ? !_isPasswordVisible : false,
      style: Theme.of(context)
          .textTheme
          .titleSmall,
      decoration: InputDecoration(
        fillColor: Color(0xff282A28),
        filled: true,
        labelText: widget.text,
        prefixIcon: widget.icon,
        suffixText: widget.hasSuffix ? '' : null,
        suffixIcon: widget.isPasswordField?
        IconButton(icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off,),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },):null,

        labelStyle: Theme.of(context).textTheme.titleSmall,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

        ),
      ),
    )
    ;
  }
}
