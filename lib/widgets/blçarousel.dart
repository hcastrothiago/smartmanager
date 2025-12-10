import 'package:flutter/material.dart';

class CarouselCardData {
  final String title;
  final String subTitle;
  final String? text1;
  final String? text2;
  final IconData leftIcon;
  final Color color;
  final Widget component;

  CarouselCardData({
    required this.title,
    required this.subTitle,
    this.text1,
    this.text2,
    required this.leftIcon,
    this.color = Colors.white,
    required this.component,
  });
}

class AppCarousel extends StatefulWidget {
  final List<CarouselCardData> items;
  final double height;
  final Duration autoPlayDuration;

  const AppCarousel({
    super.key,
    required this.items,
    this.height = 180,
    this.autoPlayDuration = const Duration(seconds: 4),
  });

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    _scheduleAutoPlay();
  }

  void _scheduleAutoPlay() {
    Future.delayed(widget.autoPlayDuration, _autoPlay);
  }

  void _autoPlay() {
    if (!mounted || widget.items.length <= 1) return;
    if (_isUserInteracting) return; // não avança durante swipe

    final nextPage = (_currentIndex + 1) % widget.items.length;

    _controller.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    _scheduleAutoPlay();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,

          /// 🔥 LISTENER adiciona pausa no autoplay quando o usuário toca/arrasta
          child: Listener(
            onPointerDown: (_) => _isUserInteracting = true,
            onPointerUp: (_) {
              _isUserInteracting = false;
              _scheduleAutoPlay();
            },

            child: PageView.builder(
              controller: _controller,
              itemCount: widget.items.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (_, i) => _carouselCard(widget.items[i]),
            ),
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.items.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == i ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == i ? Colors.blue : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _carouselCard(CarouselCardData data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: data.color.withOpacity(0.85),
      ),
      child: Center(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          data.leftIcon,
                          color: const Color.fromARGB(255, 130, 80, 195),
                          size: 30,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.text1 ?? ''),
                            Text(data.text2 ?? ''),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      data.subTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    data.component,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
