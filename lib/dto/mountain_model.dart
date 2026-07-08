// Model data Gunung untuk aplikasi PuncakID
class Mountain {
  final int id;
  final String name;
  final String location;
  final int elevation; // dalam mdpl
  final double lat; // lintang untuk Open-Meteo API
  final double lng; // bujur untuk Open-Meteo API
  final String imageUrl;
  final String category; // 'Pemula', 'Moderat', 'Ekstrim'
  final String description;
  final double rating;
  final int reviewCount;
  final List<String> facilities;
  final String trailInfo;

  const Mountain({
    required this.id,
    required this.name,
    required this.location,
    required this.elevation,
    required this.lat,
    required this.lng,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.facilities,
    required this.trailInfo,
  });
}

// Model data cuaca dari Open-Meteo
class WeatherData {
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final int humidity;

  const WeatherData({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.humidity,
  });

  /// Deskripsi kondisi cuaca berdasarkan WMO Weather Code
  String get description {
    if (weatherCode == 0) return 'Cerah';
    if (weatherCode <= 3) return 'Berawan Sebagian';
    if (weatherCode <= 49) return 'Berkabut';
    if (weatherCode <= 69) return 'Hujan Ringan';
    if (weatherCode <= 79) return 'Salju';
    if (weatherCode <= 99) return 'Badai Petir';
    return 'Tidak Diketahui';
  }

  /// Ikon cuaca berdasarkan kode WMO
  String get icon {
    if (weatherCode == 0) return '☀️';
    if (weatherCode <= 3) return '⛅';
    if (weatherCode <= 49) return '🌫️';
    if (weatherCode <= 69) return '🌧️';
    if (weatherCode <= 79) return '❄️';
    if (weatherCode <= 99) return '⛈️';
    return '🌡️';
  }
}

// Model untuk Riwayat Pendakian (digunakan di ProfileScreen)
class ClimbingHistory {
  final String mountainName;
  final String location;
  final int elevation;
  final String date;
  final String colorHex;

  const ClimbingHistory({
    required this.mountainName,
    required this.location,
    required this.elevation,
    required this.date,
    required this.colorHex,
  });
}

