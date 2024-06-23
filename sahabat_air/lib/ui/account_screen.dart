import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sahabat_air/ui/history_screen.dart';
import 'package:sahabat_air/ui/home_screen.dart';
import 'package:sahabat_air/ui/order_screen.dart';
import 'package:sahabat_air/ui/profile_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 3; // Index for AccountScreen is 3
  String userName = "Pengguna";
  String userEmail = "email@contoh.com";
  String userPhone = "No Telepon";
  String userAddress = "Alamat";

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushReplacement(
              context, noAnimationPageRoute(const HomeScreen()));
          break;
        case 1:
          Navigator.pushReplacement(
              context, noAnimationPageRoute(const OrderScreen()));
          break;
        case 2:
          Navigator.pushReplacement(
              context, noAnimationPageRoute(const HistoryScreen()));
          break;
        case 3:
          Navigator.pushReplacement(
              context, noAnimationPageRoute(const AccountScreen()));
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          userName = data?['name'] ?? "Pengguna";
          userEmail = data?['email'] ?? "email@contoh.com";
          userPhone = data?['phone'] ?? "No Telepon";
          userAddress = data?['address'] ?? "Alamat";
        });
      }
    }
  }

  void _updateUserName(String name) {
    setState(() {
      userName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userPhotoUrl = const AssetImage('assets/default_profile.png');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 97, 206),
        title: Center(
          child: Text(
            'Akun',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/default_profile.png'),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 34, 97, 206),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            userEmail,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 1),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profil Saya'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(onNameChanged: _updateUserName),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Keamanan'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Aksi untuk membuka halaman keamanan
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notifikasi'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Aksi untuk membuka halaman notifikasi
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Bantuan'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Aksi untuk membuka halaman bantuan
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', (Route<dynamic> route) => false);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Keluar'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
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
        onTap: _onItemTapped,
      ),
    );
  }
}

PageRouteBuilder noAnimationPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
