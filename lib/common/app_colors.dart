import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color bg             = Color(0xFF0B1120);
  static const Color surface        = Color(0xFF131F35);
  static const Color card           = Color(0xFF1A2B45);

  static const Color accent         = Color(0xFF34D399);
  static const Color accentDark     = Color(0xFF059669);
  static const Color accentBlue     = Color(0xFF60A5FA);
  static const Color accentPink     = Color(0xFFF472B6);
  static const Color accentYellow   = Color(0xFFFBBF24);
  static const Color accentPurple   = Color(0xFFA78BFA);

  static const Color textPrimary    = Color(0xFFE2E8F0);
  static const Color textSecondary  = Color(0xFF64748B);
  static const Color textMuted      = Color(0xFF94A3B8);

  static const Color inputBorder    = Color(0xFF1E3A5F);
  static const Color shimmerBase    = Color(0xFF1A2B45);
  static const Color shimmerHigh    = Color(0xFF243652);
  static const Color error          = Color(0xFFFC8181);

  static const Color balancePositiveStart = Color(0xFF1E3A5F);
  static const Color balancePositiveEnd   = Color(0xFF0F2440);
  static const Color balanceNegativeStart = Color(0xFF3D1020);
  static const Color balanceNegativeEnd   = Color(0xFF1C0810);

  static LinearGradient get gradientPrimary => const LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get gradientBalancePositive => const LinearGradient(
    colors: [balancePositiveStart, balancePositiveEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get gradientBalanceNegative => const LinearGradient(
    colors: [balanceNegativeStart, balanceNegativeEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
