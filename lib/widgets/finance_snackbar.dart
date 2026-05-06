import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
//  FinancaSnackBar — combina com o design dark
//  do app (mesmo padrão de cores e widgets)
//
//  USO:
//  FinancaSnackBar.show(context,
//    message: 'Conta criada com sucesso!',
//    type: SnackBarType.success,
//  );
// ─────────────────────────────────────────────

enum SnackBarType { success, error, warning, info }

class FinancaSnackBar {
  // ── Paleta (mesma do app) ─────────────────
  static const _accent       = Color(0xFF34D399);
  static const _accentPink   = Color(0xFFF472B6);
  static const _accentYellow = Color(0xFFFBBF24);
  static const _accentBlue   = Color(0xFF60A5FA);
  static const _surface      = Color(0xFF131F35);
  static const _textPrimary  = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF64748B);

  static void show(
      BuildContext context, {
        required String message,
        SnackBarType type = SnackBarType.info,
        String? title,
        Duration duration = const Duration(seconds: 3),
      }) {
    // Remove qualquer snackbar aberto antes de exibir o novo
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        duration: duration,
        content: _FinancaSnackBarContent(
          message: message,
          title: title,
          type: type,
        ),
      ),
    );
  }

  // ── Atalhos semânticos ────────────────────
  static void success(BuildContext context, String message, {String? title}) =>
      show(context, message: message, type: SnackBarType.success, title: title);

  static void error(BuildContext context, String message, {String? title}) =>
      show(context, message: message, type: SnackBarType.error, title: title);

  static void warning(BuildContext context, String message, {String? title}) =>
      show(context, message: message, type: SnackBarType.warning, title: title);

  static void info(BuildContext context, String message, {String? title}) =>
      show(context, message: message, type: SnackBarType.info, title: title);
}

// ── Widget interno ────────────────────────────
class _FinancaSnackBarContent extends StatelessWidget {
  const _FinancaSnackBarContent({
    required this.message,
    required this.type,
    this.title,
  });

  final String message;
  final String? title;
  final SnackBarType type;

  // Config por tipo
  static const _configs = {
    SnackBarType.success: _SnackConfig(
      emoji: '✅',
      color: Color(0xFF34D399),
      gradient: [Color(0xFF0D2E20), Color(0xFF0B1C16)],
    ),
    SnackBarType.error: _SnackConfig(
      emoji: '❌',
      color: Color(0xFFFC8181),
      gradient: [Color(0xFF2E0D0D), Color(0xFF1C0B0B)],
    ),
    SnackBarType.warning: _SnackConfig(
      emoji: '⚠️',
      color: Color(0xFFFBBF24),
      gradient: [Color(0xFF2E240D), Color(0xFF1C160B)],
    ),
    SnackBarType.info: _SnackConfig(
      emoji: '💡',
      color: Color(0xFF60A5FA),
      gradient: [Color(0xFF0D1A2E), Color(0xFF0B121C)],
    ),
  };

  @override
  Widget build(BuildContext context) {
    final config = _configs[type]!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: config.gradient,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: config.color.withOpacity(0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: config.color.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Ícone ───────────────────────
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: config.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: config.color.withOpacity(0.2),
                  ),
                ),
                child: Center(
                  child: Text(
                    config.emoji,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // ── Texto ───────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: config.color,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      message,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFE2E8F0),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Barra lateral colorida ──────
              const SizedBox(width: 10),
              Container(
                width: 3,
                height: 36,
                decoration: BoxDecoration(
                  color: config.color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: config.color.withOpacity(0.6),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Config model ──────────────────────────────
class _SnackConfig {
  const _SnackConfig({
    required this.emoji,
    required this.color,
    required this.gradient,
  });
  final String emoji;
  final Color color;
  final List<Color> gradient;
}
