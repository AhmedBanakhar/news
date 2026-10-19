import 'package:dio/dio.dart';
import 'package:news_app/model/article_model.dart';

abstract interface class NewsRemoteDataSource {
  Future<List<ArticleModel>> getNews({required String category, String? query});
}

class NewsServices implements NewsRemoteDataSource {
  final Dio dio;
  NewsServices(this.dio);

  @override
  Future<List<ArticleModel>> getNews({
    required String category,
    String? query,
  }) async {
    final queryParameters = {
      'apiKey': '93ca029262b94195a895693953801e5c',
      'country': 'us',
      'category': category.trim().toLowerCase(),
      if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
    };

    final response = await dio.get(
      'https://newsapi.org/v2/top-headlines',
      queryParameters: queryParameters,
    );

    final jsonData = response.data as Map<String, dynamic>;
    final articles = jsonData['articles'] as List<dynamic>;
    return articles
        .map(
          (article) =>
              ArticleModel.fromJson(Map<String, dynamic>.from(article as Map)),
        )
        .toList();
  }
}
