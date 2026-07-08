import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../dto/mountain_model.dart';

class MapScreen extends StatefulWidget {
  final Mountain mountain;

  const MapScreen({super.key, required this.mountain});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  double _currentZoom = 13.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 1).clamp(3.0, 18.0);
      _mapController.move(
        LatLng(widget.mountain.lat, widget.mountain.lng),
        _currentZoom,
      );
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(3.0, 18.0);
      _mapController.move(
        LatLng(widget.mountain.lat, widget.mountain.lng),
        _currentZoom,
      );
    });
  }

  void _recenter() {
    setState(() {
      _currentZoom = 13.0;
      _mapController.move(
        LatLng(widget.mountain.lat, widget.mountain.lng),
        _currentZoom,
      );
    });
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Pemula':
        return const Color(0xFF4CAF50); // Hijau
      case 'Moderat':
        return const Color(0xFF1E88E5); // Biru
      default:
        return const Color(0xFFE53935); // Merah
    }
  }

  @override
  Widget build(BuildContext context) {
    final mountain = widget.mountain;
    final mountainLatLng = LatLng(mountain.lat, mountain.lng);
    final categoryColor = _getCategoryColor(mountain.category);

    return Scaffold(
      body: Stack(
        children: [
          // ==========================================
          // 1. DYNAMIC OPENSTREETMAP RENDERER (flutter_map)
          // ==========================================
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: mountainLatLng,
              initialZoom: _currentZoom,
              minZoom: 3.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.uas_puncak_mobile',
              ),
              MarkerLayer(
                markers: [
                  // Penanda Pin di Koordinat Asli Gunung
                  Marker(
                    point: mountainLatLng,
                    width: 100,
                    height: 80,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Label Orange di atas Pin
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB300), // Orange/Kuning emas
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            mountain.name.replaceAll('Gunung ', ''),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Segitiga kecil di bawah label
                        CustomPaint(
                          size: const Size(10, 5),
                          painter: _TrianglePainter(const Color(0xFFFFB300)),
                        ),
                        const SizedBox(height: 2),
                        // Pin merah
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFE53935),
                          size: 38,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ==========================================
          // 2. TRANSLUCENT APP BAR ON TOP
          // ==========================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                bottom: 16,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: Row(
                children: [
                  // Tombol Back
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Detail Judul
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mountain.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          mountain.location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol Recenter GPS
                  GestureDetector(
                    onTap: _recenter,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.my_location,
                        color: Color(0xFFFFB300),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ==========================================
          // 3. DARK BOTTOM CONTROL PANEL (Sesuai Mockup)
          // ==========================================
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C), // Dark grey
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Baris Atas: Status GPS & Tombol Zoom +/-
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // GPS Aktif
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50), // Hijau menyala
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'GPS AKTIF',
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      // Zoom In & Out Buttons
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _zoomOut,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _zoomIn,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Baris Tengah: Box Statistik (Lintang, Bujur, Puncak)
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoBox(
                          'LINTANG',
                          mountain.lat.toStringAsFixed(4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInfoBox(
                          'BUJUR',
                          mountain.lng.toStringAsFixed(4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInfoBox(
                          'PUNCAK',
                          '${mountain.elevation} mdpl',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  const Divider(color: Colors.white10, height: 1),
                  const SizedBox(height: 12),

                  // Baris Bawah: Nama & Kategori
                  Row(
                    children: [
                      const Icon(
                        Icons.terrain,
                        color: Color(0xFFFFB300),
                        size: 16,
                      ),
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
                      const Text(
                        '•',
                        style: TextStyle(color: Colors.white30),
                      ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 9,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Painter Segitiga kecil untuk Label Pin
class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
