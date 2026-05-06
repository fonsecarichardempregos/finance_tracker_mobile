import 'package:dio/dio.dart';

// ─────────────────────────────────────────────
//  ApiErrorParser
//  Transforma erros da API em mensagens legíveis
//
//  Entrada:  {"Email": ["E-mail inválido"], "FullName": ["Nome obrigatório"]}
//  Saída:    "E-mail inválido\nNome obrigatório"
// ─────────────────────────────────────────────

class ApiErrorParser {
  /// Retorna uma string com todas as mensagens de erro
  /// separadas por quebra de linha.
  static String parse(DioException e) {
    final data = e.response?.data;

    if (data == null) return 'Erro de conexão. Tente novamente.';

    // ── Formato 1: erros de validação do .NET ──
    // { "Email": ["E-mail inválido"], "FullName": ["Nome obrigatório"] }
    if (data is Map) {
      // Tenta pegar o campo "errors" (padrão do ModelState do .NET)
      final errorsField = data['errors'] ?? data;

      if (errorsField is Map) {
        final messages = <String>[];

        errorsField.forEach((key, value) {
          if (value is List) {
            for (final msg in value) {
              if (msg is String && msg.isNotEmpty) {
                messages.add(msg);
              }
            }
          } else if (value is String && value.isNotEmpty) {
            messages.add(value);
          }
        });

        if (messages.isNotEmpty) return messages.join('\n');
      }

      // ── Formato 2: erro simples da API ──
      // { "code": "AUTH_EMAIL_EXISTS", "message": "Este e-mail já está cadastrado." }
      final message = data['message'] as String?;
      if (message != null && message.isNotEmpty) return message;
    }

    // ── Formato 3: string direto ──
    if (data is String && data.isNotEmpty) return data;

    // ── Fallback por status code ──────────────
    return _fallbackMessage(e.response?.statusCode);
  }

  /// Retorna uma lista de mensagens (útil para mostrar uma por linha)
  static List<String> parseAsList(DioException e) {
    final parsed = parse(e);
    return parsed.split('\n').where((s) => s.isNotEmpty).toList();
  }

  static String _fallbackMessage(int? statusCode) {
    return switch (statusCode) {
      400 => 'Dados inválidos. Verifique as informações.',
      401 => 'Não autorizado. Verifique suas credenciais.',
      403 => 'Acesso negado.',
      404 => 'Recurso não encontrado.',
      409 => 'Conflito com dados existentes.',
      422 => 'Dados inválidos.',
      500 => 'Erro interno no servidor. Tente novamente.',
      503 => 'Serviço indisponível. Tente mais tarde.',
      _   => 'Algo deu errado. Tente novamente.',
    };
  }
}
