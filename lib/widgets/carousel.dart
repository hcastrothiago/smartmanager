import 'package:flutter/material.dart';

class AppCarousel extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final Duration autoPlayDuration;

  const AppCarousel({
    Key? key,
    required this.items,
    this.height = 180,
    this.autoPlayDuration = const Duration(seconds: 4),
  }) : super(key: key);

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Auto-play
    Future.delayed(widget.autoPlayDuration, _autoPlay);
  }

  void _autoPlay() {
    if (!mounted || widget.items.length <= 1) return;

    int nextPage = (_currentIndex + 1) % widget.items.length;

    _controller.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    Future.delayed(widget.autoPlayDuration, _autoPlay);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.items.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return widget.items[index];
            },
          ),
        ),

        const SizedBox(height: 8),

        // 🔵 INDICADORES (BOLINHAS)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.items.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? Colors.blue
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
