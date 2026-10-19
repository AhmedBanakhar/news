import 'package:flutter/material.dart';
import 'package:news_app/model/article_model.dart';

class WebTitle extends StatelessWidget {
  const WebTitle({super.key, required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final description = article.description?.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StoryCover(article: article),
        const SizedBox(height: 28),
        Row(
          children: [
            Container(
              width: 3,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFFC58A4A),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'THE BRIEFING',
              style: TextStyle(
                color: Color(0xFF92734F),
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFEAE5DA)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D172421),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.format_quote_rounded,
                  color: Color(0xFFC58A4A),
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  description?.isNotEmpty == true
                      ? description!
                      : 'No summary is available for this story.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF414A46),
                    height: 1.75,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              size: 15,
              color: Color(0xFFC58A4A),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'A considered selection from News Cloud',
                style: TextStyle(
                  color: Color(0xFF777970),
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Container(
              height: 1,
              width: 34,
              color: const Color(0xFFDCD6CA),
            ),
          ],
        ),
      ],
    );
  }
}

class _StoryCover extends StatelessWidget {
  const _StoryCover({required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2617211E),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: SizedBox(
          height: 390,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _StoryImage(url: article.urlToImage),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x3B101816),
                      Color(0x00000000),
                      Color(0x1A000000),
                      Color(0xED101816),
                    ],
                    stops: [0, 0.28, 0.52, 1],
                  ),
                ),
              ),
              Positioned(
                left: 18,
                top: 18,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xCC172421),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0x66D7A66A)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFFE8BD86),
                        size: 13,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'NEWS CLOUD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 22,
                right: 22,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 2,
                      width: 38,
                      color: const Color(0xFFD7A66A),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      article.title?.trim().isNotEmpty == true
                          ? article.title!.trim()
                          : 'Untitled story',
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        height: 1.16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 14,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Row(
                      children: [
                        Text(
                          'FEATURED STORY',
                          style: TextStyle(
                            color: Color(0xFFE8BD86),
                            fontSize: 9,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 9),
                        Expanded(
                          child: Divider(
                            color: Color(0x66E8BD86),
                            height: 1,
                          ),
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

class _StoryImage extends StatelessWidget {
  const _StoryImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return const _StoryImagePlaceholder();
    }

    return Image.network(
      url!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return const _StoryImagePlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        return const _StoryImagePlaceholder();
      },
    );
  }
}

class _StoryImagePlaceholder extends StatelessWidget {
  const _StoryImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/nodata.avif',
      fit: BoxFit.cover,
    );
  }
}
