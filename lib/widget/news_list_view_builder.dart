import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/services/news_services.dart';
import 'package:news_app/widget/news_title.dart';

class NewsListViewBuilder extends StatefulWidget {
  const NewsListViewBuilder({
    super.key,
    required this.category,
    this.searchQuery = '',
  });

  final String category;
  final String searchQuery;

  @override
  State<NewsListViewBuilder> createState() => _NewsListViewBuilderState();
}

class _NewsListViewBuilderState extends State<NewsListViewBuilder> {
  late Future<List<ArticleModel>> articles;

  @override
  void initState() {
    super.initState();
    articles = NewsServices(
      Dio(),
    ).getNews(category: widget.category, query: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant NewsListViewBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category ||
        oldWidget.searchQuery != widget.searchQuery) {
      articles = NewsServices(
        Dio(),
      ).getNews(category: widget.category, query: widget.searchQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleModel>>(
      future: articles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const SliverFillRemaining(
            child: Center(child: Text('Failed to load articles')),
          );
        }

        final articlesList = snapshot.data ?? [];
        if (articlesList.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                widget.searchQuery.isEmpty
                    ? 'No articles found'
                    : 'No results for "${widget.searchQuery}"',
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return NewsTitle(article: articlesList[index]);
          }, childCount: articlesList.length),
        );
      },
    );
  }
}
