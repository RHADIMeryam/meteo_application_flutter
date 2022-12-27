class WeatherStructure {
  String cityName;
  int humidity;
  double temperature;
  String sky;
  int pressure;
  double precipitation;
  String detailSky;

  WeatherStructure(this.cityName, this.humidity, this.temperature, this.sky,
      this.pressure, this.detailSky, this.precipitation);

  String getCityName() {
    return cityName;
  }

  void setCityName(String cn) {
    cityName = cn;
  }

  int getHumidity() {
    return humidity;
  }

  void setHumidity(int h) {
    humidity = h;
  }

  double getTemperature() {
    return temperature;
  }

  void setTemperature(double t) {
    temperature = t;
  }

  String getSky() {
    return sky;
  }

  void setSky(String s) {
    sky = s;
  }

  double getPrecipitation() {
    return precipitation;
  }

  void setPrecipitation(double p) {
    precipitation = p;
  }

  String getDetailSky() {
    return detailSky;
  }

  void setDetailSky(String d) {
    detailSky = d;
  }

  int getPressure() {
    return pressure;
  }

  void setPressure(int p) {
    pressure = p;
  }
}
