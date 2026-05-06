import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF64748B),
        letterSpacing: 0.3,
      ),
    );
  }
}
