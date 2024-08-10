import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:movie/helpers/appColor.dart';
import 'package:movie/model/nowPlay.dart';
import 'package:movie/model/popularMovie.dart';
import 'package:movie/pages/detail/mainDetail.dart';
import 'package:movie/pages/home/now.dart';
import 'package:movie/pages/home/popular.dart';
import 'package:movie/pages/profile/mainProfile.dart';
import 'package:movie/pages/watchlist/mainWatchList.dart';
import 'package:movie/services/serviceApi.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final localData = GetStorage();

  // Use late keyword for deferred initialization
  late List<bool> isLiked;
  late List<bool> isWatchList;
  

  // Function to save image
  Future<void> saveImage(Uint8List bytes, String fileName) async {
    final result = await ImageGallerySaver.saveImage(
      bytes,
      quality: 60,
      name: fileName,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gambar Disimpan')),
    );
  }

  // Function to show save image dialog
  Future<void> showSaveImageDialog(BuildContext context, String imageUrl) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda Ingin Menyimpan Gambar?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Simpan'),
              onPressed: () async {
                Navigator.of(context).pop();

                // Download the image
                var response = await Dio().get(
                  imageUrl,
                  options: Options(responseType: ResponseType.bytes),
                );
                Uint8List bytes = Uint8List.fromList(response.data);

                // Save Image
                await saveImage(bytes, 'movie_poster');
                print(saveImage.toString());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Initial state
    isLiked = [];
    isWatchList = [];
    
  }

  void updateWatchList(int index) {
    setState(() {
      isWatchList[index] = !isWatchList[index];
      localData.write('watchList', isWatchList);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header profile home
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Row(
                  children: [
                    Container(
                      width: width * 0.9,
                      height: height * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.secondary, width: 3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Hi, Nanang Fauzan Najib",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(MainProfile());
                            },
                            child: Container(
                              width: width * 0.3,
                              height: height * 0.1,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColor.third, width: 3),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  "N",
                                  style: TextStyle(
                                    fontSize: width * 0.1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Now Playing Section
              Padding(
                padding: EdgeInsets.only(top: height * 0.025, left: width * 0.05),
                child: Text(
                  "Now Playing",
                  style: TextStyle(
                    fontSize: width * 0.075,
                    fontWeight: FontWeight.bold,
                    color: AppColor.third,
                  ),
                ),
              ),
              SizedBox(height: height * 0.015),
              Now(),

              // Popular Movies Section
              Padding(
                padding: EdgeInsets.only(top: height * 0.025, left: width * 0.05),
                child: Text(
                  "Popular Movies",
                  style: TextStyle(
                    fontSize: width * 0.075,
                    fontWeight: FontWeight.bold,
                    color: AppColor.third,
                  ),
                ),
              ),
              SizedBox(height: height * 0.015),
              Popular()
            ],
          ),
        ),
      ),
    );
  }
}
