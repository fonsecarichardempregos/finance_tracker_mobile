import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultSheet extends StatelessWidget {
  const ResultSheet({
    required this.success,
    required this.onAction,
    required this.subTitleError,
    this.isPasswordReset = false,
  });

  final bool success;
  final VoidCallback onAction;
  final bool isPasswordReset;
  final String subTitleError;

  static const _accent = Color(0xFF34D399);
  static const _errorColor = Color(0xFFFC8181);
  static const _surface = Color(0xFF131F35);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final color = success ? _accent : _errorColor;
    final emoji = success ? '🎉' : '😔';
    final title = success
        ? (isPasswordReset ? 'Senha redefinida!' : 'Conta criada!')
        : 'Algo deu errado';
    final subtitle = success
        ? (isPasswordReset
        ? 'Sua senha foi alterada com sucesso.\nFaça login com a nova senha.'
        : 'Bem-vindo ao Finança!\nSua conta foi criada com sucesso.')
        : subTitleError;
    final btnLabel = success ? 'Ir para o login' : 'Tentar novamente';

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          // Ícone animado
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
              border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 26,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: _textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: onAction,
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: success
                      ? [const Color(0xFF34D399), const Color(0xFF059669)]
                      : [const Color(0xFFFC8181), const Color(0xFFE53E3E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  btnLabel,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
