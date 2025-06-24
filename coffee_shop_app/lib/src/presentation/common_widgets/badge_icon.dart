
import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  const BadgeIcon({
    super.key,
    required this.icon,
    required this.count,
    this.badgeColor = Colors.red,
    this.textColor = Colors.white,
  });

  final IconData icon;
  final int count;
  final Color badgeColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) {
      return Icon(icon);
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Center(
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: TextStyle(color: textColor, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}