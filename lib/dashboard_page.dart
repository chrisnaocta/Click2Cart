import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_kel_2_mobile_cloud_computing/keranjang.dart';
import 'keranjang.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Dummy data user
  String userName = 'John Doe';
  String userEmail = 'johndoe@email.com';
  String userProfilePhoto =
      'https://i.pinimg.com/236x/5a/80/db/5a80db6c20b3f6fad6bb1d6c2b713632.jpg'; // Foto profil default

  // Dummy data produk
  List<Map<String, dynamic>> products = [
    {
      "idproduct": "1",
      "product": "Laptop Gaming",
      "price": "15000000",
      "image":
          "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500",
      "description":
          "Laptop gaming dengan performa tinggi untuk kebutuhan multitasking dan bermain game.",
    },
    {
      "idproduct": "2",
      "product": "Smartphone",
      "price": "5000000",
      "image":
          "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500",
      "description":
          "Smartphone terbaru dengan kamera canggih dan baterai tahan lama.",
    },
    {
      "idproduct": "3",
      "product": "Headset",
      "price": "750000",
      "image":
          "https://images.unsplash.com/photo-1583225298304-336e8e6e9f3b?w=500",
      "description":
          "Headset berkualitas tinggi dengan suara jernih dan bass mantap.",
    },
    {
      "idproduct": "4",
      "product": "Keyboard Mechanical",
      "price": "1200000",
      "image":
          "https://images.unsplash.com/photo-1595225476474-8756399e25db?w=500",
      "description":
          "Keyboard mechanical dengan switch tactile dan backlight RGB.",
    },
    {
      "idproduct": "5",
      "product": "Smartwatch",
      "price": "2500000",
      "image":
          "https://images.unsplash.com/photo-1519744792095-2f2205e87b6f?w=500",
      "description":
          "Smartwatch modern untuk fitness tracking dan notifikasi real-time.",
    },
  ];

  // Fungsi format harga
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  // Function logout dummy
  void _logout() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Logout berhasil (dummy action)")));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: Text(
            "Click2Cart Dashboard",
            style: TextStyle(
              color: Color.fromARGB(255, 19, 42, 166),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 252, 252, 255),
        foregroundColor: Color.fromARGB(255, 19, 42, 166),
        toolbarHeight: 80,
        scrolledUnderElevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 19, 42, 166),
              ),
              accountName: Text(
                userName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                userEmail,
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(userProfilePhoto),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Keranjang'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => KeranjangPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Navigasi Settings (dummy)")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Stack(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                            child: Image.network(
                              product['image'],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.error,
                                  size: 100,
                                  color: Colors.red,
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['product'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                formatCurrency(product['price']),
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Beli ${product['product']} (dummy)",
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Beli'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 36),
                                  elevation: 0,
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    19,
                                    42,
                                    166,
                                  ),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
