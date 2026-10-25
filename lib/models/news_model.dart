import 'dart:convert';

class NewsModel {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String category;
  final DateTime publishedDate;
  final String author;
  final String source;
  final String? url;
  final String? imageUrl;
  final bool isUrgent;

  NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.publishedDate,
    required this.author,
    required this.source,
    this.url,
    this.imageUrl,
    this.isUrgent = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'category': category,
      'publishedDate': publishedDate.toIso8601String(),
      'author': author,
      'source': source,
      'url': url,
      'imageUrl': imageUrl,
      'isUrgent': isUrgent,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      summary: map['summary'] ?? map['description'] ?? '',
      content: map['content'] ?? map['body'] ?? '',
      category: map['category'] ?? 'Campus Notice',
      publishedDate: DateTime.tryParse(map['publishedDate'] ?? map['publishedAt'] ?? '') ?? DateTime.now(),
      author: map['author'] ?? 'Office of Student Affairs',
      source: map['source'] is Map ? (map['source']['name'] ?? 'Campus News') : (map['source']?.toString() ?? 'Campus News'),
      url: map['url'],
      imageUrl: map['imageUrl'] ?? map['urlToImage'],
      isUrgent: map['isUrgent'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());
  factory NewsModel.fromJson(String source) => NewsModel.fromMap(json.decode(source));
}
