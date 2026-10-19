import 'package:dio/dio.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/services/news_services.dart';

abstract interface class NewsRepository {
  Future<List<ArticleModel>> getNews({
    required String category,
    String? query,
  });
}

abstract interface class NewsCache {
  Future<List<ArticleModel>?> readNews({
    required String category,
    String? query,
  });

  Future<void> saveNews({
    required String category,
    String? query,
    required List<ArticleModel> articles,
  });
}

class CachedNewsRepository implements NewsRepository {
  const CachedNewsRepository({
    required NewsRemoteDataSource remoteDataSource,
    required NewsCache cache,
  }) : _remoteDataSource = remoteDataSource,
       _cache = cache;

  final NewsRemoteDataSource _remoteDataSource;
  final NewsCache _cache;

  @override
  Future<List<ArticleModel>> getNews({
    required String category,
    String? query,
  }) async {
    final normalizedCategory = category.trim().toLowerCase();
    final normalizedQuery = query?.trim();

    try {
      final articles = await _remoteDataSource.getNews(
        category: normalizedCategory,
        query: normalizedQuery,
      );
      await _cache.saveNews(
        category: normalizedCategory,
        query: normalizedQuery,
        articles: articles,
      );
      return articles;
    } on DioException {
      final cachedArticles = await _cache.readNews(
        category: normalizedCategory,
        query: normalizedQuery,
      );
      if (cachedArticles != null) {
        return cachedArticles;
      }
      rethrow;
    }
  }
}
