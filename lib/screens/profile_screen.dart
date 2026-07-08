import 'package:flutter/material.dart';
import '../dto/mountain_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. DARK BLUE HEADER WITH CURVED BOTTOM
            // ==========================================
            _buildProfileHeader(),

            const SizedBox(height: 24),

            // ==========================================
            // 2. LENCANA PENDAKI SECTION
            // ==========================================
            _buildLencanaSection(),

            const SizedBox(height: 24),

            // ==========================================
            // 3. RIWAYAT PENDAKIAN SECTION
            // ==========================================
            _buildRiwayatSection(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Header Profil (Sesuai Screenshot Pertama)
  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F2027), // Dark blue-black
            Color(0xFF203A43),
            Color(0xFF2C5364),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(36),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      child: Column(
        children: [
          // Avatar dengan border kuning menyala + checklist kuning kecil
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFFB300), // Kuning emas
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFB300).withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
                  ),
                ),
              ),
              // Badge verified kuning
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFB300),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Nama
          const Text(
            'Sobat Puncak',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          const Text(
            'Pendaki Bali · Anggota Sejak 2023',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // Divider garis tipis horizontal
          Container(
            height: 1,
            color: Colors.white12,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          const SizedBox(height: 20),

          // Statistik (3 Kolom)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('5', 'Gunung\nDidaki'),
              Container(width: 1, height: 35, color: Colors.white12),
              _buildStatItem('12', 'Total\nPendakian'),
              Container(width: 1, height: 35, color: Colors.white12),
              _buildStatItem('3,142', 'Puncak\nTertinggi (m)'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  // Bagian Lencana Pendaki
  Widget _buildLencanaSection() {
    // Definisi data badge untuk lencana
    final List<Map<String, dynamic>> badges = [
      {
        'title': 'Summit\nSeeker',
        'icon': Icons.star,
        'color': const Color(0xFFFFB300),
        'bg': const Color(0xFFFFF8E1),
      },
      {
        'title': 'Foto\nAdventurer',
        'icon': Icons.camera_alt,
        'color': const Color(0xFF1E88E5),
        'bg': const Color(0xFFE3F2FD),
      },
      {
        'title': 'Penjaga\nAlam',
        'icon': Icons.eco,
        'color': const Color(0xFF43A047),
        'bg': const Color(0xFFE8F5E9),
      },
      {
        'title': 'Hardcore\nHiker',
        'icon': Icons.local_fire_department,
        'color': const Color(0xFFE53935),
        'bg': const Color(0xFFFFEBEE),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lencana Pendaki',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: badges.length,
              itemBuilder: (context, index) {
                final badge = badges[index];
                return Container(
                  width: 90,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: badge['color'].withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: badge['color'].withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: badge['bg'],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          badge['icon'],
                          color: badge['color'],
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        badge['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Bagian Riwayat Pendakian
  Widget _buildRiwayatSection() {
    final history = MountainData.climbingHistory;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Pendakian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              final hexColor = int.parse('0xFF${item.colorHex}');

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon gunung bergaya
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(hexColor).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.terrain,
                        color: Color(hexColor),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Detail teks kiri
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.mountainName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Detail teks kanan (elevasi dan tanggal)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${item.elevation.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} mdpl',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFFFFB300),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.date,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
