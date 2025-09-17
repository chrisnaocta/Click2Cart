import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'keranjang.dart';

class ProductDetailPage extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productImage;
  final String productDescription;
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productDescription,
    required this.productId,
  });

  // Fungsi format harga
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price.replaceAll(RegExp(r'[^0-9]'), '')));
  }

  @override
  Widget build(BuildContext context) {
    String formattedPrice = formatCurrency(productPrice);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Produk",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 19, 42, 166),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 252, 252, 255),
        foregroundColor: const Color.fromARGB(255, 19, 42, 166),
        toolbarHeight: 60,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background gradient
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 246, 246, 255),
                  ],
                  stops: [0, 1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Konten
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gambar produk
                  Center(
                    child: Image.network(
                      productImage,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          size: 100,
                          color: Colors.red,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nama produk
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Deskripsi
                  Text(
                    productDescription,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // Harga
                  Text(
                    formattedPrice,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 160, 5),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Beli
                  // Tombol Beli
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();

                      // Ambil keranjang yang sudah ada
                      List<String> cart = prefs.getStringList('cart') ?? [];

                      // Decode keranjang ke dalam list of map
                      List<Map<String, dynamic>> cartItems = cart
                          .map(
                            (item) => jsonDecode(item) as Map<String, dynamic>,
                          )
                          .toList();

                      // Cek apakah produk sudah ada di keranjang
                      int existingIndex = cartItems.indexWhere(
                        (item) => item['idproduct'] == productId,
                      );

                      if (existingIndex != -1) {
                        // Kalau sudah ada → tambahkan quantity
                        cartItems[existingIndex]['quantity'] =
                            (cartItems[existingIndex]['quantity'] as int) + 1;
                      } else {
                        // Kalau belum ada → tambah produk baru
                        Map<String, dynamic> newProduct = {
                          "idproduct": productId,
                          "product": productName,
                          "price": productPrice,
                          "image": productImage,
                          "description": productDescription,
                          "quantity": 1,
                        };
                        cartItems.add(newProduct);
                      }

                      // Simpan kembali ke SharedPreferences (encode ke JSON string list)
                      List<String> updatedCart = cartItems
                          .map((item) => jsonEncode(item))
                          .toList();
                      await prefs.setStringList('cart', updatedCart);

                      // Pindah ke halaman Keranjang
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KeranjangPage(),
                        ),
                      );

                      // Notifikasi
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "$productName berhasil ditambahkan ke keranjang",
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      backgroundColor: const Color.fromARGB(255, 4, 28, 162),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Tambahkan ke keranjang',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
