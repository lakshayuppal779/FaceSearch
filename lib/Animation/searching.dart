import 'package:facesearch/Random_image_generator/screens/dummyAPI/lorem_picsum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../Random_image_generator/constant/constant.dart';

class Searching extends StatefulWidget {
  const Searching({super.key});

  @override
  State<Searching> createState() => _SearchingState();
}

class _SearchingState extends State<Searching> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Fluttertoast.showToast(
      msg: '🔍 Searching Web...',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      backgroundColor: themeColor2.withOpacity(0.8),
    );
    Future.delayed(const Duration(seconds: 6), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const DummyAPIScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/Animation - 1714215163529 (2).json'),
            SizedBox(
              height: 20,
            ),
            const Text(
              'Searching the Web...',
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
