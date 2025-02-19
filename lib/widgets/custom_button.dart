import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String text;
  Color color;
  Color textColor;
   CustomButton({super.key,required this.text,required this.color,required this.textColor});

  @override
  Widget build(BuildContext context) {
    return  Container(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () async{
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor:color,
            ),
            child: Text(text,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: textColor)
            )));

  }
}
