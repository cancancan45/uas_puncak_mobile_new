import 'package:flutter/material.dart';

import '../dto/mountain_model.dart';
import '../services/weather_service.dart';
import 'map_screen.dart';

class DetailMountainScreen extends StatefulWidget {
  final Mountain mountain;

  const DetailMountainScreen({super.key, required this.mountain});

  @override
  State<DetailMountainScreen> createState() => _DetailMountainScreenState();
}

class _DetailMountainScreenState extends State<DetailMountainScreen> {
  // Future untuk data cuaca yang diambil secara asinkron
  late Future<WeatherData> _weatherFuture;
  bool _isFavorite = false;
  bool _showFullDescription = false;

  @override
  void initState() {
    super.initState();
    // Mulai fetch cuaca real-time via http.get ke Open-Meteo API
    // menggunakan koordinat lat/lng dari objek mountain yang diterima
    _weatherFuture = WeatherService.fetchWeather(
      widget.mountain.lat,
      widget.mountain.lng,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mountain = widget.mountain;
    final categoryColor = _getCategoryColor(mountain.category);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ─── HERO IMAGE + APP BAR ───────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF1A1A2E),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    mountain.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: Colors.grey.shade400,
                      child: const Icon(
                        Icons.terrain,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Gradient di bawah gambar
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              // Tombol Favorit
              GestureDetector(
                onTap: () => setState(() => _isFavorite = !_isFavorite),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.redAccent : Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          // ─── KONTEN UTAMA ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama + Lihat Peta
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          mountain.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _openMapScreen,
                        child: const Text(
                          'Lihat Peta',
                          style: TextStyle(
                            color: Color(0xFFFFB300),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Rating + Lokasi
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFB300), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${mountain.rating} (${mountain.reviewCount} Ulasan)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFE53935),
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          mountain.location,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi (bisa expand)
                  AnimatedCrossFade(
                    firstChild: Text(
                      mountain.description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    secondChild: Text(
                      mountain.description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    crossFadeState: _showFullDescription
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _showFullDescription = !_showFullDescription),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Text(
                            _showFullDescription ? 'Lebih sedikit' : 'Selengkapnya',
                            style: const TextStyle(
                              color: Color(0xFFFFB300),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Icon(
                            _showFullDescription
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: const Color(0xFFFFB300),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── CUACA REAL-TIME (Open-Meteo API) ─────────────
                  _buildWeatherCard(),

                  const SizedBox(height: 20),

                  // ─── FASILITAS & JALUR ─────────────────────────────
                  const Text(
                    'Fasilitas & Jalur',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFacilitiesRow(mountain.facilities),
                  const SizedBox(height: 16),

                  // Info jalur
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.route,
                          color: Color(0xFFFFB300),
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            mountain.trailInfo,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ─── TINGKAT JALUR + TOMBOL BUKA PETA ─────────────
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tingkat Jalur',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            mountain.category,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: categoryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _openMapScreen,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFB300),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                            shadowColor: const Color(0xFFFFB300).withValues(alpha: 0.4),
                          ),
                          icon: const Icon(Icons.map, size: 18),
                          label: const Text(
                            'Buka Peta GPS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ─── INFO KOORDINAT ────────────────────────────────
                  _buildCoordinateCard(mountain),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── WIDGET: CUACA REAL-TIME ──────────────────────────────────────────────
  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD0DCFF), width: 1),
      ),
      child: FutureBuilder<WeatherData>(
        future: _weatherFuture,
        builder: (context, snapshot) {
          // === LOADING STATE ===
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.cloud_outlined,
                    color: Color(0xFF5C6BC0),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cuaca Puncak (Real-time)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5C6BC0),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Memuat cuaca...',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Sumber: Open-Meteo API',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF5C6BC0),
                  ),
                ),
              ],
            );
          }

          // === ERROR STATE ===
          if (snapshot.hasError) {
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.cloud_off,
                    color: Colors.red,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cuaca Puncak (Real-time)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5C6BC0),
                        ),
                      ),
                      Text(
                        'Gagal memuat cuaca',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Tombol retry
                IconButton(
                  onPressed: () {
                    setState(() {
                      _weatherFuture = WeatherService.fetchWeather(
                        widget.mountain.lat,
                        widget.mountain.lng,
                      );
                    });
                  },
                  icon: const Icon(Icons.refresh, color: Color(0xFF5C6BC0)),
                ),
              ],
            );
          }

          // === DATA BERHASIL DIMUAT ===
          final weather = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      weather.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cuaca Puncak (Real-time)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5C6BC0),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${weather.temperature.toStringAsFixed(1)}°C',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              weather.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Sumber: Open-Meteo API',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFD0DCFF)),
              const SizedBox(height: 12),
              // Detail cuaca: kelembaban, angin
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherDetail(
                    '💧',
                    'Kelembaban',
                    '${weather.humidity}%',
                  ),
                  _buildWeatherDetail(
                    '🌬️',
                    'Angin',
                    '${weather.windSpeed.toStringAsFixed(0)} km/j',
                  ),
                  _buildWeatherDetail(
                    '📍',
                    'Koordinat',
                    '${widget.mountain.lat.abs().toStringAsFixed(2)}°${widget.mountain.lat < 0 ? 'S' : 'N'}',
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWeatherDetail(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF1A1A2E),
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildFacilitiesRow(List<String> facilities) {
    final icons = [
      Icons.assignment_outlined,
      Icons.person_outline,
      Icons.water_drop_outlined,
      Icons.landscape_outlined,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        facilities.length > 4 ? 4 : facilities.length,
        (index) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icons[index % icons.length],
                  color: const Color(0xFFFFB300),
                  size: 24,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 70,
                child: Text(
                  facilities[index]
                      .replaceAll('Registrasi', 'Reg.')
                      .replaceAll('Tersedia', ''),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCoordinateCard(Mountain mountain) {
    final categoryColor = _getCategoryColor(mountain.category);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // GPS Aktif badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'GPS AKTIF',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.remove, color: Colors.white, size: 14),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Koordinat dan elevasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCoordItem(
                'LINTANG',
                mountain.lat.toStringAsFixed(4),
              ),
              Container(width: 1, height: 30, color: Colors.white24),
              _buildCoordItem(
                'BUJUR',
                mountain.lng.toStringAsFixed(4),
              ),
              Container(width: 1, height: 30, color: Colors.white24),
              _buildCoordItem(
                'PUNCAK',
                '${mountain.elevation} mdpl',
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.white12),
          const SizedBox(height: 6),
          // Nama gunung + kategori
          Row(
            children: [
              const Icon(Icons.terrain, color: Color(0xFFFFB300), size: 16),
              const SizedBox(width: 6),
              Text(
                mountain.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: Colors.white38)),
              const SizedBox(width: 8),
              Text(
                mountain.category,
                style: TextStyle(
                  color: categoryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoordItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade400,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Pemula':
        return const Color(0xFF43A047);
      case 'Moderat':
        return const Color(0xFF1E88E5);
      default:
        return const Color(0xFFE53935);
    }
  }

  void _openMapScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(mountain: widget.mountain),
      ),
    );
  }
}
