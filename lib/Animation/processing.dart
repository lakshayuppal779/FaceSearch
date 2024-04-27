import 'package:facesearch/Animation/searching.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../Random_image_generator/constant/constant.dart';

class Processing extends StatefulWidget {
  const Processing({super.key});

  @override
  State<Processing> createState() => _ProcessingState();
}

class _ProcessingState extends State<Processing> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Fluttertoast.showToast(
      msg: '👀 Processing Image...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      backgroundColor: themeColor2.withOpacity(0.7),
    );
    Future.delayed(const Duration(seconds: 6), (){
      Fluttertoast.showToast(
        msg: '✅ Image Processed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.lightGreen.withOpacity(0.7),
      );
    });
    Future.delayed(const Duration(seconds: 8), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Searching()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/Animation - 1714214131955.json'),
            SizedBox(
              height: 40,
            ),
            const Text(
              'Processing Image...',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: themeColor1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
