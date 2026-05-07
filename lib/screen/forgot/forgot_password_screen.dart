import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../common/api_error_parse.dart';
import '../../manager/user_manager.dart';
import '../../widgets/bloob.dart';
import '../../widgets/field_lable.dart';
import '../../widgets/finance_snackbar.dart';
import '../../widgets/finance_text_field.dart';
import '../../widgets/password_strength_bar.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/result_sheet.dart';
import '../../widgets/step_title.dart';
import '../login/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  static const _bg = Color(0xFF0B1120);
  static const _surface = Color(0xFF131F35);
  static const _accent = Color(0xFF34D399);
  static const _accentPink = Color(0xFFF472B6);
  static const _accentBlue = Color(0xFF60A5FA);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF64748B);

  int _step = 0;
  bool _isLoading = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final _emailController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final List<TextEditingController> _codeControllers = List.generate(
    6,
        (_) => TextEditingController(),
  );
  final List<FocusNode> _codeFocusNodes = List.generate(6, (_) => FocusNode());

  String? _emailError;
  String? _codeError;
  String? _newPassError;
  String? _confirmPassError;

  late AnimationController _stepController;
  late Animation<Offset> _stepSlide;

  @override
  void initState() {
    super.initState();
    _stepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _stepSlide = Tween<Offset>(begin: const Offset(0.07, 0), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _stepController, curve: Curves.easeOutCubic),
    );
    _stepController.forward();
  }

  @override
  void dispose() {
    _stepController.dispose();
    _emailController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    for (final c in _codeControllers) {
      c.dispose();
    }
    for (final f in _codeFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _goNext() async {
    if (_step == 0) {
      final emailReg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailReg.hasMatch(_emailController.text.trim())) {
        setState(() => _emailError = 'E-mail inválido');
        return;
      }
      setState(() => _isLoading = true);

      try {
        await context.read<UserManager>().sendCodeResetPassword(
          email: _emailController.text,
        );

        if (!mounted) return;
      } on DioException catch (e) {
        if (!mounted) return;
        final message = ApiErrorParser.parse(e);
        FinancaSnackBar.error(context, message);
        return;
      } catch (e) {
        if (!mounted) return;
        FinancaSnackBar.error(context, 'Algo deu errado. Tente novamente.');
        return;
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }

      setState(() => _emailError = null);
    } else if (_step == 1) {
      final code = _codeControllers.map((c) => c.text).join();
      if (code.length < 6) {
        setState(() => _codeError = 'Digite o código completo');
        return;
      }

      setState(() => _codeError = null);

      setState(() => _isLoading = true);

      try {
        await context.read<UserManager>().verifyCodeResetPassword(
          email: _emailController.text,
          code: code,
        );

        if (!mounted) return;
      } on DioException catch (e) {
        if (!mounted) return;
        final message = ApiErrorParser.parse(e);
        FinancaSnackBar.error(context, message);
        return;
      } catch (e) {
        if (!mounted) return;
        FinancaSnackBar.error(context, 'Algo deu errado. Tente novamente.');
        return;
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }

    if (_step < 2) {
      _simulateRequest(() {
        setState(() => _step++);
        _stepController
          ..reset()
          ..forward();
      });
    } else {
      if (_newPassController.text.length < 6) {
        setState(() => _newPassError = 'Mínimo de 6 caracteres');
        return;
      }
      if (_newPassController.text != _confirmPassController.text) {
        setState(() => _confirmPassError = 'As senhas não coincidem');
        return;
      }
      setState(() {
        _newPassError = null;
        _confirmPassError = null;
      });


      try {
        await context.read<UserManager>().resetPassword(
          newPassword: _newPassController.text,
          confirmNewPassword: _confirmPassController.text,
        );

        if (!mounted) return;
        _showResultSheet(
          success: true,
          subTitleError: 'erro teste precisa colocar a api',
        );

      } on DioException catch (e) {
        if (!mounted) return;
        final message = ApiErrorParser.parse(e);
        FinancaSnackBar.error(context, message);
        return;
      } catch (e) {
        if (!mounted) return;
        FinancaSnackBar.error(context, 'Algo deu errado. Tente novamente.');
        return;
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }


Future<void> _simulateRequest(VoidCallback onDone) async {
  setState(() => _isLoading = true);
  await Future.delayed(const Duration(milliseconds: 1400));
  if (!mounted) return;
  setState(() => _isLoading = false);
  onDone();
}

void _showResultSheet({
  required bool success,
  required String subTitleError,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    builder: (_) =>
        ResultSheet(
          subTitleError: subTitleError,
          success: success,
          isPasswordReset: true,
          onAction: () {
            Navigator.pop(context);
            if (success) {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (_, __, ___) => const LoginScreen(),
                  transitionsBuilder: (_, anim, __, child) =>
                      FadeTransition(opacity: anim, child: child),
                ),
              );
            }
          },
        ),
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: _bg,
    resizeToAvoidBottomInset: true,
    body: Stack(
      children: [
        _buildBlobs(),
        SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  child: SlideTransition(
                    position: _stepSlide,
                    child: Column(
                      children: [
                        _buildStepCard(),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          label: _step == 2 ? 'Redefinir senha' : 'Continuar',
                          isLoading: _isLoading,
                          onTap: _goNext,
                        ),
                        if (_step == 1) ...[
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Reenviar código',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                color: _accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            if (_step > 0) {
              setState(() => _step--);
              _stepController
                ..reset()
                ..forward();
            } else {
              Navigator.pop(context);
            }
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.07)),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _textPrimary,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recuperar senha',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 22,
                color: _textPrimary,
              ),
            ),
            Text(
              ['Informe o e-mail', 'Verifique o código', 'Nova senha'][_step],
              style: GoogleFonts.dmSans(fontSize: 12, color: _textSecondary),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildStepCard() {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: _surface,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: Colors.white.withOpacity(0.06)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 40,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: [_buildEmailStep, _buildCodeStep, _buildNewPassStep][_step](),
  );
}

// Etapa 1 — E-mail
Widget _buildEmailStep() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StepTitle(
        emoji: '📧',
        title: 'Esqueceu a senha?',
        subtitle: 'Sem problema! Informe seu e-mail e enviaremos um código.',
      ),
      const SizedBox(height: 24),
      FieldLabel('E-mail cadastrado'),
      const SizedBox(height: 8),
      FinanceTextField(
        controller: _emailController,
        hint: 'seu@email.com',
        icon: Icons.email_outlined,
        error: _emailError,
        keyboardType: TextInputType.emailAddress,
      ),
    ],
  );
}

// Etapa 2 — Código
Widget _buildCodeStep() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StepTitle(
        emoji: '📬',
        title: 'Digite o código',
        subtitle:
        'Enviamos um código de 6 dígitos para\n${_emailController.text}',
      ),
      const SizedBox(height: 28),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (i) {
          return SizedBox(
            width: 44,
            height: 54,
            child: TextField(
              controller: _codeControllers[i],
              focusNode: _codeFocusNodes[i],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 22,
                color: const Color(0xFFE2E8F0),
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: const Color(0xFF0F1E33),
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF1E3A5F),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _accent, width: 1.8),
                ),
              ),
              onChanged: (val) {
                if (val.isNotEmpty && i < 5) {
                  _codeFocusNodes[i + 1].requestFocus();
                } else if (val.isEmpty && i > 0) {
                  _codeFocusNodes[i - 1].requestFocus();
                }
                setState(() => _codeError = null);
              },
            ),
          );
        }),
      ),
      if (_codeError != null) ...[
        const SizedBox(height: 10),
        Text(
          _codeError!,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: const Color(0xFFFC8181),
          ),
        ),
      ],
    ],
  );
}

