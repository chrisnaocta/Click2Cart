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
        backgroundColor: Colors.transparent,
        elevation: 0, // biar rapi
        toolbarHeight: 50,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,

        // 🔥 Gradient background
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 180, 210, 52), // hijau muda
                Color.fromARGB(255, 19, 166, 42), // hijau segar
                Color.fromARGB(255, 0, 100, 0), // hijau gelap
              ],
            ),
          ),
        ),

        leading: SizedBox(
          width: 90,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ],
          ),
        ),

        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // teks putih agar kontras
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),

      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 144, 238, 144), // hijau muda
                Color.fromARGB(255, 34, 139, 34), // hijau segar
                Color.fromARGB(255, 0, 128, 128), // teal
              ],
            ),
          ),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.transparent, // biar ikut gradient parent
                ),
                accountName: Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  userEmail,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(userProfilePhoto),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart, color: Colors.white),
                title: const Text(
                  'Keranjang',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => KeranjangPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: _logout,
              ),
            ],
          ),
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
                                    166,
                                    42,
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
