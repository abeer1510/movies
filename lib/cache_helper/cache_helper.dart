import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{

  static late final SharedPreferences prefs;

 static init()async{
   prefs = await SharedPreferences.getInstance();
 }

 static Future<void> saveEligibility()async{
    await prefs.setBool("onBoarding", true);

 }

 static bool? getEligibility(){
   return prefs.getBool("onBoarding");

 }

}