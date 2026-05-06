import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({required this.password});

  final String password;

  static const _accent = Color(0xFF34D399);
  static const _accentYellow = Color(0xFFFBBF24);
  static const _errorColor = Color(0xFFFC8181);
  static const _textSecondary = Color(0xFF64748B);

  int get _strength {
    if (password.length < 3) return 0;
    if (password.length < 6) return 1;
    if (password.length < 10 ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[0-9]')))
      return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();
    final labels = ['Fraca', 'Regular', 'Boa', 'Forte'];
    final colors = [_errorColor, _accentYellow, _accentYellow, _accent];
    final s = _strength;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(3, (i) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: i < s ? colors[s] : Colors.white.withOpacity(0.08),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'Força: ${labels[s]}',
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: s == 0 ? _textSecondary : colors[s],
          ),
        ),
      ],
    );
  }
}
