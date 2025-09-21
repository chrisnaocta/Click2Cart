import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'keranjang.dart';
import 'dashboard_page.dart';

class PembayaranPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts;

  const PembayaranPage({Key? key, required this.selectedProducts})
    : super(key: key);

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool uploaded = false;
  String _selectedMethod = "qris"; // default ke QRIS

  // Dummy data user
  String userName = 'John Doe';
  String userEmail = 'john@example.com';
  String userAlamat = 'Jl. Kebon Jeruk No. 123, Jakarta';
  String userTelepon = '08123456789';

  // Pilih gambar dari gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        uploaded = true;
      });
    }
  }

  // Format harga
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Hitung total
    int totalHarga = widget.selectedProducts.fold(0, (sum, item) {
      int price = int.parse(item['price'].toString());
      int qty = (item['quantity'] as num).toInt();
      return sum + (price * qty);
    });

    var uploadedText = uploaded
        ? Text("Uploaded ", style: TextStyle(fontSize: 16, color: Colors.blue))
        : SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 144, 238, 144),
                Color.fromARGB(255, 34, 139, 34),
                Color.fromARGB(255, 0, 128, 128),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => KeranjangPage()),
            );
          },
        ),
        title: const Text(
          "Pembayaran",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ List Produk
            Container(
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.selectedProducts.length,
                itemBuilder: (context, index) {
                  final item = widget.selectedProducts[index];
                  return ListTile(
                    leading: Image.network(
                      item['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, size: 50, color: Colors.red);
                      },
                    ),
                    title: Text(item['product']),
                    subtitle: Text(
                      "${formatCurrency(item['price'].toString())} x ${item['quantity']}",
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 8),

            // ✅ Total
            Container(
              color: Colors.white,
              width: screenWidth,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total", style: TextStyle(color: Colors.green)),
                  SizedBox(height: 8),
                  Text(
                    formatCurrency(totalHarga.toString()),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            // ✅ Info Pembayaran
            Container(
              color: Colors.white,
              width: screenWidth,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pilih Metode Pembayaran",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Radio button QRIS
                  RadioListTile<String>(
                    title: Text("QRIS"),
                    value: "qris",
                    groupValue: _selectedMethod,
                    activeColor:
                        Colors.black, // ⬅ warna saat dipilih jadi hitam
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value!;
                      });
                    },
                  ),

                  // Radio button Virtual Account
                  RadioListTile<String>(
                    title: Text("Virtual Account"),
                    value: "va",
                    groupValue: _selectedMethod,
                    activeColor:
                        Colors.black, // ⬅ warna saat dipilih jadi hitam
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value!;
                      });
                    },
                  ),

                  SizedBox(height: 16),

                  // ✅ Tampilkan detail sesuai pilihan
                  if (_selectedMethod == "qris") ...[
                    Text(
                      "Scan QRIS berikut untuk membayar:",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Image.network(
                      "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=contoh-qris",
                      width: 150,
                      height: 150,
                    ),
                  ] else if (_selectedMethod == "va") ...[
                    Text(
                      "Virtual Account (BCA)",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "1234567890",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text("A.N Click2Cart"),
                  ],
                ],
              ),
            ),

            // ✅ Tombol Buat Pesanan
            SizedBox(
              width: screenWidth - 80,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Pesanan berhasil dibuat"),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Delay sebentar biar SnackBar sempat tampil
                  Future.delayed(Duration(seconds: 1), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => DashboardPage()),
                      (route) => false, // hapus semua route sebelumnya
                    );
                  });
                },
                child: Text('Buat Pesanan'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 36),
                  backgroundColor: Color.fromARGB(255, 19, 166, 42),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
