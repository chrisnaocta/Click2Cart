import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'keranjang.dart';
import 'login.dart';
import 'productdetail_page.dart';

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
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2x775CuxaRE8mfmBhucwBsBMAdQ5B5Fr3Bw&s",
      "description": "Pisang cavendish manis, cocok untuk camilan sehat.",
      "quantity": 1,
    },
    {
      "idproduct": "3",
      "product": "Jeruk Bali",
      "price": "30000",
      "image":
          "https://www.lapakbuah.com/wp-content/uploads/2021/07/Jeruk-pamelo.jpg",
      "description": "Jeruk manis segar kaya vitamin C.",
      "quantity": 3,
    },
    {
      "idproduct": "4",
      "product": "Anggur Hijau",
      "price": "45000",
      "image":
          "https://res.cloudinary.com/dk0z4ums3/image/upload/v1695030331/attached_image/6-manfaat-anggur-hijau-untuk-kesehatan.jpg",
      "description": "Anggur hijau segar, manis sedikit asam.",
      "quantity": 1,
    },
    {
      "idproduct": "5",
      "product": "Mangga Harum Manis",
      "price": "35000",
      "image":
          "https://www.tanamanmart.com/wp-content/uploads/2017/02/harum-manis-1.jpg",
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

  // Function logout dummy
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Hapus semua data session
    // await prefs.clear();

    // Hanya mau hapus flag login:
    await prefs.remove('isLogin');

    // Cek ulang nilai isLogin setelah diset
    bool? status = prefs.getBool('isLogin');
    print("DEBUG: isLogin diset jadi $status"); // tampil di terminal

    // Tampilkan snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Logout berhasil")));

    // Arahkan ke LoginPage
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
        backgroundColor: const Color.fromARGB(255, 252, 252, 255),
        foregroundColor: Colors.black,
        toolbarHeight: 60,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            // Logo di kiri
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                'assets/images/logo.png',
                width: 50,
                height: 50,
              ),
            ),
            // Expanded agar teks pas di tengah
            Expanded(
              child: Center(
                child: Text(
                  "Dashboard",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 180, 210, 52),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Color.fromARGB(255, 180, 210, 52),
            ),
            onPressed: _logout,
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(
                  255, // Alpha (0 = transparan, 255 = solid)
                  180, // Red
                  210, // Greenr
                  52, // Blue
                ),
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
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailPage(
                                        productName: product['product'],
                                        productPrice: product['price'],
                                        productImage: product['image'],
                                        productDescription:
                                            product['description'],
                                        productId: product['idproduct'],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Beli'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 36),
                                  elevation: 0,
                                  backgroundColor: const Color.fromARGB(
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
