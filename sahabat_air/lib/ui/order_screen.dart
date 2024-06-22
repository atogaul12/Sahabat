import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 97, 206),
        title: Text('Pemesanan'),
      ),
      body: Center(
        child: Text('Konten Pemesanan'),
      ),
    );
  }
}
