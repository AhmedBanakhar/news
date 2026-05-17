import 'package:flutter/material.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/widget/category_cards.dart';

class CategoriesListViewCards extends StatelessWidget {
  const CategoriesListViewCards({super.key});

  final List<CategoryModel> categories = const [
    CategoryModel(categoryName: "Business", imageUrl: "images/business.jpeg"),
    CategoryModel(
      categoryName: "Entertainment",
      imageUrl: "images/Entertainment.jpeg",
    ),
    CategoryModel(categoryName: "Health", imageUrl: "images/health.jpeg"),
    CategoryModel(categoryName: "Science", imageUrl: "images/Science.jpeg"),
    CategoryModel(categoryName: "Sports", imageUrl: "images/sport.jpeg"),
    CategoryModel(
      categoryName: "Technology",
      imageUrl: "images/Technology.jpeg",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        /**
         * *_ = context
         * *__ = index
         * * The separatorBuilder is used to create a visual separation between the category cards in the horizontal
         *          */
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return CategoryCards(category: categories[index]);
        },
      ),
    );
  }
}
