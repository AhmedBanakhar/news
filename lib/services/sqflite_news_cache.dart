import 'package:news_app/model/article_model.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteNewsCache implements NewsCache {
  const SqfliteNewsCache(this._database);

  final Database _database;

  Future<void> close() => _database.close();

  static Future<SqfliteNewsCache> open({
    required DatabaseFactory databaseFactory,
    required String path,
  }) async {
    final database = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (database, version) async {
          await database.execute('''
            CREATE TABLE cached_news_queries (
              category TEXT NOT NULL,
              query TEXT NOT NULL,
              PRIMARY KEY (category, query)
            )
          ''');
          await database.execute('''
            CREATE TABLE cached_news_articles (
              category TEXT NOT NULL,
              query TEXT NOT NULL,
              position INTEGER NOT NULL,
              title TEXT,
              description TEXT,
              url_to_image TEXT,
              PRIMARY KEY (category, query, position)
            )
          ''');
        },
      ),
    );
    return SqfliteNewsCache(database);
  }

  @override
  Future<List<ArticleModel>?> readNews({
    required String category,
    String? query,
  }) async {
    final normalizedCategory = _normalizeCategory(category);
    final normalizedQuery = _normalizeQuery(query);
    final cachedQuery = await _database.query(
      'cached_news_queries',
      columns: const ['category'],
      where: 'category = ? AND query = ?',
      whereArgs: [normalizedCategory, normalizedQuery],
      limit: 1,
    );
    if (cachedQuery.isEmpty) {
      return null;
    }

    final rows = await _database.query(
      'cached_news_articles',
      where: 'category = ? AND query = ?',
      whereArgs: [normalizedCategory, normalizedQuery],
      orderBy: 'position',
    );
    return rows
        .map(
          (row) => ArticleModel(
            title: row['title'] as String?,
            description: row['description'] as String?,
            urlToImage: row['url_to_image'] as String?,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveNews({
    required String category,
    String? query,
    required List<ArticleModel> articles,
  }) async {
    final normalizedCategory = _normalizeCategory(category);
    final normalizedQuery = _normalizeQuery(query);

    await _database.transaction((transaction) async {
      await transaction.insert('cached_news_queries', {
        'category': normalizedCategory,
        'query': normalizedQuery,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      await transaction.delete(
        'cached_news_articles',
        where: 'category = ? AND query = ?',
        whereArgs: [normalizedCategory, normalizedQuery],
      );

      final batch = transaction.batch();
      for (var index = 0; index < articles.length; index++) {
        final article = articles[index];
        batch.insert('cached_news_articles', {
          'category': normalizedCategory,
          'query': normalizedQuery,
          'position': index,
          'title': article.title,
          'description': article.description,
          'url_to_image': article.urlToImage,
        });
      }
      await batch.commit(noResult: true);
    });
  }

  String _normalizeCategory(String category) => category.trim().toLowerCase();

  String _normalizeQuery(String? query) => query?.trim() ?? '';
}
