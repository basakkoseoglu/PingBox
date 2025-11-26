import 'package:flutter/material.dart';
import 'package:pingbox/components/AI/Shimmers/AIShimmerBox.dart';

class AIHomeShimmer extends StatelessWidget {
  const AIHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // header
          Row(
            children: [
              ShimmerBox(width: 52, height: 52, radius: 16),
              const SizedBox(width: 12),
              Column(
                children: [
                  ShimmerBox(width: 180, height: 18),
                  const SizedBox(height: 12),
                  ShimmerBox(width: 180, height: 12), 
                ],
              ),
            ],
          ), 
    
          const SizedBox(height: 24),

          // coachmode
          ShimmerBox(width: double.infinity, height: 150, radius: 24),
          const SizedBox(height: 24),

          // todayreminer
          ShimmerBox(width: double.infinity, height: 90, radius: 18),
          const SizedBox(height: 24),

          // today schedulereminder
          ShimmerBox(width: double.infinity, height: 90, radius: 18),
          const SizedBox(height: 24),

          // anaylss
          ShimmerBox(width: 120, height: 18),
          const SizedBox(height: 12),

          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _analyticItem(context),
                const SizedBox(width: 12),
                _analyticItem(context),
                const SizedBox(width: 12),
                _analyticItem(context),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // suggestion
          ShimmerBox(width: 160, height: 18),
          const SizedBox(height: 12),

          _suggestionCard(context),
          const SizedBox(height: 12),
          _suggestionCard(context),
          const SizedBox(height: 12),
          _suggestionCard(context),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _analyticItem(BuildContext context) {
    return ShimmerBox(width: 120, height: 140, radius: 20);
  }

  Widget _suggestionCard(BuildContext context) {
    return ShimmerBox(width: double.infinity, height: 110, radius: 18);
  }
}

