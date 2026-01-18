class Credit {
  final String author;
  final String url;
  final String asset;
  final String type;

  Credit({
    required this.author,
    required this.url,
    required this.asset,
    required this.type,
  });

  factory Credit.fromJson(Map<String, dynamic> json) {
    return Credit(
      author: json['author'] as String? ?? '',
      url: json['url'] as String? ?? '',
      asset: json['asset'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }
}
