import 'package:flutter/material.dart';

import 'package:mecha_connect/Starting_screen/Login.dart';

//// --- Onboarding Screen ---
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'https://via.placeholder.com/150/FFC0CB/000000?text=Fuel',
      'title': 'Fuel On-Demand',
      'description':
          'Never run out of fuel again. Get petrol delivered directly to your location, for bikes, cars, and more.',
    },
    {
      'image': 'https://via.placeholder.com/150/FFB6C1/000000?text=Mechanic',
      'title': 'Instant Mechanic Help',
      'description':
          'Bike or car trouble? Connect with nearby mechanics for quick roadside repairs.',
    },
    {
      'image': 'https://via.placeholder.com/150/FF69B4/000000?text=Parts',
      'title': 'Genuine Parts Delivery',
      'description':
          'Order authentic spare parts and accessories for any vehicle, delivered to your doorstep.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                image: onboardingData[index]['image']!,
                title: onboardingData[index]['title']!,
                description: onboardingData[index]['description']!,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(onboardingData.length, (index) {
                      return Container(
                        height: 10,
                        width: _currentPage == index ? 20 : 10,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              _currentPage == index
                                  ? Colors.blue.shade400
                                  : Colors.grey.shade300,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                      ),
                      onPressed: () {
                        if (_currentPage < onboardingData.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          // Last page, navigate to main app
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const UserLoginScreen(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        _currentPage == onboardingData.length - 1
                            ? 'Get Started'
                            : 'Next',
                      ),
                    ),
                  ),

                  SizedBox(height: 5),
                  // if (_currentPage < onboardingData.length - 1)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const UserLoginScreen(),
                        ),
                      );
                    },

                    child: Text(
                      'Skip',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.blue.shade400),
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

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            image,
            height: 200,
            width: 200,
            errorBuilder:
                (context, error, stackTrace) => const Icon(
                  Icons.error,
                  size: 200,
                  color: Colors.blue,
                ), // Fallback
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.blue.shade400),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
