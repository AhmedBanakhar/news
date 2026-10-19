import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/services/news_services.dart';
import 'package:news_app/services/sqflite_news_cache.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  const article = ArticleModel(
    title: 'Saved headline',
    description: 'Saved description',
    urlToImage: 'https://example.com/image.jpg',
  );

  test('fetches fresh news and saves it to the cache', () async {
    final cache = _MemoryNewsCache();
    final repository = CachedNewsRepository(
      remoteDataSource: _FakeRemoteDataSource(const [article]),
      cache: cache,
    );

    final articles = await repository.getNews(category: 'Business');

    expect(articles, const [article]);
    expect(cache.savedArticles, const [article]);
    expect(cache.savedCategory, 'business');
  });

  test('returns cached news when the remote source is offline', () async {
    final cache = _MemoryNewsCache()..cachedArticles = const [article];
    final repository = CachedNewsRepository(
      remoteDataSource: _FakeRemoteDataSource.failure(),
      cache: cache,
    );

    final articles = await repository.getNews(category: 'business');

    expect(articles, const [article]);
  });

  test('rethrows the network error when no cached news exists', () async {
    final repository = CachedNewsRepository(
      remoteDataSource: _FakeRemoteDataSource.failure(),
      cache: _MemoryNewsCache(),
    );

    await expectLater(
      repository.getNews(category: 'business'),
      throwsA(isA<DioException>()),
    );
  });

  group('SqfliteNewsCache', () {
    late SqfliteNewsCache newsCache;

    setUp(() async {
      sqfliteFfiInit();
      newsCache = await SqfliteNewsCache.open(
        databaseFactory: databaseFactoryFfi,
        path: inMemoryDatabasePath,
      );
    });

    tearDown(() async {
      await newsCache.close();
    });

    test('persists and restores article data', () async {
      await newsCache.saveNews(
        category: 'business',
        query: 'markets',
        articles: const [article],
      );
      final restored = await newsCache.readNews(
        category: 'business',
        query: 'markets',
      );

      expect(restored, hasLength(1));
      expect(restored?.single.title, article.title);
      expect(restored?.single.description, article.description);
      expect(restored?.single.urlToImage, article.urlToImage);
    });

    test('returns an empty list for a cached empty result', () async {
      await newsCache.saveNews(category: 'business', articles: const []);

      expect(await newsCache.readNews(category: 'business'), isEmpty);
      expect(await newsCache.readNews(category: 'science'), isNull);
    });

    test('keeps results separate by category and query', () async {
      await newsCache.saveNews(
        category: 'business',
        query: 'markets',
        articles: const [article],
      );

      expect(
        await newsCache.readNews(category: 'business', query: 'economy'),
        isNull,
      );
      expect(
        await newsCache.readNews(category: 'science', query: 'markets'),
        isNull,
      );
    });
  });
}

class _FakeRemoteDataSource implements NewsRemoteDataSource {
  _FakeRemoteDataSource(this.articles) : _error = null;

  _FakeRemoteDataSource.failure()
    : articles = const [],
      _error = DioException(requestOptions: RequestOptions());

  final List<ArticleModel> articles;
  final DioException? _error;

  @override
  Future<List<ArticleModel>> getNews({
    required String category,
    String? query,
  }) async {
    if (_error != null) {
      throw _error;
    }
    return articles;
  }
}

class _MemoryNewsCache implements NewsCache {
  List<ArticleModel>? cachedArticles;
  List<ArticleModel>? savedArticles;
  String? savedCategory;

  @override
  Future<List<ArticleModel>?> readNews({
    required String category,
    String? query,
  }) async => cachedArticles;

  @override
  Future<void> saveNews({
    required String category,
    String? query,
    required List<ArticleModel> articles,
  }) async {
    savedCategory = category;
    savedArticles = articles;
  }
}
