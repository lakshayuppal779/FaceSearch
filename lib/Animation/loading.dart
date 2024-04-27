import 'dart:math';
import 'package:facesearch/Animation/processing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../Random_image_generator/constant/constant.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading>with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;
  int i=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Fluttertoast.showToast(
      msg: 'Uploading Image...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      backgroundColor: themeColor2.withOpacity(0.8),
    );
    _controller = AnimationController(duration: const Duration(seconds: 5),vsync: this);
    animation=Tween<double>(begin: 0,end: 100).animate(_controller)..addListener(() {
      setState(() {
        i=animation.value.toInt();
      });
    });
    _controller.forward();
    Future.delayed(const Duration(seconds:5), (){
      Fluttertoast.showToast(
        msg: '✅ Image Uploaded',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor:Colors.lightGreen.withOpacity(0.7),
      );
    });
    Future.delayed(const Duration(seconds: 7), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Processing()));
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularStepProgressIndicator(
              totalSteps: i==0?1:i,
              currentStep: i,
              padding: pi/70,
              arcSize: ((pi*2)/100)*i,
              selectedColor: themeColor2,
              unselectedColor: themeColor1,
              stepSize: 30,
              width: 250,
              height: 250,
              startingAngle: 0,
              child: Center(
                child: Text('$i%',textDirection: TextDirection.rtl,style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w500,
                    color: themeColor1,
                )),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text('Uploading Image...',style: TextStyle(
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