// Etapa 3 — Nova senha
Widget _buildNewPassStep() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StepTitle(
        emoji: '🔑',
        title: 'Crie nova senha',
        subtitle: 'Escolha uma senha segura para sua conta.',
      ),
      const SizedBox(height: 24),
      FieldLabel('Nova senha'),
      const SizedBox(height: 8),
      FinanceTextField(
        controller: _newPassController,
        hint: '••••••••',
        icon: Icons.lock_outline_rounded,
        error: _newPassError,
        obscureText: _obscureNew,
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _obscureNew = !_obscureNew),
          child: Icon(
            _obscureNew
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: _textSecondary,
            size: 20,
          ),
        ),
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: 12),
      PasswordStrengthBar(password: _newPassController.text),
      const SizedBox(height: 18),
      FieldLabel('Confirmar nova senha'),
      const SizedBox(height: 8),
      FinanceTextField(
        controller: _confirmPassController,
        hint: '••••••••',
        icon: Icons.lock_outline_rounded,
        error: _confirmPassError,
        obscureText: _obscureConfirm,
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
          child: Icon(
            _obscureConfirm
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: _textSecondary,
            size: 20,
          ),
        ),
      ),
    ],
  );
}

Widget _buildBlobs() {
  return Stack(
    children: [
      Positioned(
        top: -60,
        right: -80,
        child: Blob(color: _accent.withOpacity(0.10), size: 240),
      ),
      Positioned(
        bottom: 80,
        left: -100,
        child: Blob(color: _accentBlue.withOpacity(0.08), size: 280),
      ),
    ],
  );
}}
