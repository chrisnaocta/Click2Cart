import 'package:flutter/material.dart';
import 'login.dart'; // Import login.dart

// Warna dominan yang digunakan (hijau)
// Color.fromARGB(255, 19, 166, 42)
// Color: Color.fromARGB(255, 180, 210, 52)

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Click2Cart',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 15, 107),
        ),
      ),
      home:
          LoginPage(), // Menetapkan Login page sebagai halaman utama (Halaman yang akan pertama dibuka jika program dijalankan)
    );
  }
}
