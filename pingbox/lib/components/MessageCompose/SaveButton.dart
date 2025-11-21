import 'package:flutter/material.dart';

class CustomSaveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isSaving;
  final String text;

  const CustomSaveButton({
    super.key,
    required this.onPressed,
    required this.isSaving,
    this.text = "Gelecekteki Bana Gönder",
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isSaving ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: EdgeInsets.zero,
        ).copyWith(
          backgroundColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
          shadowColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            color: isSaving
                ? colorScheme.inversePrimary.withOpacity(0.6)
                : colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}