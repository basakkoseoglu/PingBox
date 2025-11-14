import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTapChange;
  final List<IconData> icons;
  const CustomBottomNav({super.key,required this.currentIndex,required this.onTapChange,required this.icons});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all( Radius.circular(24)),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 2,
        //     offset: const Offset(0, -3),
        //   ),
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
           final bool isSelected = index == currentIndex;
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
                color: isSelected ? const Color.fromARGB(255, 16, 47, 182) : Colors.grey,
              ),
             ),
          );
        }),
      ),
    );
  }
}