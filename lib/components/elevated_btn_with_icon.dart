import 'package:flutter/material.dart';

class ElevatedButtonWithIcon extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;

  const ElevatedButtonWithIcon({required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(50, 50), // Adjust size as needed
        primary: onPressed == null
            ? Colors.grey
            : Colors.blue, // Set color based on enabled/disabled state
        onSurface: Colors.grey, // Color when the button is disabled
      ),
      child: Center(
        child: Icon(
          icon,
          size: 24, // Adjust icon size as needed
          color: Colors.white, // Icon color
        ),
      ),
    );
  }
}
