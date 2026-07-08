import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/data_service.dart';

class UploadFoto extends StatefulWidget {
  const UploadFoto({super.key});

  @override
  State<UploadFoto> createState() => _UploadFotoState();
}

class _UploadFotoState extends State<UploadFoto> {
  // Controller untuk menangkap teks inputan user
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  File? _imageFile; // Tempat menyimpan file foto sementara sebelum di-upload
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false; // Status loading saat proses upload ke Laravel

  // Fungsi untuk mengambil gambar dari Kamera atau Galeri
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality:
            70, // Kompres kualitas gambar ke 70% agar upload-nya cepat dan hemat kuota
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil gambar: $e')));
    }
  }

  // Fungsi Utama: Mengirim data ke DataService
  Future<void> _doUpload() async {
    // Validasi form dasar
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ketik namamu di kolom yang tersedia!')),
      );
      return;
    }
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih atau ambil foto terlebih dahulu!')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Aktifkan loading spinner
    });

    // Panggil fungsi POST di DataService kita
    bool success = await DataService.uploadFoto(
      _nameController.text.trim(),
      _captionController.text.trim().isEmpty
          ? null
          : _captionController.text.trim(),
      _imageFile!,
    );

    setState(() {
      _isLoading = false; // Matikan loading spinner
    });

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jejak pendakian berhasil diunggah! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
        // Kembali ke halaman Feed dengan membawa status sukses (true)
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengunggah foto. Periksa koneksi/Ngrok Anda.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bagikan Cerita',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Sedang mengirim data ke basecamp server...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. AREA PREVIEW FOTO
                  GestureDetector(
                    onTap: () {
                      // Munculkan pilihan Camera atau Gallery dari bawah (Bottom Sheet)
                      _showImageSourceActionSheet(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 50,
                                  color: Color.fromARGB(255, 255, 183, 0),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Ketuk untuk Tambah Foto',
                                  style: TextStyle(
                                    color: Color.fromARGB(
                                      255,
                                      255,
                                      183,
                                      0,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Kamera atau Galeri',
                                  style: TextStyle(
                                    color: Color.fromARGB(146, 255, 183, 0),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. INPUT NAMA PENDAKI
                  const Text(
                    'Nama',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama kamu...',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. INPUT CAPTION / CERITA PENDAKIAN
                  const Text(
                    'Cerita Pendakian',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _captionController,
                    maxLines: 4, // Membuat input box melebar ke bawah
                    decoration: InputDecoration(
                      hintText:
                          'Ceritakan keseruan perjalananmu di sini (opsional)...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 4. TOMBOL SUBMIT UPLOAD
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _doUpload,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 183, 0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Unggah Foto',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Desain pop-up menu pilihan sumber gambar
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: Color.fromARGB(255, 255, 183, 0),
              ),
              title: const Text('Kamera (Ambil Foto Langsung)'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: Color.fromARGB(255, 255, 183, 0),
              ),
              title: const Text('Galeri (Pilih dari HP)'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
