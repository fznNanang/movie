import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:movie/model/popularMovie.dart';
import 'package:movie/pages/detail/mainDetail.dart';
import 'package:movie/services/serviceApi.dart';


class Popular extends StatefulWidget {
  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  late List<bool> isLikedPopular;
  late List<bool> isWatchListPopular;
  final localData = GetStorage();
  // eksekusi simpan gambar 
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

  //dialog untuk save gambar kedalam phone storage
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
  void initState(){
    super.initState();
    isLikedPopular = List.generate(6, (index) => false);
    isWatchListPopular = List.generate(20, (index) => false);
  }
  @override
  Widget build(BuildContext context){
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return 
    //ambil data dan cek apakah data ada atau tidak
    FutureBuilder<List<PopularMovieModel>?>(
                future: HomeService.fetchPopularMovie(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    List<PopularMovieModel> itemsPopular = snapshot.data!.take(20).toList();

                    if (isLikedPopular.length != itemsPopular.length) {
                      isLikedPopular = List.generate(itemsPopular.length, (index) => false);
                    }
                    if (isWatchListPopular.length != itemsPopular.length) {
                      isWatchListPopular = List.generate(itemsPopular.length, (index) => false);
                    }

                      void updateWatchListPopular(int index) {
                        setState(() {
                          isWatchListPopular[index] = !isWatchListPopular[index];
                          var movie = itemsPopular[index];
                          var currentWatchList = localData.read('watchListPopular') ?? [];

                          if (isWatchListPopular[index]) {
                            // Menambahkan film ke watchListPopular
                            currentWatchList.add(movie.toJson());
                          } else {
                            // Menghapus film dari watchListPopular, dengan pemeriksaan tipe data
                            currentWatchList = currentWatchList.where((item) {
                              return item is Map<String, dynamic> && item['id'] != movie.id;
                            }).toList();
                          }

                          localData.write('watchListPopular', currentWatchList);
                        });
                      }

                      void updateFavorite(int index) {
                          setState(() {
                            isLikedPopular[index] = !isLikedPopular[index];
                            var movie = itemsPopular[index];
                            var currentFav = localData.read('favorite') ?? [];

                            if (isLikedPopular[index]) {
                              // Menambahkan film ke favorite
                              currentFav.add(movie.toJson());
                            } else {
                              // Menghapus film dari favorite, dengan pemeriksaan tipe data
                              currentFav = currentFav.where((item) {
                                return item is Map<String, dynamic> && item['id'] != movie.id;
                              }).toList();
                            }

                            localData.write('favorite', currentFav);
                          });
                        }



                    return CarouselSlider.builder(
                      itemCount: itemsPopular.length,
                      itemBuilder: (context, index, realIndex) {
                        PopularMovieModel data = itemsPopular[index];
                        double convertedRating = data.voteAverage != null ? data.voteAverage! / 2.0 : 0.0;
                        return GestureDetector(
                          onTap: () {
                            Get.to(MainDetail(id: data.id.toString()));
                          },
                          onLongPress: () {
                            showSaveImageDialog(context, 'https://image.tmdb.org/t/p/original${data.posterPath}');
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: width * 0.6,
                                  height: height * 0.35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        spreadRadius: 3,
                                        blurRadius: 4,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: NetworkImage('https://image.tmdb.org/t/p/original${data.posterPath}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                updateFavorite(index);
                                                print(localData.read("favorite"));
                                              });
                                            },
                                            child: Icon(
                                              isLikedPopular[index]
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isLikedPopular[index] ? Colors.red : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              updateWatchListPopular(index);
                                              print(localData.read("watchListPopular"));
                                            },
                                            child: Icon(
                                              isWatchListPopular[index]
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_border,
                                              color: isWatchListPopular[index] ? Colors.yellow : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                data.title ?? '',
                                style: TextStyle(
                                  fontSize: width * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: height * 0.005),
                              RatingBar.builder(
                                initialRating: convertedRating,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                ignoreGestures: true,
                                itemCount: 5,
                                itemSize: width * 0.05,
                                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      //pengaturan carousel
                      options: CarouselOptions(
                        height: height * 0.45,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        viewportFraction: 0.5
                      ),
                    );
                  }
                },
              );
  }
}