import 'package:flutter/material.dart';

class UserStatusBadge extends StatelessWidget {
  final bool isBlocked;
  final bool isBanned;

  const UserStatusBadge({
    required this.isBlocked,
    required this.isBanned,
  });

  @override
  Widget build(BuildContext context) {
    String text = 'Active';
    Color color = Colors.green;

    if (isBanned) {
      text = 'Banned';
      color = Colors.red;
    } else if (isBlocked) {
      text = 'Blocked';
      color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}