import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTapChange;
  final List<IconData> icons;
  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTapChange,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          final bool isSelected = index == currentIndex;
          if (index == 2) {
            return _buildAiButton(scheme, isSelected, () => onTapChange(index));
          }

          return GestureDetector(
            onTap: () => onTapChange(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icons[index],
                size: isSelected ? 28 : 24,
                color: isSelected ? scheme.inversePrimary : Colors.grey,
              ),
            ),
          );
        }),
      ),
    );
  }
}

Widget _buildAiButton(ColorScheme scheme, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 20,
          child: Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
            ),
          ),
        ),

        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: scheme.inversePrimary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: scheme.inversePrimary.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Transform.translate(
              offset: const Offset(-3, 0), 
              child: Icon(
                FontAwesomeIcons.robot,
                color: scheme.surface,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
