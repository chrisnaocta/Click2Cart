import 'dart:io';
import 'package:image_picker/image_picker.dart'; // Untuk ambil gambar
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PembayaranPage extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productImage;
  final String productDescription;
  final String productId;
  final String quantity;

  PembayaranPage({
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productDescription,
    required this.productId,
    required this.quantity,
  }) : super();

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final TextEditingController _quantityController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String total = '0';
  bool uploaded = false;

  // Data user dummy (tidak dari database)
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

  void setQuantity() {
    _quantityController..text = widget.quantity;
  }

  void calculateTotal() {
    String cleanedPrice = widget.productPrice.replaceAll(RegExp(r'[^0-9]'), '');
    int price = int.parse(cleanedPrice);
    int qty = int.parse(widget.quantity);

    int totalPrice = price * qty;
    total = totalPrice.toString();
  }

  // Fungsi format harga
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  @override
  void initState() {
    super.initState();
    setQuantity();
    calculateTotal();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    var uploadedText = Text("");
    if (uploaded) {
      uploadedText = Text(
        "Uploaded ",
        style: TextStyle(
          fontSize: 16,
          color: const Color.fromARGB(255, 19, 42, 166),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran"),
        backgroundColor: Color.fromARGB(255, 252, 252, 255),
        foregroundColor: Color.fromARGB(255, 19, 42, 166),
        toolbarHeight: 80,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 246, 246, 255),
                    Color.fromARGB(255, 246, 246, 255),
                  ],
                  stops: [0, 1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bagian Pesanan
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pesanan",
                                style: TextStyle(
                                  color: Color.fromARGB(200, 19, 42, 166),
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: screenWidth - 106,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          widget.productImage,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.error,
                                                  size: 50,
                                                  color: Colors.red,
                                                );
                                              },
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          widget.productName,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(widget.productPrice),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text("Jumlah"),
                                        SizedBox(
                                          width: 50,
                                          height: 30,
                                          child: TextField(
                                            enabled: false,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                255,
                                                90,
                                                90,
                                                90,
                                              ),
                                              fontSize: 16,
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters:
                                                <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                            controller: _quantityController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: const Color.fromARGB(
                                                    255,
                                                    31,
                                                    31,
                                                    31,
                                                  ),
                                                ),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Bagian Total
                  Container(
                    color: Colors.white,
                    width: screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                              color: Color.fromARGB(200, 19, 42, 166),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            formatCurrency(total),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Info Transfer
                  Container(
                    width: screenWidth,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mohon cantumkan email anda pada pesan transfer.",
                          ),
                          SizedBox(height: 8),
                          Text(
                            "BCA\nXXXXXXXXXX\nA.N ZONA ELEKTRONIK",
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _pickImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    240,
                                    240,
                                    240,
                                  ),
                                  foregroundColor: Color.fromARGB(
                                    255,
                                    39,
                                    39,
                                    39,
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Upload Bukti Transfer',
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                              uploadedText,
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Info tambahan
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Pastikan semua data sudah benar sebelum melakukan pembayaran. "
                      "Apabila ada kekeliruan pada nominal transfer, jumlah seluruhnya "
                      "akan dikembalikan ke rekening Anda setelah pesanan melewati review.",
                    ),
                  ),

                  SizedBox(height: 20),

                  // Tombol Buat Pesanan
                  SizedBox(
                    width: screenWidth - 80,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Pesanan berhasil dibuat (UI Only)"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Text('Buat Pesanan'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 36),
                        backgroundColor: Color.fromARGB(255, 4, 28, 162),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