// =====================================================
// DATA STATIS: 7 Gunung di Bali dengan koordinat real
// =====================================================
class MountainData {
  static const List<Mountain> mountains = [
    Mountain(
      id: 1,
      name: 'Gunung Agung',
      location: 'Karangasem, Bali',
      elevation: 3142,
      lat: -8.3430,
      lng: 115.5080,
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
      category: 'Ekstrim',
      description:
          'Gunung Agung adalah gunung tertinggi di pulau Bali dengan ketinggian 3.142 mdpl. Gunung ini merupakan gunung berapi aktif tipe stratovolcano yang dikeramatkan oleh masyarakat Hindu Bali. Jalur pendakiannya sangat menantang dan membutuhkan kondisi fisik prima. Dari puncaknya, pendaki bisa menyaksikan panorama seluruh Bali hingga Lombok saat cuaca cerah.',
      rating: 4.9,
      reviewCount: 512,
      facilities: ['Pos Registrasi', 'Pemandu Wajib', 'Sumber Air', 'Shelter'],
      trailInfo: 'Jalur Pura Besakih & Pura Pasar Agung • 8-12 jam PP',
    ),
    Mountain(
      id: 2,
      name: 'Gunung Batur',
      location: 'Kintamani, Bangli',
      elevation: 1717,
      lat: -8.2420,
      lng: 115.3750,
      imageUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&q=80',
      category: 'Pemula',
      description:
          'Gunung Batur adalah gunung berapi aktif yang terkenal dengan sunrise trek-nya. Terletak di kaldera besar dengan danau Batur yang indah di bawahnya. Sangat cocok untuk pendaki pemula dengan jalur yang relatif mudah. Sunrise dari puncak Batur adalah salah satu pemandangan paling ikonik di Bali.',
      rating: 4.8,
      reviewCount: 1203,
      facilities: [
        'Pos Registrasi',
        'Pemandu Tersedia',
        'Warung Puncak',
        'Parkir Luas',
      ],
      trailInfo: 'Jalur Toya Bungkah • 3-4 jam PP',
    ),
    Mountain(
      id: 3,
      name: 'Gunung Abang',
      location: 'Kintamani, Bangli',
      elevation: 2151,
      lat: -8.2750,
      lng: 115.4080,
      imageUrl:
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=800&q=80',
      category: 'Moderat',
      description:
          'Gunung Abang adalah gunung tertinggi ketiga di Bali yang masih jarang dikunjungi. Terletak di tepi kaldera Batur, menawarkan pemandangan luar biasa ke danau dan gunung Batur. Jalurnya melewati hutan lebat yang masih alami dengan keanekaragaman hayati tinggi.',
      rating: 4.6,
      reviewCount: 287,
      facilities: [
        'Pos Registrasi',
        'Pemandu Tersedia',
        'Sumber Air',
        'Camping Area',
      ],
      trailInfo: 'Jalur Desa Abang • 5-7 jam PP',
    ),
    Mountain(
      id: 4,
      name: 'Gunung Batukaru',
      location: 'Tabanan, Bali',
      elevation: 2276,
      lat: -8.3160,
      lng: 115.1220,
      imageUrl:
          'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=800&q=80',
      category: 'Moderat',
      description:
          'Gunung Batukaru merupakan gunung tertinggi kedua di Bali dan dianggap sebagai salah satu gunung paling sakral. Dikelilingi hutan hujan tropis yang lebat dengan Pura Luhur Batukaru di lerengnya. Jalur pendakian melewati hutan yang sangat lebat dan lembab.',
      rating: 4.7,
      reviewCount: 198,
      facilities: ['Pura Luhur', 'Pemandu Wajib', 'Sumber Mata Air', 'Shelter'],
      trailInfo: 'Jalur Pura Luhur Batukaru • 6-9 jam PP',
    ),
    Mountain(
      id: 5,
      name: 'Gunung Catur',
      location: 'Badung, Bali',
      elevation: 2096,
      lat: -8.2910,
      lng: 115.2030,
      imageUrl:
          'https://images.unsplash.com/photo-1511884642898-4c92249e20b6?w=800&q=80',
      category: 'Moderat',
      description:
          'Gunung Catur atau Puncak Mangu terletak di kawasan Bedugul. Dari puncaknya terdapat Pura Puncak Mangu yang sangat dikeramatkan. Pemandangan ke arah Danau Beratan, Buyan, dan Tamblingan sangat menakjubkan. Jalurnya melewati kebun kopi dan hutan pinus yang indah.',
      rating: 4.5,
      reviewCount: 156,
      facilities: [
        'Pos Registrasi',
        'Pemandu Tersedia',
        'Warung Basecamp',
        'Parkir',
      ],
      trailInfo: 'Jalur Bedugul • 4-6 jam PP',
    ),
    Mountain(
      id: 6,
      name: 'Gunung Pengelengan',
      location: 'Buleleng, Bali',
      elevation: 1745,
      lat: -8.2340,
      lng: 115.1500,
      imageUrl:
          'https://images.unsplash.com/photo-1540202404-a2f29016b523?w=800&q=80',
      category: 'Pemula',
      description:
          'Gunung Pengelengan adalah destinasi trekking yang masih tersembunyi di Bali utara. Menawarkan pemandangan Laut Bali yang memukau dari ketinggian. Jalurnya melewati perkebunan dan hutan yang sejuk. Sangat cocok untuk pendaki pemula yang ingin pengalaman mendaki pertama.',
      rating: 4.3,
      reviewCount: 89,
      facilities: [
        'Pos Registrasi',
        'Sumber Air',
        'Area Kemah',
        'Pemandu Lokal',
      ],
      trailInfo: 'Jalur Desa Pengelengan • 3-5 jam PP',
    ),
    Mountain(
      id: 7,
      name: 'Gunung Tapak',
      location: 'Singaraja, Bali',
      elevation: 1903,
      lat: -8.1850,
      lng: 115.0890,
      imageUrl:
          'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=800&q=80',
      category: 'Moderat',
      description:
          'Gunung Tapak adalah destinasi trekking tersembunyi di Bali yang menawarkan keindahan alam yang masih sangat alami. Terdapat air terjun indah di sepanjang jalur pendakian. Hutan tropisnya yang lebat menjadi habitat berbagai satwa liar endemik Bali.',
      rating: 4.4,
      reviewCount: 112,
      facilities: ['Sumber Air', 'Air Terjun', 'Pemandu Lokal', 'Camping Area'],
      trailInfo: 'Jalur Desa Gitgit • 5-7 jam PP',
    ),
  ];

  // Data riwayat pendakian untuk halaman profil
  static const List<ClimbingHistory> climbingHistory = [
    ClimbingHistory(
      mountainName: 'Gunung Agung',
      location: 'Karangasem, Bali',
      elevation: 3142,
      date: '14 Jun 2025',
      colorHex: 'E53935',
    ),
    ClimbingHistory(
      mountainName: 'Gunung Batur',
      location: 'Kintamani, Bangli',
      elevation: 1717,
      date: '2 Mar 2025',
      colorHex: 'FB8C00',
    ),
    ClimbingHistory(
      mountainName: 'Gunung Abang',
      location: 'Kintamani, Bangli',
      elevation: 2151,
      date: '20 Jan 2025',
      colorHex: '1E88E5',
    ),
    ClimbingHistory(
      mountainName: 'Gunung Batukaru',
      location: 'Tabanan, Bali',
      elevation: 2276,
      date: '5 Nov 2024',
      colorHex: '43A047',
    ),
    ClimbingHistory(
      mountainName: 'Gunung Catur',
      location: 'Badung, Bali',
      elevation: 2096,
      date: '18 Agt 2024',
      colorHex: '8E24AA',
    ),
  ];
}
