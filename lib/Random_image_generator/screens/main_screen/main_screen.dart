import 'dart:async';
import 'dart:io';
import 'package:facesearch/Random_image_generator/screens/dummyAPI/lorem_picsum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../constant/constant.dart';
import '../../logic/logic.dart';
import '../../widgets/general_button/general_button.dart';
import '../../widgets/select_image_card/select_image_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var data = Get.put(Logic());
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[themeColor1, themeColor2],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)
  );

  Future<void> uploadImages(BuildContext context) async {
    const String apiUrl = 'https://freeimage.host/api/1/upload';
    const String apiKey = '6d207e02198a847aa98d0a2a901485a5';

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..fields['key'] = apiKey
      ..fields['action'] = 'upload'
      ..fields['format'] = 'json';

    for (var file in data.fileList) {
      if (file != null) {
        var pic = await http.MultipartFile.fromPath('source', file.path);
        request.files.add(pic);
      }
    }
    try {
      var streamedResponse = await request.send().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException("The request timed out");
          }
      );

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status_code'] == 200) {
          data.fileList.clear();
          data.widgetList.clear();
          setState(() {});
          Fluttertoast.showToast(
              msg: "Image uploaded successfully",
              backgroundColor: themeColor2.withOpacity(0.8),
              gravity: ToastGravity.SNACKBAR
          ).then((value) {
            Future.delayed(const Duration(milliseconds: 1500), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => dummyAPIScreen()),
              );
            });
          });

        } else {
          handleError(responseData['error']['message']);
        }
      } else {
        handleError("Server responded with status code: ${response.statusCode}");
      }
    } on TimeoutException catch (e) {
      handleError("The request timed out. Please try again later.");
    } on SocketException catch (e) {
      handleError("No Internet connection. Please check your network settings.");
    } on FormatException catch (e) {
      handleError("Bad response format. Please try again later.");
    } catch (e) {
      handleError("An unexpected error occurred. Please try again later.");
    }
  }

  void handleError(String message) {
    Fluttertoast.showToast(msg: message, backgroundColor: Colors.red.withOpacity(0.8), gravity: ToastGravity.CENTER);
  }

  Future<void> addImage() async {
    List<XFile>? images;
    if (data.source.value == ImageSource.camera) {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        data.fileList.add(File(image.path));
        data.widgetList.add(
          SizedBox(
            height: width * 0.45,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(width * 0.02),
              child: Image.memory(
                await data.fileList.last!.readAsBytes(),
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      }
    } else if (data.source.value == ImageSource.gallery) {
      images = await ImagePicker().pickMultiImage();
      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          data.fileList.add(File(image.path));
          data.widgetList.add(
            SizedBox(
              height: width * 0.45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(width * 0.02),
                child: Image.memory(
                  await File(image.path).readAsBytes(),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          );
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Face Search",
            style: TextStyle(foreground: Paint()..shader =  linearGradient),
          ),
        ),
        bottomNavigationBar: GeneralButton(
          label: "Upload",
          width: width,
          onTap: () {
            if (data.fileList.isNotEmpty) {
              uploadImages(context);
            }
            else {
              // Show a message if no images are selected
              Fluttertoast.showToast(
                  msg: "No image selected.",
                  backgroundColor: themeColor2.withOpacity(0.8),
                  gravity: ToastGravity.SNACKBAR
              );
            }
          },

        ),
        body: GetBuilder<Logic>(
            init: Logic(),
            builder: (logic) {
              return Container(
                padding: EdgeInsets.symmetric(
                    vertical: width * 0.04, horizontal: width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: width * 0.04, horizontal: width * 0.04),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() {
                                data.source.value = ImageSource.camera;
                              }),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: width * 0.03,
                                    horizontal: width * 0.03),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width * 0.02),
                                    gradient: data.source.value ==
                                            ImageSource.camera
                                        ? const LinearGradient(
                                            colors: [themeColor1, themeColor2])
                                        : null,
                                    color:
                                        data.source.value == ImageSource.camera
                                            ? null
                                            : Colors.grey),
                                alignment: Alignment.center,
                                child: Text(
                                  "Camera",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width * 0.045),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.04,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() {
                                data.source.value = ImageSource.gallery;
                              }),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: width * 0.03,
                                    horizontal: width * 0.03),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.02),
                                  color:
                                      logic.source.value == ImageSource.gallery
                                          ? null
                                          : Colors.grey,
                                  gradient: logic.source.value ==
                                          ImageSource.gallery
                                      ? const LinearGradient(
                                          colors: [themeColor1, themeColor2])
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Gallery",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width * 0.045),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SelectImageCard(
                      width: width,
                      onTap: () => addImage().catchError(
                          (e) => Fluttertoast.showToast(msg: "No Image selected",backgroundColor: themeColor1,gravity: ToastGravity.SNACKBAR)),
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: width * 0.04),
                          child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: width * 0.6,
                                  child: Dismissible(
                                      direction: DismissDirection.vertical,
                                      key: UniqueKey(),
                                      onDismissed: (onDismiss) {
                                        // remove item
                                        data.fileList.removeAt(index);
                                        data.widgetList.removeAt(index);
                                      },
                                      child: logic.widgetList[index]!),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: width * 0.04,
                                );
                              },
                              itemCount: logic.widgetList.length)),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
