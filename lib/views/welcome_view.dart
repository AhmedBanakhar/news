import 'package:flutter/material.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/views/home_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key, required this.repository});

  final NewsRepository repository;

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _footerOpacity;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    )..addStatusListener(_onAnimationStatusChanged);
    _logoScale = Tween<double>(begin: 0.72, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.58, curve: Curves.elasticOut),
      ),
    );
    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.34, curve: Curves.easeOut),
    );
    _titleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.68, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.16), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.68, curve: Curves.easeOutCubic),
          ),
        );
    _footerOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.9, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openHome();
      });
    }
  }

  void _openHome() {
    if (_isNavigating || !mounted) {
      return;
    }
    _isNavigating = true;
    _controller.stop();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 360),
        reverseTransitionDuration: const Duration(milliseconds: 240),
        pageBuilder: (context, animation, secondaryAnimation) {
          return HomeView(repository: widget.repository);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(opacity: fade, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_onAnimationStatusChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B19),
      body: Stack(
        children: [
          const Positioned(
            top: -170,
            right: -130,
            child: _AmbientGlow(size: 340),
          ),
          const Positioned(
            bottom: -220,
            left: -170,
            child: _AmbientGlow(size: 390, opacity: 0.07),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 22),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        color: Color(0xFFD7A66A),
                        size: 7,
                      ),
                      const SizedBox(width: 9),
                      const Expanded(
                        child: Text(
                          'THE DAILY EDITION',
                          style: TextStyle(
                            color: Color(0xFFCFD4CE),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.7,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _openHome,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFE8BD86),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeTransition(
                            opacity: _logoOpacity,
                            child: ScaleTransition(
                              scale: _logoScale,
                              child: const _WelcomeEmblem(),
                            ),
                          ),
                          const SizedBox(height: 34),
                          FadeTransition(
                            opacity: _titleOpacity,
                            child: SlideTransition(
                              position: _titleSlide,
                              child: const Column(
                                children: [
                                  Text(
                                    'WELCOME TO',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFD7A66A),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'NEWS CLOUD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        height: 1,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: Text(
                                      'A clearer view of what matters.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFFCFD4CE),
                                        fontSize: 15,
                                        height: 1.45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _footerOpacity,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: Color(0xFFD7A66A),
                          size: 14,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Stories worth your time.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFFB7BDB6),
                              fontSize: 12,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeEmblem extends StatelessWidget {
  const _WelcomeEmblem();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      width: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 190,
            width: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x26D7A66A)),
            ),
          ),
          Container(
            height: 158,
            width: 158,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x33FFFFFF)),
            ),
          ),
          Container(
            height: 112,
            width: 112,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFE6C7), Color(0xFFC58A4A)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40D7A66A),
                  blurRadius: 36,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Color(0xFF172421),
              size: 53,
            ),
          ),
          const Positioned(
            top: 25,
            right: 28,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFFE8BD86),
              size: 19,
            ),
          ),
          const Positioned(
            bottom: 34,
            left: 24,
            child: Icon(Icons.circle, color: Color(0x99D7A66A), size: 6),
          ),
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.size, this.opacity = 0.11});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFFD7A66A).withValues(alpha: opacity),
              const Color(0xFFD7A66A).withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
