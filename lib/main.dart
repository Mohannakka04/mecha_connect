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
    
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: FadeTransition(
          
          opacity: _fadeAnimation,
          child: ScaleTransition(
            
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Image.asset(
                  'assets/no_bg.png',
                  width: 400, 
                  height: 400,
                ),
                const SizedBox(height: 20),
                
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




class AppColors {
  
  static const Color primaryBlue = Color(0xFF4285F4); 
  static const Color accentOrange = Color(0xFFFB8C00);

  
  static const Color textPrimary = Color(0xFF212121); 
  static const Color textSecondary = Color(0xFF9E9E9E); 
  static const Color textOnPrimary = Color(0xFFFFFFFF); 

  
  static const Color backgroundWhite = Color(0xFFFFFFFF); 
  static const Color backgroundLightGrey = Color(0xFFF5F5F5); 
  static const Color backgroundInputFill = Color(0xFFEEEEEE); 

  
  static const Color borderGrey = Color(0xFFE0E0E0); 
  static const Color iconDefault = Color(0xFF212121);
  static const Color iconActive = Color(0xFF4285F4); 

  
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFF44336); 

  
  static const MaterialColor primaryMaterialSwatch = MaterialColor(
    0xFF4285F4,
    <int, Color>{
      50: Color(0xFFE3F2FD), 
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF4285F4),   
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),   
    },
  );
}