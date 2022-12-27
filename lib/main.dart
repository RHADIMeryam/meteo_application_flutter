import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'model/WeatherModel.dart';
import 'logic/network.dart';
import 'cubit/WeatherCubit.dart';
import 'model/WeatherModelCoord.dart';
import 'structure/listeWeather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meteo',
      home: BlocProvider(
        create: (_) => WeatherCubit(),
        child: _MyHomePageState(),
      ),
    );
  }
}

class _MyHomePageState extends StatelessWidget {
  final now = new DateTime.now();
  late String date;
  String cityName = "Montpellier";
  late List<String> fourNextDay = ["", "", "", ""];
  WeatherForecastModel test = WeatherForecastModel(
      Coord(0.0, 0.0),
      [],
      "",
      Main(0.0, 0.0, 0.0, 0.0, 0, 0),
      0,
      Wind(0.0, 0),
      Clouds(0),
      0,
      Sys(0, 0, 0.0, "", 0, 0),
      0,
      0,
      "",
      0);

  void init() {
    var tomorrow = new DateTime(now.year, now.month, now.day + 1);
    var date2 = new DateTime(now.year, now.month, now.day + 2);
    var date3 = new DateTime(now.year, now.month, now.day + 3);
    var date4 = new DateTime(now.year, now.month, now.day + 4);
    date = DateFormat('EEEE, d MMM, yyyy').format(now);
    fourNextDay[0] = DateFormat('EEEE').format(tomorrow);
    fourNextDay[1] = DateFormat('EEEE').format(date2);
    fourNextDay[2] = DateFormat('EEEE').format(date3);
    fourNextDay[3] = DateFormat('EEEE').format(date4);
  }

  Future<WeatherModelCoord> initC(String city) async {
    test = await Network().getCurrentWeather(cityName: city);
    WeatherModelCoord test2 = await Network()
        .getWeatherCord(lon: test.cordonnee.lon, lat: test.cordonnee.lon);
    return test2;
  }

