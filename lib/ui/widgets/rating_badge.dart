import 'package:flutter/material.dart';

class RatingBadge extends StatelessWidget {
  final double avgRating;
  final bool noFriendRated;
  const RatingBadge({super.key, required this.avgRating, required this.noFriendRated});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(Icons.star,
              size: 12, color: noFriendRated ? Colors.blue : Colors.amber),
          const SizedBox(width: 2),
          Text(
            avgRating.toStringAsFixed(1),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
