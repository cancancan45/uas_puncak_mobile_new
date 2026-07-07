class Datas {
  final int id;
  final String name;
  final String?
  caption; // Menggunakan tanda ? karena caption tidak wajib (nullable)
  final String imageUrl;
  final String createdAt;

  Datas({
    required this.id,
    required this.name,
    this.caption,
    required this.imageUrl,
    required this.createdAt,
  });

  // Fungsi untuk memetakan data JSON dari Laravel ke dalam object Flutter
  factory Datas.fromJson(Map<String, dynamic> json) {
    return Datas(
      id: json['id'] ?? 0,
      name:
          json['nama'] ?? 'Tanpa Nama', // Key 'nama' sesuai database MySQL kita
      caption: json['caption'], // Dibiarkan apa adanya karena bisa null
      imageUrl: json['foto_url'] ?? '', // Key 'foto_url' sesuai database
      createdAt: json['created_at'] ?? '',
    );
  }
}