  void update(String city, BuildContext context) async {
    WeatherForecastModel wf = await Network().getCurrentWeather(cityName: city);
    WeatherModelCoord wm = await Network()
        .getWeatherCord(lon: wf.cordonnee.lon, lat: wf.cordonnee.lon);
    context.read<WeatherCubit>().update(wf, wm);
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: initC(cityName),
            builder: (BuildContext context,
                AsyncSnapshot<WeatherModelCoord> snapshot) {
              List<Widget> children = [];
              if (snapshot.hasData) {
                context.read<WeatherCubit>().update(test, snapshot.requireData);
                children = <Widget>[
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Expanded(
                        flex: 9,
                        child: TextField(
                          onSubmitted: (String value) {
                            this.cityName = value.toLowerCase();
                            update(cityName, context);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            hintText: 'entrez nom de la ville',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  BlocBuilder<WeatherCubit, weather_model>(
                      builder: (context, model) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${model.listeWeather[0].cityName}',
                          overflow: TextOverflow.ellipsis,
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(fontSizeFactor: 2.5, color: Colors.black),
                        ),
                      ],
                    );
                  }),
                  Text(
                    '$date',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  BlocBuilder<WeatherCubit, weather_model>(
                      builder: (context, model) {
                    return context.read<WeatherCubit>().updateSky(
                        model.listeWeather[0].sky,
                        MediaQuery.of(context).size.width / 2.5);
                  }),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      BlocBuilder<WeatherCubit, weather_model>(
                          builder: (context, model) {
                        return Text(
                          '${model.listeWeather[0].temperature} °K',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: DefaultTextStyle.of(context).style.apply(
                              fontSizeFactor: 2.0,
                              fontWeightDelta: 2,
                              color: Colors.black),
                        );
                      }),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      BlocBuilder<WeatherCubit, weather_model>(
                          builder: (context, model) {
                        return Text(
                          '${model.listeWeather[0].detailSky}',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(fontWeightDelta: 2, color: Colors.black),
                        );
                      }),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          BlocBuilder<WeatherCubit, weather_model>(
                              builder: (context, model) {
                            return Text(
                              '${model.listeWeather[0].pressure} ips ',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            );
                          }),
                          Icon(
                            FontAwesomeIcons.bars,
                            color: Colors.orange,
                            size: MediaQuery.of(context).size.width / 25,
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Column(
                        children: [
                          BlocBuilder<WeatherCubit, weather_model>(
                              builder: (context, model) {
                            return Text(
                              '${model.listeWeather[0].humidity}% ',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            );
                          }),
                          Icon(
                            FontAwesomeIcons.tint,
                            color: Colors.blue,
                            size: MediaQuery.of(context).size.width / 25,
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Column(
                        children: [
                          BlocBuilder<WeatherCubit, weather_model>(
                              builder: (context, model) {
                            return Text(
                              ' ${model.listeWeather[0].precipitation}mm',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            );
                          }),
                          Icon(
                            FontAwesomeIcons.cloudRain,
                            color: Colors.pink,
                            size: MediaQuery.of(context).size.width / 25,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    'Next days',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: DefaultTextStyle.of(context).style.apply(
                        fontWeightDelta: 2,
                        fontSizeFactor: 2.0,
                        color: Colors.black),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              height: MediaQuery.of(context).size.height / 5,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(
                                    fourNextDay[0],
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        5 *
                                        0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BlocBuilder<WeatherCubit, weather_model>(
                                          builder: (context, model) {
                                        return Text(
                                          '${model.listeWeather[1].temperature} °K',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .apply(
                                                  fontSizeFactor: 1.3,
                                                  fontWeightDelta: 2,
                                                  color: Colors.white),
                                        );
                                      }),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        5 *
                                        0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BlocBuilder<WeatherCubit, weather_model>(
                                          builder: (context, model) {
                                        return context
                                            .read<WeatherCubit>()
                                            .updateSky(
                                                model.listeWeather[1].sky,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    10);
                                      }),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      BlocBuilder<WeatherCubit, weather_model>(
                                          builder: (context, model) {
                                        return Text(
                                          '${model.listeWeather[1].detailSky}',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        );
                                      }),
                                    ],
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        5 *
                                        0.08,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          BlocBuilder<WeatherCubit,
                                                  weather_model>(
                                              builder: (context, model) {
                                            return Text(
                                              '${model.listeWeather[1].pressure} ips ',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          }),
                                          Icon(
                                            FontAwesomeIcons.bars,
                                            color: Colors.orange,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Column(
                                        children: [
                                          BlocBuilder<WeatherCubit,
                                                  weather_model>(
                                              builder: (context, model) {
                                            return Text(
                                              '${model.listeWeather[1].humidity}% ',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          }),
                                          Icon(
                                            FontAwesomeIcons.tint,
                                            color: Colors.blue,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Column(
                                        children: [
                                          BlocBuilder<WeatherCubit,
                                                  weather_model>(
                                              builder: (context, model) {
                                            return Text(
                                              ' ${model.listeWeather[1].precipitation}mm',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          }),
                                          Icon(
                                            FontAwesomeIcons.cloudRain,
                                            color: Colors.white,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              height: MediaQuery.of(context).size.height / 5,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(
                                    fourNextDay[1],
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        5 *
                                        0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BlocBuilder<WeatherCubit, weather_model>(
                                          builder: (context, model) {
                                        return Text(
                                          '${model.listeWeather[2].temperature} °K',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .apply(
                                                  fontSizeFactor: 1.3,
                                                  fontWeightDelta: 2,
                                                  color: Colors.white),
                                        );
                                      }),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        5 *
                                        0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BlocBuilder<WeatherCubit, weather_model>(
                                          builder: (context, model) {
                                        return context
                                            .read<WeatherCubit>()
                                            .updateSky(
                                                model.listeWeather[2].sky,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    10);
                                      }),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      BlocBuilder<WeatherCubit, weather_model>(
                                          builder: (context, model) {
                                        return Text(
                                          '${model.listeWeather[2].detailSky}',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        );
                                      }),
                                    ],
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        5 *
                                        0.08,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          BlocBuilder<WeatherCubit,
                                                  weather_model>(
                                              builder: (context, model) {
                                            return Text(
                                              '${model.listeWeather[2].pressure} ips ',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          }),
                                          Icon(
                                            FontAwesomeIcons.bars,
                                            color: Colors.orange,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Column(
                                        children: [
                                          BlocBuilder<WeatherCubit,
                                                  weather_model>(
                                              builder: (context, model) {
                                            return Text(
                                              '${model.listeWeather[2].humidity}% ',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          }),
                                          Icon(
                                            FontAwesomeIcons.tint,
                                            color: Colors.blue,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Column(
                                        children: [
                                          BlocBuilder<WeatherCubit,
                                                  weather_model>(
                                              builder: (context, model) {
                                            return Text(
                                              ' ${model.listeWeather[2].precipitation}mm',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          }),
                                          Icon(
                                            FontAwesomeIcons.cloudRain,
                                            color: Colors.white,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              height: MediaQuery.of(context).size.height / 5,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(
                                    fourNextDay[2],
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        5 *
                                        0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BlocBuilder<WeatherCubit, weather_model>(
                                          builder: (context, model) {
                                        return Text(
                                          '${model.listeWeather[3].temperature} °K',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .apply(
                                                  fontSizeFactor: 1.3,
                                                  fontWeightDelta: 2,
                                                  color: Colors.white),
                                        );
                                      }),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        5 *
                                        0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BlocBuilder<WeatherCubit, weather_model>(
                                          builder: (context, model) {
                                        return context
                                            .read<WeatherCubit>()
                                            .updateSky(
                                                model.listeWeather[3].sky,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    10);
                                      }),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      BlocBuilder<WeatherCubit, weather_model>(
                                          builder: (context, model) {
                                        return Text(
                                          '${model.listeWeather[3].detailSky}',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        );
                                      }),
                                    ],
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        5 *
                                        0.08,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          BlocBuilder<WeatherCubit,
                                                  weather_model>(
                                              builder: (context, model) {
                                            return Text(
                                              '${model.listeWeather[3].pressure} ips ',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          }),
                                          Icon(
                                            FontAwesomeIcons.bars,
                                            color: Colors.orange,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Column(
                                        children: [
                                          BlocBuilder<WeatherCubit,
                                                  weather_model>(
                                              builder: (context, model) {
                                            return Text(
                                              '${model.listeWeather[3].humidity}% ',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          }),
                                          Icon(
                                            FontAwesomeIcons.tint,
                                            color: Colors.blue,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Column(
                                        children: [
                                          BlocBuilder<WeatherCubit,
                                                  weather_model>(
                                              builder: (context, model) {
                                            return Text(
                                              ' ${model.listeWeather[3].precipitation}mm',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          }),
                                          Icon(
                                            FontAwesomeIcons.cloudRain,
                                            color: Colors.white,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              height: MediaQuery.of(context).size.height / 5,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(
                                    fourNextDay[3],
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        5 *
                                        0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BlocBuilder<WeatherCubit, weather_model>(
                                          builder: (context, model) {
                                        return Text(
                                          '${model.listeWeather[4].temperature} °K',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .apply(
                                                  fontSizeFactor: 1.3,
                                                  fontWeightDelta: 2,
                                                  color: Colors.white),
                                        );
                                      }),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        5 *
                                        0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BlocBuilder<WeatherCubit, weather_model>(
                                          builder: (context, model) {
                                        return context
                                            .read<WeatherCubit>()
                                            .updateSky(
                                                model.listeWeather[4].sky,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    10);
                                      }),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      BlocBuilder<WeatherCubit, weather_model>(
                                          builder: (context, model) {
                                        return Text(
                                          '${model.listeWeather[4].detailSky}',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        );
                                      }),
                                    ],
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        5 *
                                        0.08,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          BlocBuilder<WeatherCubit,
                                                  weather_model>(
                                              builder: (context, model) {
                                            return Text(
                                              '${model.listeWeather[4].pressure} ips ',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          }),
                                          Icon(
                                            FontAwesomeIcons.bars,
                                            color: Colors.orange,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Column(
                                        children: [
                                          BlocBuilder<WeatherCubit,
                                                  weather_model>(
                                              builder: (context, model) {
                                            return Text(
                                              '${model.listeWeather[4].humidity}% ',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          }),
                                          Icon(
                                            FontAwesomeIcons.tint,
                                            color: Colors.blue,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      Column(
                                        children: [
                                          BlocBuilder<WeatherCubit,
                                                  weather_model>(
                                              builder: (context, model) {
                                            return Text(
                                              ' ${model.listeWeather[4].precipitation}mm',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          }),
                                          Icon(
                                            FontAwesomeIcons.cloudRain,
                                            color: Colors.white,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ];
              }
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: children,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
