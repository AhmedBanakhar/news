import 'package:flutter/material.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/widget/news_list_view_builder.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({
    super.key,
    required this.category,
    required this.repository,
  });

  final String category;
  final NewsRepository repository;

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final GlobalKey<NewsListViewBuilderState> _newsListKey =
      GlobalKey<NewsListViewBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            letterSpacing: 1.3,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            _newsListKey.currentState?.refresh() ?? Future<void>.value(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC58A4A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'A considered selection of ${widget.category.toLowerCase()} stories.',
                        style: const TextStyle(
                          color: Color(0xFF70756F),
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NewsListViewBuilder(
              key: _newsListKey,
              category: widget.category,
              repository: widget.repository,
            ),
          ],
        ),
      ),
    );
  }
}
