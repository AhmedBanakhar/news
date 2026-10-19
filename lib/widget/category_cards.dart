import 'package:flutter/material.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/views/category_view.dart';

class CategoryCards extends StatelessWidget {
  const CategoryCards({
    super.key,
    required this.category,
    required this.repository,
  });

  final CategoryModel category;
  final NewsRepository repository;

  IconData get _categoryIcon => switch (category.categoryName.toLowerCase()) {
    'business' => Icons.account_balance_rounded,
    'entertainment' => Icons.movie_filter_rounded,
    'health' => Icons.health_and_safety_rounded,
    'science' => Icons.science_rounded,
    'sports' => Icons.sports_soccer_rounded,
    'technology' => Icons.memory_rounded,
    _ => Icons.auto_awesome_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return CategoryView(
                category: category.categoryName,
                repository: repository,
              );
            },
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 122,
        width: 182,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(category.imageUrl),
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
              Color(0x730C1714),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x0017211E), Color(0xB317211E)],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: const Color(0x66FFFFFF)),
                ),
                child: Icon(_categoryIcon, color: Colors.white, size: 17),
              ),
            ),
            Positioned(
              left: 15,
              bottom: 13,
              right: 13,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'DISCOVER',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.76),
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          category.categoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black54,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Color(0xFFE8BD86),
                        size: 17,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
