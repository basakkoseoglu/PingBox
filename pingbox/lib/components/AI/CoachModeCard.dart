import 'package:flutter/material.dart';

class CoachModeCard extends StatelessWidget {
  final String mode;
  final String reason;

  const CoachModeCard({
    super.key,
    required this.mode,
    required this.reason,
  });


    Color _resolveModeColor(ColorScheme scheme) {
    switch (mode.toLowerCase()) {
      case "focus":
        return scheme.primary; 
      case "relax":
        return Colors.lightBlueAccent.withOpacity(0.6);
      case "energy_boost":
        return Colors.amber.withOpacity(0.7);
      case "mood_support":
        return Colors.pinkAccent.withOpacity(0.6);
      case "health":
        return scheme.tertiary; 
      default:
        return scheme.primary.withOpacity(0.4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final modeColor = _resolveModeColor(scheme);


    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            modeColor.withOpacity(0.20),
            modeColor.withOpacity(0.10),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color:  modeColor.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/logo/ailogo.png",width: 40,height: 40,),
              SizedBox(width: 5,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                         color: scheme.onSurface,
                        letterSpacing: 1,
                      ),
                    ),
                    Text("Günün modu",
                    style: TextStyle(
                        fontSize: 12,
                         color: scheme.onSurface.withOpacity(0.5),
                      ),)
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            reason,
            style: TextStyle(
              fontSize: 16,
              height: 1.35,
              color: scheme.onSurface.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
