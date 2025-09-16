import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // Untuk mengambil gambar
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  String _message = '';
  File? _imageFile; // Untuk menyimpan gambar yang dipilih

  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800, // Batas lebar maksimum gambar
      maxHeight: 800, // Batas tinggi maksimum gambar
      imageQuality: 80, // Kualitas gambar (0-100)
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Fungsi untuk melakukan registras
  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final nama = _namaController.text;
    final alamat = _alamatController.text;
    final telepon = _teleponController.text;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color.fromARGB(255, 26, 26, 26),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Stack(
        children: [
          // Gambar latar belakang
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white],
                stops: [1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // Foto dalam bentuk lingkaran
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color.fromARGB(255, 220, 220, 220),
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : null,
                      child: _imageFile == null
                          ? const Icon(Icons.person, size: 50)
                          : null, // Tampilkan icon person jika belum ada foto
                    ),
                    const SizedBox(height: 4),

                    // Hanya menampilkan nama file
                    if (_imageFile != null)
                      Text(
                        'Nama file: ${_namaController.text.split(" ")[0]}.jpg',
                        style: const TextStyle(fontSize: 14),
                      ),
                    const SizedBox(height: 8),

                    // Tombol Upload Foto
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            252,
                            252,
                            252,
                          ),
                          foregroundColor: const Color.fromARGB(
                            255,
                            39,
                            39,
                            39,
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Upload Foto (Opsional)',
                          style: TextStyle(fontSize: 16, letterSpacing: 0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 480,
                      child: TextField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          labelText: 'Nama',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 16.0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: 480,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 16.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 480,
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 16.0,
                          ),
                        ),
                        obscureText: true,
                      ),
                    ),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: 480,
                      child: TextField(
                        controller: _alamatController,
                        decoration: InputDecoration(
                          labelText: 'Alamat',
                          prefixIcon: const Icon(Icons.home),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 16.0,
                          ),
                        ),
                        minLines: 3,
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 480,
                      child: TextField(
                        controller: _teleponController,
                        decoration: InputDecoration(
                          labelText: 'No. Telepon',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 16.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const SizedBox(
                      width: 340,
                      child: Text(
                        "You will be sent back to the login screen after registering",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Tombol Register
                    SizedBox(
                      height: 48,
                      width: 160,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          backgroundColor: const Color.fromARGB(
                            255, // Alpha (0 = transparan, 255 = solid)
                            180, // Red
                            210, // Greenr
                            52, // Blue
                          ),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(_message, style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
