import 'package:flutter/material.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/widget/categories_list_view_cards.dart';
import 'package:news_app/widget/news_list_view_builder.dart';
import 'package:news_app/widget/search_categories.dart';

const _ink = Color(0xFF172421);
const _gold = Color(0xFFD7A66A);

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.repository});

  final NewsRepository repository;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<NewsListViewBuilderState> _newsListKey =
      GlobalKey<NewsListViewBuilderState>();
  String searchQuery = '';

  void _onSearchSubmitted(String value) {
    setState(() {
      searchQuery = value.trim();
    });
  }

  Future<void> _refreshNews() =>
      _newsListKey.currentState?.refresh() ?? Future<void>.value();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshNews,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: _EditionHeader(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: SearchCategories(onSubmitted: _onSearchSubmitted),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 26, 20, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Explore topics',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        'BROWSE',
                        style: TextStyle(
                          color: Color(0xFF92734F),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: CategoriesListViewCards(
                  repository: widget.repository,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 28)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          searchQuery.isEmpty ? 'Top stories' : 'Search results',
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECE7DC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          searchQuery.isEmpty
                              ? 'DAILY BRIEFING'
                              : 'MATCHING STORIES',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 9,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              NewsListViewBuilder(
                key: _newsListKey,
                category: 'general',
                searchQuery: searchQuery,
                repository: widget.repository,
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditionHeader extends StatelessWidget {
  _EditionHeader();

  static const _weekdays = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  static const _months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  String get _editionDate {
    final now = DateTime.now();
    return '${_weekdays[now.weekday - 1]}  ·  ${now.day} ${_months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF233530), Color(0xFF111B19)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2417211E),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, color: _gold, size: 8),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _editionDate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFD6D9D3),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.auto_awesome_rounded,
                color: _gold,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'NEWS CLOUD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              height: 1,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'A clearer view of what matters.',
            style: TextStyle(
              color: Color(0xFFCFD4CE),
              fontSize: 14,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 19),
          Container(height: 1, color: const Color(0x4DD7A66A)),
          const SizedBox(height: 12),
          const Row(
            children: [
              Text(
                'THE DAILY EDITION',
                style: TextStyle(
                  color: _gold,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              Spacer(),
              Icon(Icons.north_east_rounded, color: _gold, size: 15),
            ],
          ),
        ],
      ),
    );
  }
}
