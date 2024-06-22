import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 97, 206),
        title: Text('Riwayat'),
      ),
      body: Center(
        child: Text('Konten Riwayat'),
      ),
    );
  }
}
