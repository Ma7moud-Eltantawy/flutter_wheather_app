import 'dart:convert';
import 'dart:io';

import 'package:flutter_wheather_app/services/location.dart';
import 'package:flutter_wheather_app/services/weather.dart';
import 'package:http/http.dart' as http;

const apiKey = "93fe339d8036fba905bf4d94f8dd7441";
const apiDomain = "api.openweathermap.org";
const baseUrl = "https://" + apiDomain + "/data/2.5/weather";

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup(apiDomain);
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

Future<WeatherReport> loadWeatherFromOpenApi({
  required Location location,
}) async {
  if (!await hasNetwork()) {
    return Future.error(
        "Internet not available. Please reconnect and try again.");
  }

  var uri = Uri.parse(
    baseUrl +
        "?lat=${location.latitude}&lon=${location.longitude}&units=metric&appid=$apiKey",
  );

  http.Response response = await http.get(uri);
  if (response.statusCode != 200) {
    return Future.error(response.reasonPhrase ?? "Unknown Error");
  }

  final decodedData = jsonDecode(response.body);
  print(decodedData);
  return WeatherReport(

    city: decodedData['name'],
    condition: decodedData["weather"][0]["id"],
    temperature: decodedData["main"]["temp"],
  );
}

Future<WeatherReport> loadCityWeatherFromOpenApi({required String cityName,}) async {
  if (!await hasNetwork()) {
    return Future.error(
        "Internet not available. Please reconnect and try again.");
  }

  var uri = Uri.parse(
    baseUrl + "?q=$cityName&units=metric&appid=$apiKey",
  );

  http.Response response = await http.get(uri);
  if (response.statusCode != 200) {
    return Future.error(response.reasonPhrase ?? "Unknown Error");
  }

  final decodedData = jsonDecode(response.body);
  return WeatherReport(
    city: decodedData['name'],
    condition: decodedData["weather"][0]["id"],
    temperature: decodedData["main"]["temp"],
    lat: decodedData['coord']["lat"],
    Lang:decodedData['coord']["lon"],

  );
}
Future<wheatherDtails> loadWheatherdetails({ required Location location,}) async {
  if (!await hasNetwork()) {
    return Future.error(
        "Internet not available. Please reconnect and try again.");
  }

  var uri = Uri.parse(
   "https://api.openweathermap.org/data/2.5/onecall?lat=${location.latitude}&lon=${location.longitude}&exclude=hourly,daily&appid=$apiKey"
  );

  http.Response response = await http.get(uri);
  if (response.statusCode != 200) {
    return Future.error(response.reasonPhrase ?? "Unknown Error");
  }

  final decodedData = jsonDecode(response.body);
  return wheatherDtails(
    clouds:decodedData['current']['clouds'],
    pressure:decodedData['current']['pressure'],
    wind_speed:decodedData['current']['wind_speed'],
    humidity:decodedData['current']['humidity'],
    Description: decodedData['current']['weather'][0]['description'],
    city: decodedData['timezone'],

  );
}
