import 'package:flutter/material.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/widget/news_title.dart';

class NewsListViewBuilder extends StatefulWidget {
  const NewsListViewBuilder({
    super.key,
    required this.category,
    required this.repository,
    this.searchQuery = '',
  });

  final String category;
  final NewsRepository repository;
  final String searchQuery;

  @override
  NewsListViewBuilderState createState() => NewsListViewBuilderState();
}

class NewsListViewBuilderState extends State<NewsListViewBuilder> {
  late Future<List<ArticleModel>> articles;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  @override
  void didUpdateWidget(covariant NewsListViewBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category ||
        oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.repository != widget.repository) {
      _loadArticles();
    }
  }

  void _loadArticles() {
    articles = widget.repository.getNews(
      category: widget.category,
      query: widget.searchQuery,
    );
  }

  Future<void> refresh() {
    final request = widget.repository.getNews(
      category: widget.category,
      query: widget.searchQuery,
    );
    setState(() {
      articles = request;
    });
    return request.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleModel>>(
      future: articles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(child: _NewsLoadingSkeleton());
        }

        if (snapshot.hasError) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: _NewsMessage(
              icon: Icons.wifi_off_rounded,
              title: 'Could not load stories',
              message:
                  'Check your connection and try again. Saved stories will appear here when available.',
              actionLabel: 'Try again',
              onAction: () {
                setState(_loadArticles);
              },
            ),
          );
        }

        final articlesList = snapshot.data ?? [];
        if (articlesList.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: _NewsMessage(
              icon: widget.searchQuery.isEmpty
                  ? Icons.newspaper_rounded
                  : Icons.search_off_rounded,
              title: widget.searchQuery.isEmpty
                  ? 'No stories yet'
                  : 'No results found',
              message: widget.searchQuery.isEmpty
                  ? 'Pull down to refresh and check for new stories.'
                  : 'Try another keyword or clear your search.',
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return NewsTitle(
              article: articlesList[index],
              featured: index == 0,
            );
          }, childCount: articlesList.length),
        );
      },
    );
  }
}

class _NewsMessage extends StatelessWidget {
  const _NewsMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E1D3),
                borderRadius: BorderRadius.circular(21),
              ),
              child: Icon(icon, color: const Color(0xFF9A7448), size: 30),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF172421),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF737870),
                height: 1.4,
                fontSize: 14,
              ),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NewsLoadingSkeleton extends StatelessWidget {
  const _NewsLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
      child: Column(
        children: [
          Container(
            height: 318,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D172421),
                  blurRadius: 18,
                  offset: Offset(0, 7),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: Color(0xFFE7E4DD)),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SkeletonLine(width: 72, height: 8, dark: true),
                        const SizedBox(height: 15),
                        _SkeletonLine(
                          width: double.infinity,
                          height: 17,
                          dark: true,
                        ),
                        const SizedBox(height: 8),
                        _SkeletonLine(width: 220, height: 17, dark: true),
                        const SizedBox(height: 14),
                        _SkeletonLine(width: 120, height: 9, dark: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const _CompactStorySkeleton(),
          const _CompactStorySkeleton(),
        ],
      ),
    );
  }
}

class _CompactStorySkeleton extends StatelessWidget {
  const _CompactStorySkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 104,
            decoration: BoxDecoration(
              color: const Color(0xFFE7E4DD),
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonLine(width: 68, height: 8),
                SizedBox(height: 12),
                _SkeletonLine(width: double.infinity, height: 12),
                SizedBox(height: 7),
                _SkeletonLine(width: 135, height: 12),
                SizedBox(height: 16),
                _SkeletonLine(width: 80, height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({
    required this.width,
    required this.height,
    this.dark = false,
  });

  final double width;
  final double height;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: dark ? const Color(0x668B8B80) : const Color(0xFFE7E4DD),
        borderRadius: BorderRadius.circular(height),
      ),
    );
  }
}
