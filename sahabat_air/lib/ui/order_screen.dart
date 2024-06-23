import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahabat_air/ui/account_screen.dart';
import 'package:sahabat_air/ui/history_screen.dart';
import 'package:sahabat_air/ui/home_screen.dart';
import 'package:sahabat_air/ui/order_detail_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedIndex = 1; // Index for OrderScreen is 1
  int _quantity = 1;
  String _name = "Nama belum diisi";
  String _address = "Alamat belum diisi";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        setState(() {
          _name = userData['name'] ?? "Nama belum diisi";
          _address = userData['address'] ?? "Alamat belum diisi";
        });
      }
    }
  }

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

  void _placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (_quantity > 0 && _name != "" && _address != "") {
        final orderId =
            FirebaseFirestore.instance.collection('orders').doc().id;
        await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
          'orderId': orderId,
          'userId': user.uid,
          'quantity': _quantity,
          'totalPrice': 10000 * _quantity,
          'status': 'Belum Dibayar',
          'orderDate': Timestamp.now(),
        });

        Navigator.pushReplacement(
          context,
          noAnimationPageRoute(OrderDetailScreen(orderId: orderId)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lengkapi data sebelum memesan.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Anda harus login terlebih dahulu.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 97, 206),
        title: Center(
          child: Text(
            'Pemesanan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              color: Color(0xFFf2f2f2), // Light grey background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama Penerima:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _name,
                      style: TextStyle(
                        fontSize: 14,
                        color: _name == "Nama belum diisi"
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Alamat Pengantaran:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _address,
                      style: TextStyle(
                        fontSize: 14,
                        color: _address == "Alamat belum diisi"
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Anda dapat mengubah nama penerima dan alamat pengantaran di halaman akun.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              color: Color(0xFFf2f2f2), // Light grey background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Produk: Isi Ulang Galon',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Harga: Rp 10000',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (_quantity > 1) _quantity--;
                                });
                              },
                            ),
                            Text(
                              '$_quantity',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                        Text(
                          'Total: Rp ${10000 * _quantity}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 34, 97, 206),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Pesan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
