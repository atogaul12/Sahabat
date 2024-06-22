import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sahabat_air/ui/news_screen.dart';
import 'package:sahabat_air/ui/promo_screen.dart';
import 'package:sahabat_air/ui/order_screen.dart';
import 'package:sahabat_air/ui/history_screen.dart';
import 'package:sahabat_air/ui/account_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user != null ? user.displayName ?? "Pengguna" : "Pengguna";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 97, 206),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png', // Path to the logo image
              height: 40,
            ),
            SizedBox(width: 10),
            Text('Sahabat Air'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Halo $userName,\nApakah anda kemarau hari ini?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 97, 206),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(
                'assets/banner_galon.png', // Path to the gallon image
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Manfaat Air',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 97, 206),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: ListTile(
                    title: Text('Berita 1'),
                    subtitle: Text('Manfaat air untuk kesehatan tubuh.'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                ),
              ),
            ),
            // Add more news items similarly
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Promo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 97, 206),
                ),
              ),
            ),
            Container(
              height: 120,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Image.asset(
                    'assets/promo1.png', // Path to promo image 1
                    fit: BoxFit.cover,
                    width: 120,
                  ),
                  SizedBox(width: 10),
                  Image.asset(
                    'assets/promo2.png', // Path to promo image 2
                    fit: BoxFit.cover,
                    width: 120,
                  ),
                  // Add more promo images similarly
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(255, 34, 97, 206),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pemesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Akun',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}
