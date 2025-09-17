import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'pembayaran.dart';
import 'dashboard_page.dart';

class KeranjangPage extends StatefulWidget {
  @override
  _KeranjangPageState createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  // Dummy data keranjang
  List<Map<String, dynamic>> cartItems = []; // awalnya kosong

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  // Fungsi untuk ambil keranjang dari SharedPreferences
  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];

    setState(() {
      cartItems = cart
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    });
  }

  // Fungsi format harga
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  // Hitung total belanja
  int getTotalHarga() {
    int total = 0;
    for (var item in cartItems) {
      final int price = int.parse(item['price']);
      final int qty = (item['quantity'] as num).toInt();
      total += price * qty;
    }
    return total;
  }

  // Hapus item
  Future<void> removeItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cartItems.removeAt(index);
      prefs.setStringList(
        'cart',
        cartItems.map((item) => jsonEncode(item)).toList(),
      );
    });
  }

  // Tambah jumlah
  Future<void> incrementQty(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cartItems[index]['quantity']++;
      prefs.setStringList(
        'cart',
        cartItems.map((item) => jsonEncode(item)).toList(),
      );
    });
  }

  // Kurang jumlah
  Future<void> decrementQty(int index) async {
    final prefs = await SharedPreferences.getInstance();
    if (cartItems[index]['quantity'] > 1) {
      setState(() {
        cartItems[index]['quantity']--;
        prefs.setStringList(
          'cart',
          cartItems.map((item) => jsonEncode(item)).toList(),
        );
      });
    }
  }

  // Checkout
  void checkout() {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Keranjang kosong")));
      return;
    }

    final firstItem = cartItems.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PembayaranPage(
          productName: firstItem['product'],
          productPrice: firstItem['price'],
          productImage: firstItem['image'],
          productDescription: firstItem['description'],
          productId: firstItem['idproduct'],
          quantity: firstItem['quantity'].toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalHarga = getTotalHarga();

    return Scaffold(
      appBar: AppBar(
        title: Text("Keranjang Belanja"),
        backgroundColor: Color.fromARGB(255, 252, 252, 255),
        foregroundColor: Color.fromARGB(255, 19, 166, 42),
        toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? Center(child: Text("Keranjang kosong"))
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Image.network(
                            item['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.red,
                              );
                            },
                          ),
                          title: Text(item['product']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(formatCurrency(item['price'])),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline),
                                    onPressed: () => decrementQty(index),
                                  ),
                                  Text(item['quantity'].toString()),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline),
                                    onPressed: () => incrementQty(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeItem(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ${formatCurrency(totalHarga.toString())}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 19, 166, 42),
                  ),
                ),
                ElevatedButton(
                  onPressed: checkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 19, 166, 42),
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Checkout"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
