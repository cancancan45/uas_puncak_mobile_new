import 'package:http/http.dart' as http;
import 'dart:convert';

import '../dto/mountain_model.dart';

/// Service untuk mengambil data cuaca real-time dari Open-Meteo API
/// Dokumentasi: https://open-meteo.com/en/docs
class WeatherService {
  // Base URL Open-Meteo – gratis, tidak butuh API key
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  /// Mengambil data cuaca puncak gunung secara ASINKRON menggunakan http.get
  /// [lat] : koordinat lintang gunung
  /// [lng] : koordinat bujur gunung
  static Future<WeatherData> fetchWeather(double lat, double lng) async {
    // Bangun URL dengan parameter koordinat dan variabel cuaca yang diinginkan
    final uri = Uri.parse(
      '$_baseUrl'
      '?latitude=$lat'
      '&longitude=$lng'
      '&current=temperature_2m,wind_speed_10m,weather_code,relative_humidity_2m'
      '&timezone=Asia%2FMakassar' // Timezone Bali (WITA)
      '&wind_speed_unit=kmh',
    );

    try {
      // Panggil REST API Open-Meteo secara asinkron via http.get
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 10)); // timeout 10 detik

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);

        // Ambil data dari key 'current' yang dikembalikan Open-Meteo
        final current = decoded['current'] as Map<String, dynamic>;

        return WeatherData(
          temperature: (current['temperature_2m'] as num).toDouble(),
          windSpeed: (current['wind_speed_10m'] as num).toDouble(),
          weatherCode: (current['weather_code'] as num).toInt(),
          humidity: (current['relative_humidity_2m'] as num).toInt(),
        );
      } else {
        throw Exception('Gagal mengambil data cuaca (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error jaringan cuaca: $e');
    }
  }
}
