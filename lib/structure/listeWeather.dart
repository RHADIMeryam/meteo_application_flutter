import 'WeatherStructure.dart';

class weather_model {
  List<WeatherStructure> listeWeather;

  weather_model(this.listeWeather);

  List<WeatherStructure> getLListeWeather() {
    return listeWeather;
  }

  void setListeWeather(List<WeatherStructure> liste) {
    listeWeather = liste;
  }
}
