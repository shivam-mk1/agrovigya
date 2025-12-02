import 'dart:convert';
import 'package:agro/providers/language_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String weatherApiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic>? weatherData;
  String location = 'Loading...';

  final String apiKey = weatherApiKey;

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocation = prefs.getString('weather_location');

      if (savedLocation != null && savedLocation.isNotEmpty) {
        fetchWeatherByCity(savedLocation);
      } else {
        _getCurrentLocation();
      }
    } catch (e) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          errorMessage = 'Location services are disabled';
          isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            errorMessage = 'Location permission denied';
            isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          errorMessage = 'Location permissions are permanently denied';
          isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      fetchWeatherByCoordinates(position.latitude, position.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String cityName = place.locality ?? '';
        if (cityName.isNotEmpty) {
          setState(() {
            location = cityName;
          });

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('weather_location', cityName);
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error getting location: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          weatherData = jsonDecode(response.body);
          location = weatherData?['name'] ?? city;
          isLoading = false;
          _saveLocation(city);
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load weather data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          weatherData = jsonDecode(response.body);
          location = weatherData?['name'] ?? 'Unknown';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load weather data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _saveLocation(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weather_location', city);
  }

  IconData _getWeatherIcon(String? iconCode) {
    if (iconCode == null) return Icons.cloud;
    switch (iconCode.substring(0, 2)) {
      case '01':
        return Icons.wb_sunny;
      case '02':
        return Icons.cloud;
      case '03':
        return Icons.cloud;
      case '04':
        return Icons.cloud_queue;
      case '09':
        return Icons.grain;
      case '10':
        return Icons.beach_access;
      case '11':
        return Icons.flash_on;
      case '13':
        return Icons.ac_unit;
      case '50':
        return Icons.blur_on;
      default:
        return Icons.cloud;
    }
  }

  Color _getWeatherIconColor(String? iconCode) {
    if (iconCode == null) return Colors.blueGrey;
    switch (iconCode.substring(0, 2)) {
      case '01':
        return Colors.yellow[700]!;
      case '02':
      case '03':
      case '04':
        return Colors.blue[300]!;
      case '09':
      case '10':
        return Colors.blue[600]!;
      case '11':
        return Colors.purple[400]!;
      case '13':
        return Colors.white;
      case '50':
        return Colors.grey[400]!;
      default:
        return Colors.blueGrey;
    }
  }

  Color _getTemperatureColor(double? temp) {
    if (temp == null) return Colors.white;
    if (temp < 0) return Colors.blue[300]!;
    if (temp < 15) return Colors.cyan[300]!;
    if (temp < 25) return Colors.green[300]!;
    if (temp < 30) return Colors.yellow[700]!;
    return Colors.red[400]!;
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : errorMessage.isNotEmpty
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.refresh),
                      label: Text(languageProvider.translate('retry')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    location,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  '${weatherData?['main']?['temp']?.toStringAsFixed(1) ?? '0'}°',
                                  style: TextStyle(
                                    color: _getTemperatureColor(
                                      weatherData?['main']?['temp'],
                                    ),
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  _getWeatherIcon(
                                    weatherData?['weather']?[0]?['icon'],
                                  ),
                                  color: _getWeatherIconColor(
                                    weatherData?['weather']?[0]?['icon'],
                                  ),
                                  size: 40,
                                ),
                              ],
                            ),
                            Text(
                              (weatherData?['weather']?[0]?['description'] ??
                                      '')
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildWeatherDetail(
                            color: Colors.amber,
                            icon: Icons.thermostat,
                            value:
                                '${weatherData?['main']?['feels_like']?.toStringAsFixed(1) ?? '0'}°C',
                            label: languageProvider.translate('feels_like'),
                          ),
                          const SizedBox(height: 12),
                          _buildWeatherDetail(
                            color: Colors.cyan,
                            icon: Icons.water_drop,
                            value:
                                '${weatherData?['main']?['humidity'] ?? '0'}%',
                            label: languageProvider.translate('humidity'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 20,
                    runSpacing: 16,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      _buildWeatherDetail(
                        color: Colors.lightBlue,
                        icon: Icons.air,
                        value: '${weatherData?['wind']?['speed'] ?? '0'} m/s',
                        label: languageProvider.translate('wind'),
                      ),
                      _buildWeatherDetail(
                        color: Colors.indigo,
                        icon: Icons.compress,
                        value:
                            '${weatherData?['main']?['pressure'] ?? '0'} hPa',
                        label: languageProvider.translate('pressure'),
                      ),
                      _buildWeatherDetail(
                        color: Colors.orange,
                        icon: Icons.wb_sunny,
                        value: _formatTime(
                          weatherData?['sys']?['sunrise'] ?? 0,
                        ),
                        label: languageProvider.translate('sunrise'),
                      ),
                      _buildWeatherDetail(
                        color: Colors.deepOrange,
                        icon: Icons.nights_stay,
                        value: _formatTime(weatherData?['sys']?['sunset'] ?? 0),
                        label: languageProvider.translate('sunset'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSearchBar(context),
                ],
              ),
    );
  }

  String _formatTime(int timestamp) {
    if (timestamp == 0) return '00:00';
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    );
    final String hour = dateTime.hour.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildWeatherDetail({
    required Color color,
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final TextEditingController controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0x4DFFFFFF)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              cursorColor: Colors.white,
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: languageProvider.translate('search_location'),
                hintStyle: const TextStyle(color: Colors.white70, fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  fetchWeatherByCity(value);
                  controller.clear();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white, size: 20),
            onPressed: _getCurrentLocation,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
