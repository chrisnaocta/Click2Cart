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
  List<Map<String, dynamic>> cartItems = [];
  List<bool> selectedItems = []; // ✅ untuk ceklist per item
  bool selectAll = false; // ✅ untuk ceklist semua item

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
      selectedItems = List.filled(
        cartItems.length,
        false,
      ); // default semua false
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
    for (int i = 0; i < cartItems.length; i++) {
      if (selectedItems[i]) {
        final int price = int.parse(cartItems[i]['price']);
        final int qty = (cartItems[i]['quantity'] as num).toInt();
        total += price * qty;
      }
    }
    return total;
  }

  // Hapus item
  Future<void> removeItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cartItems.removeAt(index);
      selectedItems.removeAt(index);
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
    List<Map<String, dynamic>> selected = cartItems
        .asMap()
        .entries
        .where((entry) {
          return selectedItems[entry.key];
        })
        .map((entry) => entry.value)
        .toList();

    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih minimal 1 item untuk checkout")),
      );
      return;
    }

    // kirim hanya item pertama (atau bisa dikirim list semua item, tergantung kebutuhan)
    final firstItem = selected.first;

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 50,
        centerTitle: true,
        scrolledUnderElevation: 0,

        // 🔥 Gradient sama seperti dashboard
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 144, 238, 144), // hijau muda
                Color.fromARGB(255, 34, 139, 34), // hijau segar
                Color.fromARGB(255, 0, 128, 128), // teal aksen
              ],
            ),
          ),
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          },
        ),

        title: const Text(
          "Keranjang Belanja",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // putih biar kontras
          ),
        ),
      ),

      body: Column(
        children: [
          // ✅ Checkbox Select All
          if (cartItems.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Checkbox(
                    value: selectAll,
                    activeColor: Colors.green, // ✅ warna kotak ketika dicentang
                    checkColor:
                        Colors.white, // ✅ warna tanda centang di dalam kotak
                    onChanged: (value) {
                      setState(() {
                        selectAll = value ?? false;
                        selectedItems = List.filled(
                          cartItems.length,
                          selectAll,
                        );
                      });
                    },
                  ),
                  Text("Pilih Semua"),
                ],
              ),
            ),

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
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ✅ Checkbox per item
                              Checkbox(
                                value: selectedItems[index],
                                activeColor: Colors
                                    .green, // ✅ warna kotak ketika dicentang
                                checkColor: Colors
                                    .white, // ✅ warna tanda centang di dalam kotak
                                onChanged: (value) {
                                  setState(() {
                                    selectedItems[index] = value ?? false;
                                    selectAll = selectedItems.every((e) => e);
                                  });
                                },
                              ),

                              Image.network(
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
                            ],
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

          // ✅ Footer total dan checkout
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
