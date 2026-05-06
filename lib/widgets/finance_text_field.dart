import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class FinanceTextField extends StatelessWidget {
  const FinanceTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.error,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? error;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  static const _accent = Color(0xFF34D399);
  static const _errorColor = Color(0xFFFC8181);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          style: GoogleFonts.dmSans(color: _textPrimary, fontSize: 15),
          cursorColor: _accent,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.dmSans(color: _textSecondary, fontSize: 15),
            prefixIcon: Icon(icon, color: _textSecondary, size: 20),
            suffixIcon: suffixIcon != null
                ? Padding(
              padding: const EdgeInsets.only(right: 4),
              child: suffixIcon,
            )
                : null,
            filled: true,
            fillColor: const Color(0xFF0F1E33),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: error != null
                    ? _errorColor.withOpacity(0.6)
                    : const Color(0xFF1E3A5F),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: error != null ? _errorColor : _accent,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 13,
                color: _errorColor,
              ),
              const SizedBox(width: 4),
              Text(
                error!,
                style: GoogleFonts.dmSans(fontSize: 12, color: _errorColor),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
