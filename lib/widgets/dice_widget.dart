import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Widget displaying a single dice
class DiceWidget extends StatelessWidget {
  final int value;
  final bool isRolling;
  final int index;
  final bool isDarkMode;
  
  const DiceWidget({
    super.key,
    required this.value,
    required this.isRolling,
    this.index = 0,
    required this.isDarkMode,
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  Colors.white,
                  const Color(0xFFF5F5F5),
                  const Color(0xFFE8E8E8),
                ]
              : [
                  Colors.white,
                  const Color(0xFFF8F8F8),
                  const Color(0xFFEEEEEE),
                ],
        ),
        borderRadius: BorderRadius.circular(0), // Sharp corners
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.5)
              : Colors.black.withOpacity(0.2),
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
                borderRadius: BorderRadius.circular(0),
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
