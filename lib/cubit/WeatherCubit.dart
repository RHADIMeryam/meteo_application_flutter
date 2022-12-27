import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../structure/WeatherStructure.dart';
import '../model/WeatherModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/WeatherModelCoord.dart';
import '../structure/listeWeather.dart';

class WeatherCubit extends Cubit<weather_model> {
  List<WeatherStructure> liste = [
    WeatherStructure("Montpellier", 0, 0.0, "Clear", 0, "Clear ", 0),
    WeatherStructure("Montpellier", 0, 0.0, "Clear", 0, "Clear ", 0),
    WeatherStructure("Montpellier", 0, 0.0, "Clear", 0, "Clear ", 0),
    WeatherStructure("Montpellier", 0, 0.0, "Clear", 0, "Clear ", 0),
    WeatherStructure("Montpellier", 0, 0.0, "Clear", 0, "Clear ", 0)
  ];

  WeatherCubit() : super(weather_model([]));

  void update(WeatherForecastModel json1, WeatherModelCoord json2) {
    liste[0] = WeatherStructure(
        json1.name,
        json2.current.humidity,
        json2.current.temp,
        json2.current.weather[0].main,
        json2.current.pressure,
        json2.current.weather[0].description,
        json2.current.rain.d1h);
    liste[1] = WeatherStructure(
        json1.name,
        json2.daily[0].humidity,
        json2.daily[0].temp.day,
        json2.daily[0].weather[0].main,
        json2.daily[0].pressure,
        json2.daily[0].weather[0].description,
        json2.daily[0].rain);
    liste[2] = WeatherStructure(
        json1.name,
        json2.daily[1].humidity,
        json2.daily[1].temp.day,
        json2.daily[1].weather[0].main,
        json2.daily[1].pressure,
        json2.daily[1].weather[0].description,
        json2.daily[1].rain);
    liste[3] = WeatherStructure(
        json1.name,
        json2.daily[2].humidity,
        json2.daily[2].temp.day,
        json2.daily[2].weather[0].main,
        json2.daily[2].pressure,
        json2.daily[2].weather[0].description,
        json2.daily[2].rain);
    liste[4] = WeatherStructure(
        json1.name,
        json2.daily[3].humidity,
        json2.daily[3].temp.day,
        json2.daily[3].weather[0].main,
        json2.daily[3].pressure,
        json2.daily[3].weather[0].description,
        json2.daily[3].rain);
    emit(weather_model(liste));
  }

  Widget updateSky(String responseSky, double size) {
    switch (responseSky) {
      case "Clouds":
        return Icon(
          FontAwesomeIcons.cloud,
          color: Colors.pinkAccent,
          size: size,
        );
        break;
      case "Clear":
        return Icon(
          FontAwesomeIcons.sun,
          color: Colors.yellow,
          size: size,
        );
        break;
      case "Rain":
        return Icon(
          FontAwesomeIcons.cloudRain,
          color: Colors.white,
          size: size,
        );
        break;
      case "Snow":
        return Icon(
          FontAwesomeIcons.snowman,
          color: Colors.white,
          size: size,
        );
        break;
      default:
        return Icon(
          FontAwesomeIcons.sun,
          color: Colors.yellow,
          size: size,
        );
        break;
    }
  }
}
