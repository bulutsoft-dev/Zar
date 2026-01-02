import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const ZarApp());
}

class ZarApp extends StatelessWidget {
  const ZarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DiceScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.casino,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'ZAR',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
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

class _DiceScreenState extends State<DiceScreen> {
  int numberOfDice = 1;
  List<int> diceValues = [1];
  final Random random = Random();
  bool isRolling = false;

  void rollDice() {
    if (isRolling) return;

    setState(() {
      isRolling = true;
    });

    // Animate the roll
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (timer.tick >= 10) {
        timer.cancel();
        setState(() {
          isRolling = false;
        });
      } else {
        setState(() {
          diceValues = List.generate(numberOfDice, (_) => random.nextInt(6) + 1);
        });
      }
    });
  }

  void updateNumberOfDice(int count) {
    setState(() {
      numberOfDice = count;
      diceValues = List.generate(numberOfDice, (_) => 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zar Atma'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Dice count selector
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Zar Sayısı',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    int count = index + 1;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text('$count'),
                        selected: numberOfDice == count,
                        onSelected: (selected) {
                          if (selected && !isRolling) {
                            updateNumberOfDice(count);
                          }
                        },
                        selectedColor: Colors.blue,
                        labelStyle: TextStyle(
                          color: numberOfDice == count ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Dice display area
          Expanded(
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: diceValues.map((value) {
                  return DiceWidget(value: value, isRolling: isRolling);
                }).toList(),
              ),
            ),
          ),
          // Roll button
          Padding(
            padding: const EdgeInsets.all(32),
            child: ElevatedButton(
              onPressed: isRolling ? null : rollDice,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(isRolling ? 'Atılıyor...' : 'Zar At'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class DiceWidget extends StatelessWidget {
  final int value;
  final bool isRolling;

  const DiceWidget({
    super.key,
    required this.value,
    required this.isRolling,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: _buildDots(value),
      ),
    );
  }

  Widget _buildDots(int value) {
    List<Widget> dots = [];

    switch (value) {
      case 1:
        dots = [_dot()];
        break;
      case 2:
        dots = [
          Positioned(top: 15, left: 15, child: _dot()),
          Positioned(bottom: 15, right: 15, child: _dot()),
        ];
        break;
      case 3:
        dots = [
          Positioned(top: 15, left: 15, child: _dot()),
          Positioned(top: 40, left: 40, child: _dot()),
          Positioned(bottom: 15, right: 15, child: _dot()),
        ];
        break;
      case 4:
        dots = [
          Positioned(top: 15, left: 15, child: _dot()),
          Positioned(top: 15, right: 15, child: _dot()),
          Positioned(bottom: 15, left: 15, child: _dot()),
          Positioned(bottom: 15, right: 15, child: _dot()),
        ];
        break;
      case 5:
        dots = [
          Positioned(top: 15, left: 15, child: _dot()),
          Positioned(top: 15, right: 15, child: _dot()),
          Positioned(top: 40, left: 40, child: _dot()),
          Positioned(bottom: 15, left: 15, child: _dot()),
          Positioned(bottom: 15, right: 15, child: _dot()),
        ];
        break;
      case 6:
        dots = [
          Positioned(top: 15, left: 15, child: _dot()),
          Positioned(top: 15, right: 15, child: _dot()),
          Positioned(top: 40, left: 15, child: _dot()),
          Positioned(top: 40, right: 15, child: _dot()),
          Positioned(bottom: 15, left: 15, child: _dot()),
          Positioned(bottom: 15, right: 15, child: _dot()),
        ];
        break;
    }

    return Stack(
      children: dots,
    );
  }

  Widget _dot() {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
    );
  }
}
