import 'package:carousel_slider/carousel_slider.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:movie/helpers/appColor.dart';
import 'package:movie/model/detailMovie.dart';
import 'package:movie/model/similar.dart';
import 'package:movie/services/serviceApi.dart';


class MainDetail extends StatefulWidget {
  final String id;
  MainDetail({required this.id});
  

  @override
  _MainDetailState createState() => _MainDetailState();
}

class _MainDetailState extends State<MainDetail> {
   String? currentMovieId;

  @override
  void initState() {
    super.initState();
    // Initialize with the initial movie ID
    currentMovieId = widget.id;
  }
  @override
  Widget build(BuildContext context) {
    DMethod.printTitle("ID MOVIE - ",widget.id.toString());
    double width = MediaQuery.of(context).size.width;
     double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<DetailMovieModel?>(
                future: HomeService.fetchDetailMovie(currentMovieId!),
                 builder: (context,snapshot){
                   if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return Center(child: Text('No data available'));
                      } else {
                        DetailMovieModel dataMovie = snapshot.data!;
                         double convertedRating = dataMovie.voteAverage != null ? dataMovie.voteAverage! / 2.0 : 0.0;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  width: width,
                                  height: height*0.65,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        "https://image.tmdb.org/t/p/w500${dataMovie.backdropPath}"),
                                        fit: BoxFit.cover
                                        ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25)
                                    )
                                  ),
                                ),
                                Container(
                                  width: width,
                                  height: height*0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25)
                                    ),
                                     gradient: LinearGradient(
                                          colors: [

                                            Colors.white.withOpacity(0.8), // Atur nilai opacity di sini
                                            Colors.transparent.withOpacity(0.6),  // Atur nilai opacity di sini
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.symmetric(horizontal: width*0.045,vertical:height*0.015),
                                        child: Text("${dataMovie.title}",
                                        style:TextStyle(
                                          fontSize: width*0.065,
                                          fontWeight: FontWeight.bold,
                                          color:Colors.white
                                        )
                                        ),
                                      ),
                                    Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child:
                                            RatingBar.builder(
                                                initialRating: convertedRating,
                                                minRating: 1,
                                                itemSize: 15.0, // Ukuran bintang
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemBuilder: (context, index) => Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  // Tangani pembaruan rating jika diperlukan
                                                },
                                        ),
                                      ),
                                      SizedBox(width: width*0.035,),
                                      Flexible(child: Text(
                                              "${dataMovie.voteAverage!.toStringAsFixed(1)}",
                                              style: TextStyle(
                                                fontSize: width * 0.075,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                        ),
                                        SizedBox(width: width*0.1,),
                                        Flexible(child: Text(
                                              "${dataMovie.runtime} mins",
                                              style: TextStyle(
                                                fontSize: width * 0.05,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),)
                                    ],
                                  ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height:height*0.025),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: width*0.015),
                              child: Text("${dataMovie.overview}",
                              style:TextStyle(
                                fontSize: width*0.045,
                                color:Colors.white,
                                fontWeight: FontWeight.w600
                              )
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Action for button press
                                },
                                child: Text('Tambahkan ke Tonton Nanti',
                                style:TextStyle(
                                  fontSize: width*0.05,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.white
                                )
                                ),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 50),
                                  backgroundColor: Colors.pink,
                                  
                                  
                                ),
                              )
                            )
                            ),

                            //SIMILAR MOVIE BODY
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: width*0.015,vertical:height*0.015),
                              child: Text("Similar Movie",
                              style:TextStyle(
                                fontSize: width*0.065,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              )
                              ),
                            ),
                            FutureBuilder<List<SimilarMovieModel>?>(
                              future: HomeService.fetchSimilar(currentMovieId!),
                               builder: ((context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return Center(child: Text('No data available'));
                                  } else {
                                    List <SimilarMovieModel> similar = snapshot.data!;
                                    return CarouselSlider.builder(
                                      itemCount: similar.length,
                                       itemBuilder: (ctx,i,realIndex){
                                        SimilarMovieModel dataSimilar = similar[i];
                                        return Column(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: (){
                                                   setState(() {
                                                     currentMovieId = dataSimilar.id.toString();
                                                   });
                                                },
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
                                                      image: NetworkImage('https://image.tmdb.org/t/p/original${dataSimilar.posterPath}'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                       },
                                        options: CarouselOptions(
                                          height: height * 0.45,
                                          enableInfiniteScroll: false,
                                          enlargeCenterPage: true,
                                          autoPlay: true,
                                          viewportFraction: 0.5
                                        )
                                    );
                                  }
                               }))
                          ],
                        );
                      }
                 })
            ],
          ),
        ),
      ),
    );
  }
}