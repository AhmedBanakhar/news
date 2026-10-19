class ArticleModel {
  final String? title;
  final String? description;
  final String? urlToImage;

  const ArticleModel({
    required this.title,
    required this.description,
    required this.urlToImage,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      urlToImage: json['urlToImage'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
    };
  }
}
