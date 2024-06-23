import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sahabat_air/ui/order_screen.dart';
import 'package:sahabat_air/ui/history_screen.dart';
import 'package:sahabat_air/ui/account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String userName = "Pengguna";
  bool isLoading = true; // Variable to track loading state

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
    _loadUserName();
  }

  void _loadUserName() async {
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
          isLoading = false; // Stop loading
        });
      } else {
        setState(() {
          userName = "Pengguna";
          isLoading = false; // Stop loading
        });
      }
    } else {
      setState(() {
        userName = "Pengguna";
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 97, 206),
        title: Center(
          child: Image.asset(
            'assets/logo.png', // Path to the logo image
            height: 40,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo $userName,',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 34, 97, 206),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/banner_galon.png', // Path to the gallon image
                              height: 120,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'Apakah anda kemarau hari ini?\n\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 34, 97, 206),
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'Jaga kesehatan dengan selalu terhidrasi. ',
                                    ),
                                    TextSpan(
                                      text: 'Minum air yang cukup setiap hari ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'untuk mendukung aktivitasmu.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 10, child: Container(color: Colors.grey[200])),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Layanan Kami',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 34, 97, 206),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.local_drink,
                              color: Color.fromARGB(255, 34, 97, 206)),
                          title: Text('Isi Ulang Galon'),
                          subtitle: Text(
                              'Kami menyediakan layanan isi ulang galon dengan air berkualitas.'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.delivery_dining,
                              color: Color.fromARGB(255, 34, 97, 206)),
                          title: Text('Layanan Pengantaran'),
                          subtitle: Text(
                              'Kami menyediakan layanan pengantaran cepat dan aman sampai ke tempat Anda.'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 10, child: Container(color: Colors.grey[200])),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manfaat Air',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 34, 97, 206),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.local_drink,
                                color: Color.fromARGB(255, 34, 97, 206)),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Air membantu menjaga keseimbangan cairan dalam tubuh.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.fitness_center,
                                color: Color.fromARGB(255, 34, 97, 206)),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Air membantu mengontrol kalori tubuh.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.healing,
                                color: Color.fromARGB(255, 34, 97, 206)),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Air membantu menjaga fungsi ginjal.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 10, child: Container(color: Colors.grey[200])),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Promo',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 34, 97, 206),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 190,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 300,
                                margin: EdgeInsets.only(right: 10),
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(4),
                                          ),
                                          child: Image.asset(
                                            'assets/promo${index + 1}.png', // Path to promo images
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          index == 0
                                              ? 'Diskon 50%'
                                              : 'Beli 10x Gratis 1',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 34, 97, 206),
                                          ),
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
                  ),
                ],
              ),
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
