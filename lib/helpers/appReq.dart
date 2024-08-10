import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:http/http.dart' as http;
class AppReq{

  //GET DATA
  static Future<dynamic> gets(String url, {Map<String, String>? headers}) async {
  try {
    http.Response response = await http.get(Uri.parse(url), headers: headers);

    // CEK VALIDASI
    DMethod.printTitle('TRY - $url', response.body);

    // PARSING KE BENTUK MAP 
    dynamic responseBody = jsonDecode(response.body);

    return responseBody;
  } catch (e) {
    DMethod.printTitle('Catch Error - ', e.toString());
    return null;
  }
}


  //POST DATA
 static Future<dynamic> post(String url, Object? body, {Map<String, String>? headers}) async {
  try {
    var response = await http.post(Uri.parse(url), headers: headers, body: body);
    //CEK VALIDASI
    DMethod.printTitle('TRY - $url', response.body);

    //PARSING KE DYNAMIC (MAP ATAU LIST)
    return jsonDecode(response.body);
  } catch (e) {
    DMethod.printTitle("Catch Error", e.toString());
    return null;
  }
}



  static Future<dynamic> delete(String url, Object? body,{Map<String,String>? headers}) async{
    try {
      var response = await http.delete(Uri.parse(url),body: body,headers: headers);
      var json = jsonDecode(response.body);
      //CEK VALIDASI
      DMethod.printTitle("TRY - $url", response.body);
      //PARSING KE MAP
      Map responseBody = jsonDecode(response.body);
      return responseBody;
    } catch (e) {
      DMethod.printTitle("Catch Error", e.toString());
      return null;
    }
  }
}