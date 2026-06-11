import 'package:flutter/material.dart';
import 'package:weather_app/weather_services.dart';
import 'weather_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final latController = TextEditingController();
  final lonController = TextEditingController();

  final service = WeatherService();

  WeatherData? weatherData;
  bool isLoading = false;
  String? error;

  Future<void> getWeather() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await service.fetchWeather(
        double.parse(latController.text),
        double.parse(lonController.text),
      );

      setState(() {
        weatherData = data;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: latController,
              decoration: const InputDecoration(
                labelText: 'Latitude',
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 10),

            TextField(
              controller: lonController,
              decoration: const InputDecoration(
                labelText: 'Longitude',
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: getWeather,
              child: const Text('Get Weather'),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Builder(
                builder: (_) {
                  if (isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (error != null) {
                    return Center(
                      child: Text(error!),
                    );
                  }

                  if (weatherData == null) {
                    return const Center(
                      child: Text('Enter coordinates'),
                    );
                  }

                  return ListView(
                    children: [
                      const Text(
                        'Current Weather',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        'Temperature: ${weatherData!.current.temperature} °C',
                      ),

                      Text(
                        'Wind Speed: ${weatherData!.current.windSpeed} km/h',
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Hourly Forecast',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: weatherData!.hourly.length.clamp(0, 24),
                          itemBuilder: (context, index) {
                            final item =
                            weatherData!.hourly[index];

                            return Card(
                              child: Container(
                                width: 120,
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(item.time),
                                    Text(
                                      '${item.temperature} °C',
                                    ),
                                    Text(
                                      '${item.windSpeed} km/h',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        '10-Day Forecast',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      ...weatherData!.daily.map(
                            (day) => Card(
                          child: ListTile(
                            title: Text(day.date),
                            subtitle: Text(
                              'Low: ${day.minTemp}°C  |  High: ${day.maxTemp}°C',
                            ),
                            trailing: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  '↑ ${day.sunrise.substring(11)}',
                                ),
                                Text(
                                  '↓ ${day.sunset.substring(11)}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}