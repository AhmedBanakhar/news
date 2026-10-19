import 'package:flutter/material.dart';
import 'package:news_app/model/article_model.dart';
import 'package:news_app/views/web_view.dart';

class NewsTitle extends StatelessWidget {
  const NewsTitle({
    super.key,
    required this.article,
    this.featured = false,
  });

  final ArticleModel article;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    if (featured) {
      return _FeaturedNewsCard(article: article);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      elevation: 1,
      shadowColor: Colors.black12,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: () => _openArticle(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: _ArticleImage(
                  url: article.urlToImage,
                  height: 104,
                  width: 100,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 104,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'THE LATEST',
                        style: TextStyle(
                          color: Color(0xFF9A7448),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Expanded(
                        child: Text(
                          article.title ?? 'Untitled story',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF172421),
                            fontSize: 15,
                            height: 1.27,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            'Read story',
                            style: TextStyle(
                              color: Color(0xFF9A7448),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 13,
                            color: Color(0xFF9A7448),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openArticle(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => WebView(article: article)),
    );
  }
}

class _FeaturedNewsCard extends StatelessWidget {
  const _FeaturedNewsCard({required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(18, 6, 18, 16),
      elevation: 4,
      shadowColor: const Color(0x2617211E),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WebView(article: article)),
          );
        },
        child: SizedBox(
          height: 318,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _ArticleImage(url: article.urlToImage, height: 318),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x26000000),
                      Color(0x08000000),
                      Color(0xE6000000),
                    ],
                    stops: [0, 0.35, 1],
                  ),
                ),
              ),
              Positioned(
                left: 18,
                top: 18,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xE6172421),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0x66D7A66A)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFFD7A66A),
                        size: 13,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'FEATURED STORY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 19,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title ?? 'Untitled story',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.35,
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            blurRadius: 12,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    if (article.description?.isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      Text(
                        article.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFDADBD7),
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                    const SizedBox(height: 15),
                    const Row(
                      children: [
                        Text(
                          'Read the story',
                          style: TextStyle(
                            color: Color(0xFFE8BD86),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 7),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Color(0xFFE8BD86),
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleImage extends StatelessWidget {
  const _ArticleImage({
    required this.url,
    this.height = 190,
    this.width = double.infinity,
  });

  final String? url;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _ImagePlaceholder(height: height, width: width);
    }

    return Image.network(
      url!,
      height: height,
      width: width,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return _ImagePlaceholder(height: height, width: width);
      },
      errorBuilder: (context, error, stackTrace) {
        return _ImagePlaceholder(height: height, width: width);
      },
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/nodata.avif',
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }
}
