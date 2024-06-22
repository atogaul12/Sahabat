import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 97, 206),
        title: Text('Berita Manfaat Air'),
      ),
      body: Center(
        child: Text('Konten Berita'),
      ),
    );
  }
}
