import 'dart:ui';

import 'package:flutter_wheather_app/screens/city_screen.dart';
import 'package:flutter_wheather_app/services/weather.dart';
import 'package:flutter_wheather_app/utilities/constants.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({
    Key? key,
    required this.weather
  }) : super(key: key);

  final WeatherReport weather;


  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double temperature = 0;
  String message = "Weather Not Loaded";
  String wIcon = WeatherModel.getWeatherIcon(-1);

  @override
  void initState() {
    super.initState();
    updateWeather(widget.weather);
  }

  updateWeather(WeatherReport weatherData) {
    // log("City: ${weatherData.city} | Temp: ${weatherData.temperature} | Cond: ${weatherData.condition}");
    setState(() {

      temperature = weatherData.temperature;
      message = WeatherModel.getMessage(temperature.toInt()) +
          " in ${weatherData.city} !";
      wIcon = WeatherModel.getWeatherIcon(weatherData.condition);

    });
  }

  void _updateWeatherForNewCity(String cityName) async {
    try {
      var weatherData = await WeatherModel.getCityWeather(cityName);
      updateWeather(weatherData);
    } catch (e) {
      var reason = e.toString();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "Whoops !",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
              ),
            ),
          ),
          content: Text(
            reason == "Not Found"
                ? "Couldn't find the city you searched for"
                : reason,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize:20,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        actions: [
          FlatButton(
            onPressed: () async {
              var cityName = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CityScreen(),
                ),
              );
              if (cityName == null) return;
              _updateWeatherForNewCity(cityName);


            },
            child: const Icon(
              Icons.location_city,
              size: 30.0,
              color: Colors.white,
            ),
          ),
        ],
        leading: FlatButton(
          onPressed: () async {
            var weatherData = await WeatherModel.getWeatherData();
            updateWeather(weatherData);
          },
          child: const Icon(
            Icons.near_me,
            size: 30.0,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.7), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      Text(
                        temperature.toStringAsFixed(1) + '°',
                        style: kTempTextStyle,
                      ),
                      Text(
                        wIcon,
                        style: kConditionTextStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Text(
                    message,
                    textAlign: TextAlign.right,
                    style: kMessageTextStyle,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
