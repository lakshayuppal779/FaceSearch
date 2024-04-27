import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:facesearch/Random_image_generator/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:facesearch/Random_image_generator/constant/constant.dart'; // Ensure your constants are correctly imported

class DummyAPI {
  static const String _baseUrl = 'https://picsum.photos/v2';

  static Future<List<String>> fetchRandomImages() async {
    var response = await http.get(
      Uri.parse('$_baseUrl/list?page=4&limit=100'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> imageUrls =
          data.map<String>((photo) => photo['download_url']).toList();
      return imageUrls;
    } else {
      throw Exception('Failed to fetch random images');
    }
  }
}

class DummyAPIScreen extends StatefulWidget {
  const DummyAPIScreen({Key? key}) : super(key: key);

  @override
  State<DummyAPIScreen> createState() => _DummyAPIScreenState();
}

class _DummyAPIScreenState extends State<DummyAPIScreen> {
  List<String> _images = [];
  List<String> _displayImages = [];
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _fetchImages() {
    DummyAPI.fetchRandomImages().then((images) {
      setState(() {
        _images = images;
      });
      _startTimer();
    }).catchError((error) {
      log('Error fetching images: $error');
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentIndex < _images.length) {
        setState(() {
          _displayImages.add(_images[_currentIndex]);
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  final kTransparentImage = Uint8List.fromList([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
    0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
    0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
    0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
    0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
    0x42, 0x60, 0x82
  ]);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
        return false; // return false to prevent pop
      },
      child: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.center,
            child: Text(
              "Results",
              style: TextStyle(color: themeColor2, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        body: _displayImages.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 5.0, // Horizontal space between cards
                    mainAxisSpacing: 5.0, // Vertical space between cards
                  ),
                  itemCount: _images.length, // Use _images.length to fill grid with shimmer
                  itemBuilder: (BuildContext context, int index) {
                    return index < _displayImages.length
                        ? Card(
                            elevation: 6.0,
                            clipBehavior: Clip.antiAlias,
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: _displayImages[index],
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Card(
                              elevation: 6.0,
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          );
                  },
                ),
              ),
      ),
    );
  }
}
