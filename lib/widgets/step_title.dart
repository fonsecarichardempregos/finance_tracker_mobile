import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepTitle extends StatelessWidget {
  const StepTitle({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  final String emoji;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 10),
        Text(
          title,
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 22,
            color: const Color(0xFFE2E8F0),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: const Color(0xFF64748B),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
