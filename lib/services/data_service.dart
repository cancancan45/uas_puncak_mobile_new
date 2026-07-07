import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// Import DTO dan Endpoints yang sudah kita buat tadi
import '../dto/datas.dart';
import '../endpoints/endpoints.dart';

class DataService {
  // ==========================================
  // 1. FUNGSI GET: Menarik Data dari Laravel
  // ==========================================
  static Future<List<Datas>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(Endpoints.posts));

      if (response.statusCode == 200) {
        // Decode JSON dari API
        final decoded = jsonDecode(response.body);

        // Sesuai kodingan Laravel kita, datanya dibungkus di dalam key 'data'
        final List<dynamic> dataList = decoded['data'];

        // Petakan ke dalam bentuk List<Datas>
        return dataList.map((json) => Datas.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data dari server');
      }
    } catch (e) {
      throw Exception('Error jaringan: $e');
    }
  }

  // ==========================================
  // 2. FUNGSI POST: Mengunggah Foto & Teks
  // ==========================================
  static Future<bool> uploadFoto(
    String nama,
    String? caption,
    File imageFile,
  ) async {
    try {
      // Karena kita mengirim file fisik, kita wajib pakai MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(Endpoints.posts));

      // Isi kolom teks
      request.fields['nama'] = nama;

      // Caption dikirim jika tidak kosong saja (sesuai nullable di Laravel)
      if (caption != null && caption.isNotEmpty) {
        request.fields['caption'] = caption;
      }

      // Masukkan file gambar
      // 'foto' adalah key yang kita wajibkan di validasi Laravel: 'foto' => 'required|image...'
      request.files.add(
        await http.MultipartFile.fromPath('foto', imageFile.path),
      );

      // Kirim request ke server
      var response = await request.send();

      // Jika statusnya 201 (Created), berarti berhasil masuk ke MySQL
      return response.statusCode == 201;
    } catch (e) {
      return false; // Jika error jaringan atau lainnya, kembalikan false
    }
  }

  // ==========================================
  // 3. FUNGSI DELETE: Menghapus Data (Opsional)
  // ==========================================
  static Future<bool> deletePost(int id) async {
    try {
      final response = await http.delete(Uri.parse('${Endpoints.posts}/$id'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
