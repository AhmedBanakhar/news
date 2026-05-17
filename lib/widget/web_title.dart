import 'package:flutter/material.dart';
import 'package:news_app/model/article_model.dart';

class WebTitle extends StatelessWidget {
  const WebTitle({super.key, required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title ?? 'No title available',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 18),
        /**
         * * The Material widget is used to create a card-like effect for the article's image, providing elevation and rounded corners. This enhances the visual appeal of the image and makes it stand out as a key element of the article's presentation. The use of Clip.antiAlias ensures that the edges of the image are smooth and visually pleasing, contributing to a polished overall design.
         */
        Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: article.urlToImage != null
              ? Image.network(
                  article.urlToImage!,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'images/nodata.avif',
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(height: 20),
        Text(
          article.description?.isNotEmpty == true
              ? article.description!
              : 'No description is available for this article.',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Read later',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: const Center(
                  child: Text(
                    'Share this story',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
