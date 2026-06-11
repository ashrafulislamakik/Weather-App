class WeatherData {
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  WeatherData({
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      current: CurrentWeather.fromJson(json['current']),
      hourly: HourlyWeather.listFromJson(json['hourly']),
      daily: DailyWeather.listFromJson(json['daily']),
    );
  }
}

class CurrentWeather {
  final double temperature;
  final int weatherCode;
  final double windSpeed;

  CurrentWeather({
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: json['temperature_2m'].toDouble(),
      weatherCode: json['weather_code'],
      windSpeed: json['wind_speed_10m'].toDouble(),
    );
  }
}

class HourlyWeather {
  final String time;
  final double temperature;
  final int weatherCode;
  final double windSpeed;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
  });

  static List<HourlyWeather> listFromJson(Map<String, dynamic> json) {
    List<HourlyWeather> list = [];

    for (int i = 0; i < json['time'].length; i++) {
      list.add(
        HourlyWeather(
          time: json['time'][i],
          temperature: json['temperature_2m'][i].toDouble(),
          weatherCode: json['weather_code'][i],
          windSpeed: json['wind_speed_10m'][i].toDouble(),
        ),
      );
    }

    return list;
  }
}

class DailyWeather {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String sunrise;
  final String sunset;

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.sunrise,
    required this.sunset,
  });

  static List<DailyWeather> listFromJson(Map<String, dynamic> json) {
    List<DailyWeather> list = [];

    for (int i = 0; i < json['time'].length; i++) {
      list.add(
        DailyWeather(
          date: json['time'][i],
          maxTemp: json['temperature_2m_max'][i].toDouble(),
          minTemp: json['temperature_2m_min'][i].toDouble(),
          sunrise: json['sunrise'][i],
          sunset: json['sunset'][i],
        ),
      );
    }

    return list;
  }
}