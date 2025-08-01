// ignore: depend_on_referenced_packages
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mecha_connect/Starting_screen/screens.dart';
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



class AppColors {
  // Primary Brand Colors (from your logo and main theme)
  static const Color primaryBlue = Color(0xFF4285F4); // A vibrant blue
  static const Color accentOrange = Color(0xFFFB8C00); // A warm, energetic orange

  // Text Colors
  static const Color textPrimary = Color(0xFF212121); // Very dark grey for main headings/text
  static const Color textSecondary = Color(0xFF9E9E9E); // Medium grey for descriptions/less important text
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White text for use on primary colored backgrounds (buttons etc.)

  // Background Colors
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Pure white for main screen backgrounds, cards
  static const Color backgroundLightGrey = Color(0xFFF5F5F5); // Very subtle off-white for main screen backgrounds to give cards lift
  static const Color backgroundInputFill = Color(0xFFEEEEEE); // Light grey for input field backgrounds

  // UI Element Colors
  static const Color borderGrey = Color(0xFFE0E0E0); // Light grey for borders, dividers
  static const Color iconDefault = Color(0xFF212121); // Dark grey for general icons
  static const Color iconActive = Color(0xFF4285F4); // Primary blue for active icons (e.g., bottom nav)

  // Feedback/State Colors
  static const Color successGreen = Color(0xFF4CAF50); // Green for success messages
  static const Color errorRed = Color(0xFFF44336); // Red for error messages

  // MaterialColor for Primary Swatch (useful for ThemeData.primarySwatch)
  // This generates a range of shades based on your primary color.
  static const MaterialColor primaryMaterialSwatch = MaterialColor(
    0xFF4285F4, // This is your primaryBlue color's hex code
    <int, Color>{
      50: Color(0xFFE3F2FD),   // Lighter shade for very subtle accents
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF4285F4),   // Your primaryBlue
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),   // Darker shade for deep accents
    },
  );
}