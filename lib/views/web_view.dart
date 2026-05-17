import 'package:flutter/material.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/widget/web_title.dart';

class WebView extends StatelessWidget {
  const WebView({super.key, required this.article});
  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Web'),
            Text('News', style: TextStyle(color: Colors.orange)),
          ],
        ),
      ),
      /**
       * * SafeArea is used to avoid any potential overlap with system UI elements, ensuring that the content is displayed correctly on all devices. The padding around the content provides a clean and professional look, enhancing readability and user experience.
       * * SingleChildScrollView allows the content to be scrollable, which is essential for displaying articles that may have varying lengths. The BouncingScrollPhysics adds a nice touch to the scrolling behavior, giving it a more natural feel, especially on iOS devices.
       */
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 4,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Article detail',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Read the full story below with clean spacing and professional layout.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 25),
                WebTitle(article: article),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
