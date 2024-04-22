import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../widgets/general_button/general_button.dart';

class DummyAPI {
  static const String _baseUrl = 'https://picsum.photos/v2';

  static Future<List<String>> fetchRandomImages() async {
    var response = await http.get(
      Uri.parse('$_baseUrl/list?page=3&limit=100'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> imageUrls = data.map<String>((photo) => photo['download_url']).toList();
      return imageUrls;
    } else {
      throw Exception('Failed to fetch random images');
    }
  }
}

class dummyAPIScreen extends StatefulWidget {
  const dummyAPIScreen({Key? key}) : super(key: key);

  @override
  State<dummyAPIScreen> createState() => _dummyAPIScreenState();
}

class _dummyAPIScreenState extends State<dummyAPIScreen> {
  List<String> _images = [];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _fetchImages() {
    DummyAPI.fetchRandomImages().then((images) {
      setState(() {
        _images = images;
        _currentIndex = 0;
        _startTimer();
      });
    }).catchError((error) {
      log('Error fetching images: $error');
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        // Increment the index to display the next image
        _currentIndex = (_currentIndex + 1) % _images.length;
      });
    });
  }

  void _stopGenerating() {
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Face Search"),
      ),
      bottomNavigationBar: GeneralButton(
        label: "Stop Generating",
        width: width,
        onTap: _stopGenerating,
      ),
      body: Center(
        child: _images.isEmpty
            ? CircularProgressIndicator()
            : Image.network(_images[_currentIndex]),
      ),
    );
  }
}
