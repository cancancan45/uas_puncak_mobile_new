import 'dart:ui';
import 'package:flutter/material.dart';

import '../services/data_service.dart';
import '../dto/datas.dart';
import 'upload_foto.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<Datas>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _futurePosts = DataService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // =========================================================
      // 1. APPBAR KLASIK WARNA KUNING (Sesuai Screenshot)
      // =========================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB300), // Kuning emas
        title: const Text(
          'PuncakID',
          style: TextStyle(
            fontFamily: 'hiatus',
            fontSize: 25, // Dikecilin sedikit biar pas di AppBar standar
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================================================
          // 2. TEKS DI BAWAH APPBAR
          // =========================================================
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),

          // =========================================================
          // 3. GRID FOTO EFEK BLUR
          // =========================================================
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: FutureBuilder<List<Datas>>(
                future: _futurePosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Gagal memuat data. ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Belum ada jejak pendakian.'),
                    );
                  }

                  final posts = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => BlurDetailDialog(post: post),
                          ).then((isDeleted) {
                            if (isDeleted == true) _refreshData();
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                post.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(color: Colors.grey),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black87,
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    post.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadFoto()),
          ).then((isUploaded) {
            if (isUploaded == true) _refreshData();
          });
        },
        backgroundColor: const Color(0xFFFFB300),
        child: const Icon(Icons.camera_alt, color: Colors.black87),
      ),
    );
  }
}

// (Sisa kodingan BlurDetailDialog biarkan sama persis seperti sebelumnya)
class BlurDetailDialog extends StatefulWidget {
  final Datas post;
  const BlurDetailDialog({super.key, required this.post});

  @override
  State<BlurDetailDialog> createState() => _BlurDetailDialogState();
}

class _BlurDetailDialogState extends State<BlurDetailDialog> {
  bool _showCaption = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showCaption = !_showCaption;
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            width: double.infinity,
            height: 480,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  widget.post.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey.shade900),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _showCaption ? 1.0 : 0.0,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _showCaption ? 1.0 : 0.0,
                  child: _showCaption
                      ? Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Color(0xFFFFB300),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.post.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          widget.post.createdAt
                                              .split('T')
                                              .first,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Divider(color: Colors.white30, height: 1),
                              const SizedBox(height: 20),
                              const Text(
                                'Cerita Pendakian:',
                                style: TextStyle(
                                  color: Color(0xFFFFB300),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.post.caption != null &&
                                            widget.post.caption!.isNotEmpty
                                        ? widget.post.caption!
                                        : 'Tidak ada cerita yang ditulis.',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                    size: 28,
                                  ),
                                  onPressed: () async {
                                    final nav = Navigator.of(context);
                                    bool success = await DataService.deletePost(
                                      widget.post.id,
                                    );
                                    if (!mounted) return;
                                    if (success) {
                                      nav.pop(true);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: !_showCaption ? 1.0 : 0.0,
                  child: !_showCaption
                      ? const Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 24.0),
                            child: Text(
                              'Ketuk gambar untuk melihat detail',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                backgroundColor: Colors.black45,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
