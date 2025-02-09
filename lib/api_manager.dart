import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/model/sources_response.dart';

class ApiManager{

  static Future<SourcesResponse> getPopular()async{
    Uri url=Uri.https("api.themoviedb.org/","/3/tv/popular",{
      "apiKey":"1af5751239f6c52b196a77e23dcf8416"}
    );

    http.Response response = await http.get(url);
    var json =jsonDecode(response.body);
    SourcesResponse sourcesResponse=SourcesResponse.fromJson(json);
    return sourcesResponse;
  }
}