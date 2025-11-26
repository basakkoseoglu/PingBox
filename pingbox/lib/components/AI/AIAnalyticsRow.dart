import 'package:flutter/material.dart';
import 'AIAnalyticsCard.dart';

class AIAnalyticsRow extends StatelessWidget {
  final String activeHour;
  final String topCategory;
  final String mood;

  const AIAnalyticsRow({
    super.key,
    required this.activeHour,
    required this.topCategory,
    required this.mood,
  });

IconData getCategoryIcon(String category) {
  final c = category.toLowerCase();

  if (c.contains("su")) return Icons.water_drop;
  if (c.contains("sağlık")) return Icons.favorite;
  if (c.contains("spor")) return Icons.fitness_center;
  if (c.contains("alışveriş")) return Icons.shopping_bag;
  if (c.contains("proje")) return Icons.work;
  if (c.contains("aile")) return Icons.family_restroom;
  if (c.contains("odak")) return Icons.center_focus_strong;
  if (c.contains("not")) return Icons.note_alt;
  if (c.contains("hatırlatma")) return Icons.notifications;
  if (c.contains("beslenme")) return Icons.restaurant_menu;
  if (c.contains("enerji")) return Icons.bolt;
  if (c.contains("plan")) return Icons.edit_calendar;

  return Icons.category; 
}


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          AIAnalyticsCard(
            title: "En aktif saat",
            value: activeHour,
            icon: Icons.av_timer,
            mode: mood,
          ),
          SizedBox(width: 8,),

          AIAnalyticsCard(
            title: "Kategori",
            value: topCategory,
            icon: getCategoryIcon(topCategory),
            mode: mood,
          ),
          SizedBox(width: 8,),

          AIAnalyticsCard(
            title: "Ruh hali",
            value: mood,
            icon: Icons.favorite,
            mode: mood,
          ),
        ],
      ),
    );
  }
}
