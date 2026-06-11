import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class WeatherService {
  Future<WeatherData> fetchWeather(
      double latitude, double longitude) async {
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
          '?latitude=$latitude'
          '&longitude=$longitude'
          '&current=temperature_2m,weather_code,wind_speed_10m'
          '&hourly=temperature_2m,weather_code,wind_speed_10m'
          '&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset'
          '&forecast_days=10'
          '&timezone=Asia%2FDhaka',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return WeatherData.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}