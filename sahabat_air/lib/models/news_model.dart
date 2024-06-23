class News {
  final String title;
  final String content;
  final String date;

  News({required this.title, required this.content, required this.date});

  // Method to convert Firestore document to News object
  factory News.fromFirestore(Map<String, dynamic> data) {
    return News(
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      date: data['date'] ?? '',
    );
  }

  // Method to convert News object to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'date': date,
    };
  }
}
