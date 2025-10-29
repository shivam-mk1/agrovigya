import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';

class SlideshowScreen extends StatefulWidget {
  const SlideshowScreen({super.key});

  @override
  State<SlideshowScreen> createState() => _SlideshowScreenState();
}

class _SlideshowScreenState extends State<SlideshowScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, String>> slides = [
    {
      "image": "assets/images/image1.jpg",
      "text": "Agricultural Marketplace",
      "subtext":
          "Buy and Sell farm produce directly to customers and businesses",
      "icon": "🌾",
    },
    {
      "image": "assets/images/image2.jpg",
      "text": "Empowering Farmers with Technology",
      "subtext":
          "Join AgroVigya in revolutionizing through smart and sustainable practices",
      "icon": "🚜",
    },
    {
      "image": "assets/images/image3.jpg",
      "text": "Why Choose AgroVigya?",
      "subtext":
          "Leverage AI powered tools to optimize yield and boost productivity",
      "icon": "🤖",
    },
    {
      "image": "assets/images/image4.jpg",
      "text": "Join the Farming Community",
      "subtext": "Buy and sell farm produce easily with smart farming tools.",
      "icon": "🤝",
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _startSlideShow();
    _fadeController.forward();
    _slideController.forward();
  }

  void _startSlideShow() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (mounted) {
        setState(() {
          if (_currentIndex < slides.length - 1) {
            _currentIndex++;
          } else {
            _currentIndex = 0;
          }
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          );
        });

        // Reset and restart animations for new slide
        _fadeController.reset();
        _slideController.reset();
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Images with Parallax Effect
          PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  // Background Image
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(slides[index]["image"]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha(28),
                          Colors.black.withAlpha(78),
                          Colors.black.withAlpha(180),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Top Brand Section
          Positioned(
            top: screenHeight * 0.08,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(38),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white.withAlpha(76)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xff147b2c),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.agriculture,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "AgroVigya",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Page Indicators
          Positioned(
            top: screenHeight * 0.2,
            right: 20,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: List.generate(
                  slides.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    height: _currentIndex == index ? 24 : 8,
                    width: 4,
                    decoration: BoxDecoration(
                      color:
                          _currentIndex == index
                              ? const Color(0xff147b2c)
                              : Colors.white.withAlpha(127),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          Positioned(
            bottom: screenHeight * 0.12,
            left: 20,
            right: 20,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withAlpha(51)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon and Title Row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xff147b2c).withAlpha(51),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: const Color(
                                      0xff147b2c,
                                    ).withAlpha(76),
                                  ),
                                ),
                                child: Text(
                                  slides[_currentIndex]["icon"]!,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  slides[_currentIndex]["text"]!,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Subtitle
                          Text(
                            slides[_currentIndex]["subtext"]!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withAlpha(229),
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Progress Bar
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(76),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Row(
                              children: List.generate(
                                slides.length,
                                (index) => Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          index <= _currentIndex
                                              ? const Color(0xff147b2c)
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Get Started Button
                          Row(
                            children: [
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  context.go('/login-or-signup');
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xff147b2c),
                                        Color(0xff1a9635),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xff147b2c,
                                        ).withAlpha(76),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Get Started",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(51),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
