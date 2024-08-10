import 'dart:convert';
import 'dart:io';

import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/model/detailMovie.dart';
import 'package:movie/model/nowPlay.dart';
import 'package:movie/model/popularMovie.dart';
import 'package:movie/model/similar.dart';

class HomeService {

  static Map<String, String> headersReq = {
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkMGY2ZmIwOTQ3MjQ4ZmVlYTExMDNiMWQ1ZDI5NWJhZSIsIm5iZiI6MTcyMjg0NzM1Ny40NjgwNDQsInN1YiI6IjY1MTM4ZDIxYTE5OWE2MDBjNDliYjdkZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9uykxFtV_ADYCAlK9NBvgOCp0A5FfO6chtvIPXFYpLo",
      'Content-Type': 'application/json'
  };


  static Future<List<NowPlayModel>?> fetchPlayNow() async {
    final String url = "https://api.themoviedb.org/3/movie/now_playing";
    

    try {
      var response = await http.get(Uri.parse(url), headers: headersReq);
      if (response.statusCode == 200) {
        DMethod.printTitle("Sukses Mendapat Data Play Now - ", response.body.toString());
        var jsonData = jsonDecode(response.body);
        
        // Cetak jsonData untuk memeriksa strukturnya
        print('jsonData: $jsonData');

        // Periksa struktur JSON dan sesuaikan kode parsing
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('results')) {
          var results = jsonData['results'];
          if (results is List) {
            List<NowPlayModel> movies = results.map((data) => NowPlayModel.fromJson(data)).toList();
            return movies;
          } else {
            print("Data 'results' bukan List.");
            return null;
          }
        } else {
          print("Format data tidak sesuai. Harapkan Map dengan kunci 'results'.");
          return null;
        }
      } else {
        print("ERROR saat mengambil data: Status Code ${response.statusCode}");
        return null;
      }
    } catch (error) {
      if (error is SocketException) {
        DMethod.printTitle("ERRROR", error.toString());
      }
      print('Error Data: $error');
      return null;
    }
  }

  static Future<List<PopularMovieModel>?> fetchPopularMovie() async {
    final String url = "https://api.themoviedb.org/3/movie/popular";
    

    try {
      var response = await http.get(Uri.parse(url), headers: headersReq);
      if (response.statusCode == 200) {
        DMethod.printTitle("Sukses Mendapat Data Popular Movie - ", response.body.toString());
        var jsonData = jsonDecode(response.body);
        
        // Cetak jsonData untuk memeriksa strukturnya
        print('jsonData: $jsonData');

        // Periksa struktur JSON dan sesuaikan kode parsing
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('results')) {
          var results = jsonData['results'];
          if (results is List) {
            List<PopularMovieModel> movies = results.map((data) => PopularMovieModel.fromJson(data)).toList();
            return movies;
          } else {
            print("Data 'results' bukan List.");
            return null;
          }
        } else {
          print("Format data tidak sesuai.");
          return null;
        }
      } else {
        print("ERROR saat mengambil data: Status Code ${response.statusCode}");
        return null;
      }
    } catch (error) {
      if (error is SocketException) {
        DMethod.printTitle("ERRROR", error.toString());
      }
      print('Error Data: $error');
      return null;
    }
  }


static Future<DetailMovieModel?> fetchDetailMovie(String idMovie) async {
  final String url = "https://api.themoviedb.org/3/movie/${idMovie}";
 

  try {
    var response = await http.get(Uri.parse(url), headers: headersReq);
    if (response.statusCode == 200) {
      DMethod.printTitle('Sukses Mendapat Data Detail - ', response.body.toString());
      var jsonData = jsonDecode(response.body);
      DetailMovieModel movie = DetailMovieModel.fromJson(jsonData);
      return movie;
    } else {
      DMethod.printTitle('Gagal Mendapat Data Detail - ', response.statusCode.toString());
    }
  } catch (e) {
    DMethod.printTitle('Error - ', e.toString());
  }
  return null;
  }


 static Future<List<SimilarMovieModel>?> fetchSimilar(String idMovie) async {
  final String url = "https://api.themoviedb.org/3/movie/${idMovie}/similar";
  try {
    var response = await http.get(Uri.parse(url), headers: headersReq);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      DMethod.printTitle('Sukses Mendapat Data Similar -', jsonEncode(jsonData));
      if (jsonData is Map<String, dynamic> && jsonData.containsKey('results')) {
        var result = jsonData['results'];
        if (result is List) {
          List<SimilarMovieModel> similar = result.map((data) => SimilarMovieModel.fromJson(data)).toList();
          return similar;
        } else {
          print("Data 'results' bukan List.");
          return null;
        }
      } else {
        print("Format data tidak sesuai.");
        return null;
      }
    } else {
      print("Error Saat Mengambil Data: ${response.statusCode}");
      return null;
    }
  } catch (error) {
    if (error is SocketException) {
      DMethod.printTitle("ERRROR- ", error.toString());
    } else {
      print("ERROR: $error");
    }
    return null;
  }
}


}
