import 'package:dio/dio.dart';
import 'package:news_app/model/article_model.dart';

class NewsServices {
  final Dio dio;
  NewsServices(this.dio);

  Future<List<ArticleModel>> getNews({
    required String category,
    String? query,
  }) async {
    try {
      final queryParameters = {
        'apiKey': '93ca029262b94195a895693953801e5c',
        'country': 'us',
        'category': category,
        if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
      };

      final response = await dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: queryParameters,
      );

      final Map<String, dynamic> jsonData = response.data;
      final List<dynamic> articles = jsonData['articles'];
      final List<ArticleModel> articlesList = [];
      for (var article in articles) {
        articlesList.add(ArticleModel.fromJson(article));
      }
      return articlesList;
    } catch (e) {
      return [];
    }
  }
}
