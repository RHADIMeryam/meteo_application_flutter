import 'dart:convert';
import 'package:http/http.dart';

import '../model/WeatherModel.dart';
import '../model/WeatherModelCoord.dart';

class Network {
  var appid = "26a3ecf24d4dd6f0544e6d7b798f78a1";

  Future<WeatherForecastModel> getCurrentWeather(
      {required String cityName}) async {
    var finalUrl = "https://api.openweathermap.org/data/2.5/weather?q=" +
        cityName +
        "&appid=" +
        appid;
    final response = await get(Uri.parse(finalUrl));

    if (response.statusCode == 200) {
      return WeatherForecastModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error getting weather forecast");
    }
  }

  Future<WeatherModelCoord> getWeatherCord(
      {required double lon, required double lat}) async {
    var finalUrl = "https://api.openweathermap.org/data/2.5/onecall?lat=" +
        lat.toString() +
        "&lon=" +
        lon.toString() +
        "&appid=" +
        appid;
    final response = await get(Uri.parse(finalUrl));

    if (response.statusCode == 200) {
      return WeatherModelCoord.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error getting weather forecast");
    }
  }
}
