import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/session_manager.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  // ============================================================
  // ONBOARDING PAGES
  // ============================================================

  final List<OnboardingData> pages = [
    OnboardingData(
      image:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=900&q=80',
      title: 'Discover Delicious Cakes',
      description:
          'Explore beautiful and delicious cakes made specially for every sweet moment.',
    ),
    OnboardingData(
      image:
          'https://images.unsplash.com/photo-1606890737304-57a1ca8a5b62?auto=format&fit=crop&w=900&q=80',
      title: 'Choose Your Favorite',
      description:
          'Find the perfect cake for birthdays, celebrations and every special occasion.',
    ),
    OnboardingData(
      image:
          'https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&w=900&q=80',
      title: 'Order Your Cake',
      description:
          'Place your order easily and enjoy your favorite cake from Divine Craving.',
    ),
  ];

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ============================================================
  // NEXT PAGE
  // ============================================================

  void nextPage() {
    if (currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  // ============================================================
  // SKIP
  // ============================================================

  void skipOnboarding() {
    completeOnboarding();
  }

  // ============================================================
  // COMPLETE ONBOARDING
  // ============================================================

  Future<void> completeOnboarding() async {
    // Save onboarding completed
    await SessionManager.instance.setOnboardingCompleted();

    if (!mounted) return;

    // ==========================================================
    // IMPORTANT
    // After onboarding ALWAYS show Role Selection
    // User + Admin
    // ==========================================================

    Navigator.pushReplacementNamed(context, '/role-selection');
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // TOP BAR
            // ==================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  TextButton(
                    onPressed: skipOnboarding,

                    child: Text(
                      'Skip',

                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // PAGE CONTENT
            // ==================================================
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,

                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },

                itemBuilder: (context, index) {
                  final item = pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),

                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // ==================================================
                        // CAKE IMAGE
                        // ==================================================
                        Expanded(
                          flex: 6,

                          child: Container(
                            width: double.infinity,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),

                            clipBehavior: Clip.antiAlias,

                            child: Image.network(
                              item.image,
                              fit: BoxFit.cover,

                              loadingBuilder: (context, child, progress) {
                                if (progress == null) {
                                  return child;
                                }

                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },

                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.cream,

                                  child: const Icon(
                                    Icons.cake_outlined,
                                    size: 90,
                                    color: AppColors.brown,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ==================================================
                        // TITLE
                        // ==================================================
                        Text(
                          item.title,

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ==================================================
                        // DESCRIPTION
                        // ==================================================
                        Text(
                          item.description,

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.65),

                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ==================================================
            // PAGE INDICATORS
            // ==================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: List.generate(pages.length, (index) {
                final isActive = currentPage == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),

                  margin: const EdgeInsets.symmetric(horizontal: 4),

                  height: 8,

                  width: isActive ? 28 : 8,

                  decoration: BoxDecoration(
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.25),

                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // NEXT / GET STARTED
            // ==================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 25),

              child: SizedBox(
                width: double.infinity,
                height: 56,

                child: FilledButton(
                  onPressed: nextPage,

                  child: Text(
                    currentPage == pages.length - 1 ? 'GET STARTED' : 'NEXT',

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ONBOARDING DATA
// ============================================================

class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}
