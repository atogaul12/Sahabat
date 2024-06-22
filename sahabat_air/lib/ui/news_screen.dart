import 'package:flutter/material.dart';
import 'news_detail_screen.dart';
import '../models/news_model.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsList = [
      News(
        title: 'Manfaat Air',
        content: 'Manfaat air untuk kesehatan tubuh sangat banyak...',
        date: '2023-06-23',
      ),
      // Tambahkan berita lainnya jika diperlukan
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 34, 97, 206),
        title: Text('Berita Manfaat Air'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: newsList.length,
          itemBuilder: (context, index) {
            final news = newsList[index];
            return Card(
              child: ListTile(
                title: Text(news.title),
                subtitle: Text(news.content.substring(0, 30) + '...'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/news_detail',
                    arguments: news,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
