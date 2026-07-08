import 'package:flutter/material.dart';

import '../dto/mountain_model.dart';
import 'detail_mountain_screen.dart';

class MountainScreen extends StatefulWidget {
  const MountainScreen({super.key});

  @override
  State<MountainScreen> createState() => _MountainScreenState();
}

class _MountainScreenState extends State<MountainScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  String _searchQuery = '';

  final List<String> _filters = ['Semua', 'Populer', 'Pemula', 'Ekstrim'];

  // Data rekomendasi petualangan dengan mountainId yang tepat
  final List<Map<String, dynamic>> _adventures = [
    {
      'title': 'Sunrise Trek Batur',
      'duration': '1 Hari',
      'price': 'Rp 150rb',
      'imageUrl':
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=400&q=80',
      'mountainId': 2,
    },
    {
      'title': 'Agung Camping Night',
      'duration': '2 Hari',
      'price': 'Rp 350rb',
      'imageUrl':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
      'mountainId': 1,
    },
    {
      'title': 'Abang Ridge Trail',
      'duration': '1 Hari',
      'price': 'Rp 120rb',
      'imageUrl':
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400&q=80',
      'mountainId': 3,
    },
    {
      'title': 'Batukaru Jungle Trek',
      'duration': '2 Hari',
      'price': 'Rp 250rb',
      'imageUrl':
          'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=400&q=80',
      'mountainId': 4,
    },
  ];

  List<Mountain> get _filteredMountains {
    List<Mountain> list = MountainData.mountains;

    // Filter berdasarkan pencarian
    if (_searchQuery.isNotEmpty) {
      list = list
          .where(
            (m) =>
                m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                m.location.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Filter berdasarkan kategori
    if (_selectedFilter == 'Populer') {
      list = list.where((m) => m.rating >= 4.7).toList();
    } else if (_selectedFilter == 'Pemula') {
      list = list.where((m) => m.category == 'Pemula').toList();
    } else if (_selectedFilter == 'Ekstrim') {
      list = list.where((m) => m.category == 'Ekstrim').toList();
    }

    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearchingOrFiltering =
        _searchQuery.isNotEmpty || _selectedFilter != 'Semua';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ─── APP HEADER ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),

            // ─── SEARCH BAR ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: _buildSearchBar(),
            ),

            // ─── FILTER CHIPS ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: _buildFilterChips(),
            ),

            if (!isSearchingOrFiltering) ...[
              // ─── PALING POPULER (Default view) ──────────────────────
              SliverToBoxAdapter(
                child: _buildSectionHeader('Paling Populer', 'Lihat Semua'),
              ),
              SliverToBoxAdapter(
                child: _buildPopularMountains(),
              ),

              // ─── REKOMENDASI PETUALANGAN (Default view) ─────────────
              SliverToBoxAdapter(
                child: _buildSectionHeader('Rekomendasi Petualangan', ''),
              ),
              SliverToBoxAdapter(
                child: _buildAdventureList(),
              ),

              // ─── SEMUA GUNUNG BALI (Default view) ───────────────────
              SliverToBoxAdapter(
                child: _buildSectionHeader('Semua Gunung Bali', ''),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final m = MountainData.mountains[index];
                      return _buildMountainListTile(m);
                    },
                    childCount: MountainData.mountains.length,
                  ),
                ),
              ),
            ] else ...[
              // ─── HASIL PENCARIAN & FILTER ───────────────────────────
              SliverToBoxAdapter(
                child: _buildSectionHeader(
                  _searchQuery.isNotEmpty
                      ? 'Hasil Pencarian "$_searchQuery"'
                      : 'Hasil Kategori "$_selectedFilter"',
                  '',
                ),
              ),
              if (_filteredMountains.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.terrain_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            'Gunung tidak ditemukan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Coba masukkan kata kunci atau kategori lain',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final m = _filteredMountains[index];
                        return _buildMountainListTile(m);
                      },
                      childCount: _filteredMountains.length,
                    ),
                  ),
                ),
            ],

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // WIDGET BUILDERS
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jelajahi',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Puncak Bali',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('🏔️', style: TextStyle(fontSize: 22)),
                ],
              ),
            ],
          ),
          // Badge lokasi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 14,
                  color: Color(0xFFFFB300),
                ),
                const SizedBox(width: 4),
                Text(
                  'Bali, IDN',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Cari gunung di Bali...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: Colors.grey.shade400,
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFFB300)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? const Color(0xFFFFB300).withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          if (action.isNotEmpty)
            GestureDetector(
              onTap: () {},
              child: Text(
                action,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFFFB300),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPopularMountains() {
    // Tampilkan 4 gunung pertama sebagai "populer"
    final popular = MountainData.mountains.take(4).toList();
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: popular.length,
        itemBuilder: (context, index) {
          return _buildMountainCard(popular[index]);
        },
      ),
    );
  }

  Widget _buildMountainCard(Mountain mountain) {
    Color categoryColor;
    switch (mountain.category) {
      case 'Pemula':
        categoryColor = const Color(0xFF43A047);
        break;
      case 'Moderat':
        categoryColor = const Color(0xFF1E88E5);
        break;
      default:
        categoryColor = const Color(0xFFE53935);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailMountainScreen(mountain: mountain),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Gambar gunung
              Image.network(
                mountain.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.terrain, size: 48),
                ),
              ),
              // Gradient overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                    stops: [0.4, 1.0],
                  ),
                ),
              ),
              // Badge kategori
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    mountain.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Tombol favorit
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              // Info bawah
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mountain.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.terrain,
                              color: Colors.white70,
                              size: 12,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${mountain.elevation} mdpl',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFFB300),
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              mountain.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdventureList() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _adventures.length,
        itemBuilder: (context, index) {
          final adv = _adventures[index];
          return GestureDetector(
            onTap: () {
              final mId = adv['mountainId'] as int?;
              if (mId != null) {
                final mountain = MountainData.mountains.firstWhere(
                  (m) => m.id == mId,
                  orElse: () => MountainData.mountains.first,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailMountainScreen(mountain: mountain),
                  ),
                );
              }
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      adv['imageUrl']!,
                      height: 75,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 75,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          adv['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 10,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  adv['duration']!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              adv['price']!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFB300),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMountainListTile(Mountain mountain) {
    Color categoryColor;
    switch (mountain.category) {
      case 'Pemula':
        categoryColor = const Color(0xFF43A047);
        break;
      case 'Moderat':
        categoryColor = const Color(0xFF1E88E5);
        break;
      default:
        categoryColor = const Color(0xFFE53935);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailMountainScreen(mountain: mountain),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                mountain.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.terrain),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mountain.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    mountain.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          mountain.category,
                          style: TextStyle(
                            fontSize: 10,
                            color: categoryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: Color(0xFFFFB300),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        mountain.rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Elevasi
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${mountain.elevation}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFFFB300),
                  ),
                ),
                Text(
                  'mdpl',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
