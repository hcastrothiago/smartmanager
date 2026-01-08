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

  const AppCarousel({super.key, required this.items, this.height = 180});

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  static const int kFakeMiddle = 10000;
  late final int _initialPage;
  late final PageController _controller;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _initialPage = kFakeMiddle * widget.items.length;
    _controller = PageController(initialPage: _initialPage);

    // Sem autoplay, sem animação automática
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            allowImplicitScrolling: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              final realIndex = index % widget.items.length;
              return _carouselCard(widget.items[realIndex]);
            },
            onPageChanged: (index) {
              final real = index % widget.items.length;
              setState(() => _currentIndex = real);

              // Reposicionamento invisível para manter o loop estável
              final lowerBound = widget.items.length;
              final upperBound =
                  (kFakeMiddle * widget.items.length) + widget.items.length;

              if (index <= lowerBound || index >= upperBound) {
                Future.microtask(() {
                  _controller.jumpToPage(_initialPage + real);
                });
              }
            },
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
