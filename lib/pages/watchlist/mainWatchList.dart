import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:movie/helpers/appColor.dart';
import 'package:movie/model/popularMovie.dart';

class MainWatchList extends StatefulWidget {
  const MainWatchList({Key? key}) : super(key: key);

  @override
  _MainWatchListState createState() => _MainWatchListState();
}

class _MainWatchListState extends State<MainWatchList> {
  final localData = GetStorage();

  @override
  Widget build(BuildContext context) {
    // Membaca data dari GetStorage
    var watchListPopularData = localData.read('watchListPopular');

    // Memverifikasi data yang dibaca
    List<PopularMovieModel> watchListPopular = [];
    if (watchListPopularData != null && watchListPopularData is List) {
      watchListPopular = watchListPopularData.map((data) {
        if (data is Map<String, dynamic>) {
          return PopularMovieModel.fromJson(data);
        }
        return null;
      }).where((element) => element != null).cast<PopularMovieModel>().toList();
    }
    
    DMethod.printTitle("Data WatchList- ", watchListPopularData.toString());
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor.primary,
        body: watchListPopular.isEmpty
          ? Center(child: Text('No movies in watch list'))
          : ListView.builder(
              itemCount: watchListPopular.length,
              itemBuilder: (context, index) {
                var movie = watchListPopular[index];
                double convertedRating = movie.voteAverage != null ? movie.voteAverage! / 2.0 : 0.0;
                return Padding(
                  padding:  EdgeInsets.all(10),
                  child: Container(
                    width:width,
                    height: height*0.125,
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color:AppColor.third,width: 2)
                    ),
                    child:Row(
                      children: [
                         Padding(
                           padding:  EdgeInsets.symmetric(horizontal: 10),
                           child: Container(
                            width: width*0.2,
                            height:height*0.1,
                              decoration:BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(image: NetworkImage("https://image.tmdb.org/t/p/w500/${movie.posterPath}"),
                                fit: BoxFit.cover
                                )
                              )
                            ),
                         ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${movie.title}",
                                style: TextStyle(fontSize: width*0.045,color: Colors.white,fontWeight: FontWeight.bold),),
                                Row(
                                  children: [
                                    Icon(Icons.star,color: Colors.yellow,),
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal:width*0.015),
                                      child: Text("${convertedRating.toStringAsFixed(1)}",
                                      style: TextStyle(fontSize: width*0.045,color: Colors.white,fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          )
                      ],
                    )
                  ),
                );
              },
            ),
    );
  }
}
