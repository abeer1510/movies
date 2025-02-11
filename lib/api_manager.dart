import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/model/sources_response.dart';

class ApiManager{

  static Future<SourcesResponse> getPopular()async{
    Uri url=Uri.parse("https://api.themoviedb.org/3/movie/popular?api_key=2b0d978a962d720636b46566d80b8e37");

    http.Response response = await http.get(url);
    var json =jsonDecode(response.body);
    SourcesResponse sourcesResponse=SourcesResponse.fromJson(json);
    return sourcesResponse;
  }
}