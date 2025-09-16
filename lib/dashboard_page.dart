import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> products = [
    {"name": "Apel", "price": 25000, "icon": Icons.local_grocery_store},
    {"name": "Pisang", "price": 18000, "icon": Icons.local_grocery_store},
    {"name": "Jeruk", "price": 22000, "icon": Icons.local_grocery_store},
    {"name": "Semangka", "price": 35000, "icon": Icons.local_grocery_store},
    {"name": "Anggur", "price": 45000, "icon": Icons.local_grocery_store},
  ];

  String userName = "User";
  String userEmail = "user@click2cart.com";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("userName") ?? "User";
      userEmail = prefs.getString("userEmail") ?? "user@click2cart.com";
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogin", false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Click2Cart Dashboard"),
        backgroundColor: const Color.fromARGB(255, 19, 42, 166),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(userEmail),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  userName.isNotEmpty ? userName[0] : "U",
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 19, 42, 166),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Dashboard"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              leading:
                  Icon(product["icon"], size: 36, color: Colors.blueAccent),
              title: Text(product["name"],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Rp ${product["price"]}"),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("${product["name"]} ditambahkan ke keranjang."),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Tambah"),
              ),
            ),
          );
        },
      ),
    );
  }
}
