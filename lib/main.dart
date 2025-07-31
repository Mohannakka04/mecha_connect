// ignore: depend_on_referenced_packages
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mecha_connect/screens.dart';
import 'dart:async'; 


void main() {
  if (kIsWeb) {
    return runApp(DevicePreview(builder: (context) => const MyApp()));
  } else {
    return runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mecha Connect App',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Define routes for navigation
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const OnboardingScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // AnimationController to manage the animation's progress
  late AnimationController _animationController;
  // Animation for fading the elements in
  late Animation<double> _fadeAnimation;
  // Animation for scaling the logo slightly
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _animationController = AnimationController(
      vsync: this, // The TickerProvider for the animation
      duration: const Duration(seconds: 3), // Duration of the animation
    );

    // Define the fade animation: goes from 0.0 (transparent) to 1.0 (fully opaque)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn, // Smooth start for the fade
      ),
    );

    // Define the scale animation: goes from 0.8 (slightly smaller) to 1.0 (original size)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack, // A little bounce effect for the scale
      ),
    );

    // Start the animation when the splash screen loads
    _animationController.forward();

    // After the animation finishes (or a slightly longer duration), navigate to the home screen
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  void dispose() {
    // Dispose the animation controller to prevent memory leaks
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color for the splash screen
      body: Center(
        child: FadeTransition(
          // Apply fade animation to the whole content
          opacity: _fadeAnimation,
          child: ScaleTransition(
            // Apply scale animation to the whole content
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Your app logo from assets
                // correctly placed in your project and declared in pubspec.yaml
                Image.asset(
                  'no_bg.png',
                  width: 400, // Adjust width as needed
                  height: 400, // Adjust height as needed
                ),
                const SizedBox(height: 20),
                // "MECHA" part of the app name
                // const Text(
                //   'MECHA',
                //   style: TextStyle(
                //     color: Color(0xFF2E3A59), // Dark blue color from logo
                //     fontSize: 28,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(height: 5), // Smaller gap between words
                // // "CONNECT" part of the app name
                // const Text(
                //   'CONNECT',
                //   style: TextStyle(
                //     color: Color(0xFFF15A22), // Orange color from logo
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 40),
                // Optional: A CircularProgressIndicator to show loading
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFF15A22),
                  ), // Orange color for indicator
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: const Center(
        child: Text(
          'Welcome to the Home Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:device_preview/device_preview.dart';
// import 'package:mecha_connect/chatboard.dart';
// void main()
// {
//   runApp(DevicePreview(builder:(context)=>MyApp()));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home:Chatboard(),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'chat_screen.dart';

// Future<void> main() async {
//   await dotenv.load(fileName: ".env");
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AI ChatBot',
//       home: ChatBotScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
