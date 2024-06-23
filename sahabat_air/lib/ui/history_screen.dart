import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:sahabat_air/ui/order_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedIndex = 2; // Index for HistoryScreen is 2

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/order');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/history');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/account');
          break;
      }
    }
  }

  Future<List<DocumentSnapshot>> _fetchOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .orderBy('orderDate', descending: true)
          .get();
      return querySnapshot.docs;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 97, 206),
        title: Center(
          child: Text(
            'Riwayat Pesanan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada riwayat pesanan.'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;
              final orderDateTimestamp = order['orderDate'] as Timestamp?;
              final orderDate = orderDateTimestamp != null
                  ? orderDateTimestamp.toDate()
                  : null;
              final totalPrice = order['totalPrice'] ?? 0;
              final status = order['status'] ?? 'Tidak diketahui';

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    'Order ID: $orderId',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 34, 97, 206),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (orderDate != null)
                        Text(
                          'Tanggal: ${DateFormat('dd MMMM yyyy, HH:mm').format(orderDate)}',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      Text(
                        'Total Harga: Rp $totalPrice',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'Status: $status',
                        style: TextStyle(
                          color: status == 'Belum Dibayar'
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderDetailScreen(orderId: orderId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
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
