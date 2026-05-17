import 'package:flutter/material.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/widget/news_title.dart';

class NewsListView extends StatelessWidget {
  const NewsListView({super.key, required this.articles});
  final List<ArticleModel> articles;

  @override
  Widget build(BuildContext context) {
    return SliverList(delegate:   SliverChildBuilderDelegate(
      (context, index) {
        return NewsTitle(article: articles[index],);
      },
      childCount: articles.length,
    ));
  }
}