import 'package:flutter/material.dart';

class StatusIcon extends StatelessWidget {
  final String imagePath; // local asset path like 'assets/images/profile.jpg'
  final bool isSeen;

  const StatusIcon({
    super.key,
    required this.imagePath,
    this.isSeen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSeen ? Colors.grey : Colors.blue,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 15,
        backgroundImage: AssetImage(imagePath),
      ),
    );
  }
}
