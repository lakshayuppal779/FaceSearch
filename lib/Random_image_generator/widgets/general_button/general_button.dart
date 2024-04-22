
import 'package:flutter/material.dart';
import '../../constant/constant.dart';

class GeneralButton extends StatelessWidget {
  const GeneralButton(
      {super.key, required this.width, required this.onTap,required this.label});
  final double width;
  final Function()? onTap;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width * 0.02),
          gradient: const LinearGradient(colors: [themeColor2, themeColor1]),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all<double?>(0.0),
              backgroundColor:
              MaterialStateProperty.all<Color>(Colors.transparent)),
          onPressed: onTap,
          child: Text(
            label, // Display the label text on the button
            style: const TextStyle(
              color: Colors.white, // Button text color
              fontSize: 16.0, // Button text size
            ),
          ),
        ),
      ),
    );
  }
}
