import 'package:facesearch/Animation/processing.dart';
import 'package:facesearch/Animation/loading.dart';
import 'package:facesearch/Animation/searching.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:facesearch/Random_image_generator/screens/main_screen/main_screen.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // Bottom bar color
    statusBarColor: Colors.white, // Status bar color
    statusBarIconBrightness: Brightness.dark, // Status bar icons' brightness
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Face Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
