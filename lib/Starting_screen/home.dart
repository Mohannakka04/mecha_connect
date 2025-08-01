import 'package:flutter/material.dart';
import 'package:mecha_connect/homescreen/drawerscreen.dart';
import 'package:mecha_connect/homescreen/mechanic_screen.dart';
import 'package:mecha_connect/homescreen/petrol_page.dart';

class ServiceSelectionScreen extends StatefulWidget {
  const ServiceSelectionScreen({super.key});

  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = (screenHeight * 0.5).clamp(180.0, 220.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Mecha Connect',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      endDrawer: ProfileDrawer(),
      backgroundColor:  Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Choose Your Service',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E3A59),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Select the service you need assistance with',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
          
                            const SizedBox(height: 32),
          
                            // Service Cards
                            Column(
                              children: [
                                SizedBox(
                                  height: cardHeight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VehicleFormPage(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: AssetImage('assets/mech.jpg'),
                                          fit: BoxFit.cover,
                                        ), // gradient: const LinearGradient(
                                        //   colors: [
                                        //     Color(0xFF4A90E2),
                                        //     Color(0xFF7B68EE),
                                        // //   ],
                                        //   begin: Alignment.topLeft,
                                        //   end: Alignment.bottomRight,
                                      ),
                                      // borderRadius: BorderRadius.circular(20),
                                      // boxShadow: [
                                      //     BoxShadow(
                                      //       color: const Color(0xFF4A90E2).withOpacity(0.3),
                                      //       blurRadius: 15,
                                      //       offset: const Offset(0, 8),
                                      //     ),
                                      //   ],
                                      // ),
                                      child: Stack(
                                        children: [
                                          // Background Pattern
                                          Positioned(
                                            right: -20,
                                            top: -20,
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white.withOpacity(
                                                  0.1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 10,
                                            bottom: -10,
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white.withOpacity(
                                                  0.05,
                                                ),
                                              ),
                                            ),
                                          ),
          
                                          // Content
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                // Icon
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(
                                                      0.2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(14),
                                                  ),
          
                                                  child: const Icon(
                                                    Icons.build_circle,
                                                    color: Colors.white,
                                                    size: 26,
                                                  ),
                                                ),
          
                                                // Text Content
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      // Title
                                                      const Text(
                                                        'Mechanic Assist',
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
          
                                                      const SizedBox(height: 4),
          
                                                      // Subtitle
                                                      Text(
                                                        'Professional repair services',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
          
                                                      //Text("Get instant help from certified mechanics for all your vehicle troubles"),
                                                      SizedBox(height: 8),
                                                      //Text("Get instant help from certified mechanics for all your vehicle troubles"),
          
                                                      // Description
                                                      Text(
                                                        'Get instant help from certified mechanics for all your vehicle troubles',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white
                                                              .withOpacity(0.9),
                                                          height: 1.3,
                                                        ),
                                                        maxLines: 3,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                // Arrow Icon
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Container(
                                                    width: 36,
                                                    height: 36,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(8),
                                                    ),
                                                    child: const Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.white,
                                                      size: 18,
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
                                ),
          
                                const SizedBox(height: 16),
          
                                // Petrol Assist Card
                                SizedBox(
                                  height: cardHeight,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Add navigation to Petrol Service screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FuelSelectionPage(),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'assets/petrol.jpg',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            // gradient: const LinearGradient(
                                            //   colors: [
                                            //     Color(0xFFFF6B35),
                                            //     Color(0xFFFF8E53),
                                            //   ],
                                            //   begin: Alignment.topLeft,
                                            //   end: Alignment.bottomRight,
                                            // ),
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.2,
                                                ),
                                                blurRadius: 15,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: [
                                              // Background Pattern
                                              Positioned(
                                                right: -20,
                                                top: -20,
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white.withOpacity(
                                                      0.1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 10,
                                                bottom: -10,
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    // ignore: deprecated_member_use
                                                    color: Colors.white.withOpacity(
                                                      0.05,
                                                    ),
                                                  ),
                                                ),
                                              ),
          
                                              // Content
                                              Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    // Icon
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        // ignore: deprecated_member_use
                                                        color: Colors.white
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              14,
                                                            ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.local_gas_station,
                                                        color: Colors.white,
                                                        size: 26,
                                                      ),
                                                    ),
          
                                                    // Text Content
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          // Title
                                                          const Text(
                                                            'Petrol Assist',
                                                            style: TextStyle(
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors.white,
                                                            ),
                                                          ),
          
                                                          const SizedBox(height: 4),
          
                                                          // Subtitle
                                                          Text(
                                                            'Fuel delivery on demand',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              // ignore: deprecated_member_use
                                                              color: Colors.white,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                          ),
          
                                                          const SizedBox(height: 8),
          
                                                          // Description
                                                          Text(
                                                            'Never run out of fuel again with our doorstep delivery service',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.white
                                                                  .withOpacity(0.9),
                                                              height: 1.3,
                                                            ),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
          
                                                    // Arrow Icon
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Container(
                                                        width: 36,
                                                        height: 36,
                                                        decoration: BoxDecoration(
                                                          // ignore: deprecated_member_use
                                                          color: Colors.white
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.arrow_forward,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
          
                            const SizedBox(height: 20),
          
                            // Footer
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.support_agent,
                                      // color: Colors.orange,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          '24/7 Support Available',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2E3A59),
                                          ),
                                        ),
                                        Text(
                                          'Need help? Contact our support team',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.grey.shade400,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
    //)
  }
}
