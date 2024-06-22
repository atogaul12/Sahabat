import 'package:flutter/material.dart';
import 'package:sahabat_air/ui/account_screen.dart';
import 'package:sahabat_air/ui/history_screen.dart';
import 'package:sahabat_air/ui/home_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedIndex = 1; // Index for OrderScreen is 1

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 97, 206),
        title: Text('Pemesanan'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Halaman Pemesanan'),
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
