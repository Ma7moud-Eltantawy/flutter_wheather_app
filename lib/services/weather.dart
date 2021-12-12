import 'package:flutter_wheather_app/services/location.dart';
import 'package:flutter_wheather_app/services/networking.dart';

class WeatherReport {
  final String city;
  final double temperature;
  final int condition;
  final double? Lang;
  final double?lat;

  WeatherReport({
    required this.city,
    required this.condition,
    required this.temperature,
    this.Lang,
    this.lat,
  });
}
class wheatherDtails {
  final String city;
  final int clouds;
  final int pressure;
  final double wind_speed;
  final int humidity;
  final String Description;



  wheatherDtails({
    required this.clouds,
    required this.pressure,
    required this.wind_speed,
    required this.humidity,
    required this.Description,
    required this.city,


  });
}

class WeatherModel {
  static Future<WeatherReport> getWeatherData() async {
    try {
      var location = Location();
      await location.getCurrentLocation();
      return await loadWeatherFromOpenApi(location: location);
    } catch (e) {
      return Future.error(e.toString());
    }
  }



  static Future<WeatherReport> getCityWeather(String cityName) async {
    try {
      return await loadCityWeatherFromOpenApi(cityName: cityName);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  static String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}

