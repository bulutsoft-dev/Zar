import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const ZarApp());
}

// Premium renk paleti
class AppColors {
  static const Color primaryDark = Color(0xFF1A1A2E);
  static const Color secondaryDark = Color(0xFF16213E);
  static const Color accentColor = Color(0xFF0F3460);
  static const Color highlightColor = Color(0xFFE94560);
  static const Color goldColor = Color(0xFFFFD700);
  static const Color neonPurple = Color(0xFF9B59B6);
}

class ZarApp extends StatelessWidget {
  const ZarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zar Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.highlightColor,
        scaffoldBackgroundColor: AppColors.primaryDark,
        useMaterial3: true,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
          bodyLarge: TextStyle(
            letterSpacing: 1.2,
          ),
        ),
      ),
      home: const SplashScreen(),
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
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const DiceScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark,
              AppColors.secondaryDark,
              AppColors.accentColor,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  Transform.rotate(
                    angle: _rotateAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.highlightColor,
                              AppColors.neonPurple,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.highlightColor.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                            BoxShadow(
                              color: AppColors.neonPurple.withOpacity(0.3),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.casino,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // App Name
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          AppColors.goldColor,
                          AppColors.highlightColor,
                          AppColors.goldColor,
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'ZAR PRO',
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 8,
                          shadows: [
                            Shadow(
                              color: AppColors.highlightColor,
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Premium Dice Experience',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                        letterSpacing: 4,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Loading Indicator
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.highlightColor,
                        ),
                        minHeight: 3,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class DiceScreen extends StatefulWidget {
  const DiceScreen({super.key});

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen>
    with SingleTickerProviderStateMixin {
  // Configuration constants
  static const int rollAnimationTicks = 15;
  static const int maxRollHistory = 5;

  int numberOfDice = 1;
  List<int> diceValues = [1];
  final Random random = Random();
  bool isRolling = false;
  List<List<int>> rollHistory = [];
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void rollDice() {
    if (isRolling) return;

    setState(() {
      isRolling = true;
    });

    _shakeController.repeat();

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Animate the roll
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (timer.tick >= rollAnimationTicks) {
        timer.cancel();
        _shakeController.stop();
        _shakeController.reset();

        // Add to history
        if (rollHistory.length >= maxRollHistory) {
          rollHistory.removeAt(0);
        }
        rollHistory.add(List.from(diceValues));

        setState(() {
          isRolling = false;
        });

        HapticFeedback.heavyImpact();
      } else {
        setState(() {
          diceValues =
              List.generate(numberOfDice, (_) => random.nextInt(6) + 1);
        });
      }
    });
  }

  void updateNumberOfDice(int count) {
    HapticFeedback.selectionClick();
    setState(() {
      numberOfDice = count;
      diceValues = List.generate(numberOfDice, (_) => 1);
    });
  }

  int get totalValue => diceValues.fold(0, (sum, value) => sum + value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryDark,
              AppColors.secondaryDark,
              AppColors.accentColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildAppBar(),
              const SizedBox(height: 16),
              // Dice count selector
              _buildDiceSelector(),
              const SizedBox(height: 16),
              // Total value display
              _buildTotalDisplay(),
              // Dice display area
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _shakeController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: isRolling
                            ? Offset(
                                sin(_shakeController.value * 2 * pi * 4) * 8,
                                cos(_shakeController.value * 2 * pi * 3) * 8,
                              )
                            : Offset.zero,
                        child: child,
                      );
                    },
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: diceValues.asMap().entries.map((entry) {
                        return DiceWidget(
                          value: entry.value,
                          isRolling: isRolling,
                          index: entry.key,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              // Roll history
              if (rollHistory.isNotEmpty) _buildRollHistory(),
              // Roll button
              _buildRollButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.highlightColor, AppColors.neonPurple],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.highlightColor.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.casino,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, Color(0xFFC0C0C0)],
            ).createShader(bounds),
            child: const Text(
              'ZAR PRO',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiceSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.tune,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'ZAR SAYISI',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              int count = index + 1;
              bool isSelected = numberOfDice == count;
              return GestureDetector(
                onTap: () {
                  if (!isRolling) {
                    updateNumberOfDice(count);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.highlightColor,
                              AppColors.neonPurple,
                            ],
                          )
                        : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.highlightColor.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldColor.withOpacity(0.2),
            AppColors.highlightColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.goldColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: AppColors.goldColor.withOpacity(0.8),
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'TOPLAM',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.7),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              '$totalValue',
              key: ValueKey<int>(totalValue),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.goldColor,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRollHistory() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: Colors.white.withOpacity(0.5),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'SON ATIŞLAR',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: rollHistory.length,
              reverse: true,
              itemBuilder: (context, index) {
                List<int> roll = rollHistory[rollHistory.length - 1 - index];
                int total = roll.fold(0, (sum, value) => sum + value);
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.neonPurple.withOpacity(0.3),
                        AppColors.highlightColor.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      ...roll.map((v) => Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              '$v',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          )),
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.goldColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '=$total',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRollButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GestureDetector(
        onTap: isRolling ? null : rollDice,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: isRolling
                ? LinearGradient(
                    colors: [
                      AppColors.accentColor.withOpacity(0.5),
                      AppColors.secondaryDark.withOpacity(0.5),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.highlightColor,
                      AppColors.neonPurple,
                    ],
                  ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: isRolling
                ? null
                : [
                    BoxShadow(
                      color: AppColors.highlightColor.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isRolling ? Icons.hourglass_top : Icons.casino,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                isRolling ? 'ATILIYOR...' : 'ZAR AT',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiceWidget extends StatelessWidget {
  final int value;
  final bool isRolling;
  final int index;

  const DiceWidget({
    super.key,
    required this.value,
    required this.isRolling,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFF5F5F5),
            Color(0xFFE8E8E8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          // Main shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          // Inner glow effect
          BoxShadow(
            color: AppColors.highlightColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: -5,
          ),
          // Ambient glow
          BoxShadow(
            color: AppColors.neonPurple.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 3D effect - top highlight
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Dice dots
          Center(
            child: _buildDots(value),
          ),
        ],
      ),
    );
  }

  Widget _buildDots(int value) {
    List<Widget> dots = [];

    switch (value) {
      case 1:
        return Center(child: _dot());
      case 2:
        dots = [
          Positioned(top: 20, left: 20, child: _dot()),
          Positioned(bottom: 20, right: 20, child: _dot()),
        ];
        break;
      case 3:
        dots = [
          Positioned(top: 20, left: 20, child: _dot()),
          Center(child: _dot()),
          Positioned(bottom: 20, right: 20, child: _dot()),
        ];
        break;
      case 4:
        dots = [
          Positioned(top: 20, left: 20, child: _dot()),
          Positioned(top: 20, right: 20, child: _dot()),
          Positioned(bottom: 20, left: 20, child: _dot()),
          Positioned(bottom: 20, right: 20, child: _dot()),
        ];
        break;
      case 5:
        dots = [
          Positioned(top: 20, left: 20, child: _dot()),
          Positioned(top: 20, right: 20, child: _dot()),
          Center(child: _dot()),
          Positioned(bottom: 20, left: 20, child: _dot()),
          Positioned(bottom: 20, right: 20, child: _dot()),
        ];
        break;
      case 6:
        dots = [
          Positioned(top: 20, left: 20, child: _dot()),
          Positioned(top: 20, right: 20, child: _dot()),
          Positioned(top: 47, left: 20, child: _dot()),
          Positioned(top: 47, right: 20, child: _dot()),
          Positioned(bottom: 20, left: 20, child: _dot()),
          Positioned(bottom: 20, right: 20, child: _dot()),
        ];
        break;
    }

    return Stack(
      children: dots,
    );
  }

  Widget _dot() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.highlightColor,
            AppColors.neonPurple,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.highlightColor.withOpacity(0.5),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
