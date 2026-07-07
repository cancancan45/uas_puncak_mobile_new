import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          // Gambar Background
          Image.asset(
            'assets/images/onboarding.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Font Hiatus
                  const Center(
                    child: Text(
                      'PuncakID', // Disesuaikan dengan nama aplikasimu
                      style: TextStyle(
                        fontFamily: 'Hiatus',
                        fontSize: 75, // Disesuaikan ukurannya biar pas di layar
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 5,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Teks Deskripsi
                  const Text(
                    'Jelajahi',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontStyle: FontStyle.normal,
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    'Puncak\nPulau Dewata',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontStyle: FontStyle.normal,
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tombol Navigasi
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // 👇 INI CARA PUSHBACK / REPLACE ROUTE-NYA
                        Navigator.pushReplacementNamed(context, '/main');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 183, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        'Mulai',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
