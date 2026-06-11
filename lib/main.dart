import 'package:flutter/material.dart';
import 'package:weather_app/weather_services.dart';
import 'Widgets/footer_title.dart';
import 'weather_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ১. থিম মুড সংরক্ষণের জন্য ভেরিয়েবল
  ThemeMode _themeMode = ThemeMode.light;

  // থিম পরিবর্তন করার ফাংশন
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      // ২. থিম ডাটা কনফিগারেশন
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: _themeMode, // বর্তমান থিম মুড
      home: WeatherScreen(onThemeToggle: _toggleTheme), // ফাংশনটি স্ক্রিনে পাস করা হচ্ছে
    );
  }
}

class WeatherScreen extends StatefulWidget {
  final VoidCallback onThemeToggle; // থিম টগল করার কলব্যাক
  const WeatherScreen({super.key, required this.onThemeToggle});

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
    if (latController.text.isEmpty || lonController.text.isEmpty) return;

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
        error = "Error fetching weather data";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // বর্তমান থিম ডার্ক কিনা তা চেক করা (আইকন পরিবর্তনের জন্য)
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
        actions: [
          // ৩. থিম টগল বাটন
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: latController,
              decoration: const InputDecoration(
                labelText: 'Latitude',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: lonController,
              decoration: const InputDecoration(
                labelText: 'Longitude',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: getWeather,
              icon: const Icon(Icons.search),
              label: const Text('Get Weather'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Builder(
                builder: (_) {
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (error != null) {
                    return Center(child: Text(error!, style: const TextStyle(color: Colors.red)));
                  }
                  if (weatherData == null) {
                    return const Center(child: Text('Enter coordinates to see weather'));
                  }

                  return ListView(
                    children: [
                      const Text(
                        'Current Weather',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.thermostat),
                          title: Text('Temperature: ${weatherData!.current.temperature} °C'),
                          subtitle: Text('Wind Speed: ${weatherData!.current.windSpeed} km/h'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Hourly Forecast',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: weatherData!.hourly.length.clamp(0, 24),
                          itemBuilder: (context, index) {
                            final item = weatherData!.hourly[index];
                            return Card(
                              child: Container(
                                width: 120,
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(item.time.split('T').last,
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const Icon(Icons.cloud, size: 30),
                                    Text('${item.temperature} °C'),
                                    Text('${item.windSpeed} km/h',
                                        style: const TextStyle(fontSize: 10)),
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
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      ...weatherData!.daily.map(
                            (day) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: Text(day.date),
                            subtitle: Text('Low: ${day.minTemp}°C | High: ${day.maxTemp}°C'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('☀️ ${day.sunrise.substring(11)}'),
                                Text('🌙 ${day.sunset.substring(11)}'),
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
            footertitle(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
