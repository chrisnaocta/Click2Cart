import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pembayaran.dart';

class KeranjangPage extends StatefulWidget {
  @override
  _KeranjangPageState createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  // Dummy data keranjang
  List<Map<String, dynamic>> cartItems = [
    {
      "idproduct": "1",
      "product": "Apel Merah",
      "price": "25000",
      "image":
          "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=500",
      "description": "Apel merah segar dengan rasa manis alami.",
      "quantity": 2,
    },
    {
      "idproduct": "2",
      "product": "Pisang Cavendish",
      "price": "20000",
      "image":
          "https://images.unsplash.com/photo-1574226516831-e1dff420e43e?w=500",
      "description": "Pisang cavendish manis, cocok untuk camilan sehat.",
      "quantity": 1,
    },
    {
      "idproduct": "3",
      "product": "Jeruk Manis",
      "price": "30000",
      "image":
          "https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5e?w=500",
      "description": "Jeruk manis segar kaya vitamin C.",
      "quantity": 3,
    },
    {
      "idproduct": "4",
      "product": "Anggur Hijau",
      "price": "45000",
      "image":
          "https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=500",
      "description": "Anggur hijau segar, manis sedikit asam.",
      "quantity": 1,
    },
    {
      "idproduct": "5",
      "product": "Mangga Harum Manis",
      "price": "35000",
      "image":
          "https://images.unsplash.com/photo-1605026113576-1384e4a65a14?w=500",
      "description":
          "Mangga harum manis segar, cocok untuk jus atau dimakan langsung.",
      "quantity": 2,
    },
  ];

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
      final int qty = (item['quantity'] as num)
          .toInt(); // aman untuk int/double/num
      total += price * qty;
    }
    return total;
  }

  // Fungsi hapus item dari keranjang
  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  // Fungsi tambah jumlah
  void incrementQty(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  // Fungsi kurang jumlah
  void decrementQty(int index) {
    if (cartItems[index]['quantity'] > 1) {
      setState(() {
        cartItems[index]['quantity']--;
      });
    }
  }

  // Fungsi checkout
  void checkout() {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Keranjang kosong")));
      return;
    }

    // Untuk demo → arahkan ke pembayaran dengan item pertama
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
        foregroundColor: Color.fromARGB(255, 19, 42, 166),
        toolbarHeight: 80,
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
                    color: Color.fromARGB(255, 19, 42, 166),
                  ),
                ),
                ElevatedButton(
                  onPressed: checkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 19, 42, 166),
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
