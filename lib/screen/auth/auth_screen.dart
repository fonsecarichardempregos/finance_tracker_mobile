import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../common/api_error_parse.dart';
import '../../common/date_formate.dart';
import '../../manager/user_manager.dart';
import '../../widgets/bloob.dart';
import '../../widgets/field_lable.dart';
import '../../widgets/finance_snackbar.dart';
import '../../widgets/finance_text_field.dart';
import '../../widgets/password_strength_bar.dart';
import '../../widgets/phone_mask.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/result_sheet.dart';
import '../../widgets/step_title.dart';
import '../login/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  static const _bg = Color(0xFF0B1120);
  static const _surface = Color(0xFF131F35);
  static const _accent = Color(0xFF34D399);
  static const _accentPink = Color(0xFFF472B6);
  static const _accentBlue = Color(0xFF60A5FA);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF64748B);
  static const _errorColor = Color(0xFFFC8181);

  int _currentStep = 0;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _phoneError;
  String? _birthError;

  late AnimationController _fadeController;
  late AnimationController _stepController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _stepSlide;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _stepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _stepSlide = Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _stepController, curve: Curves.easeOutCubic),
        );
    _fadeController.forward();
    _stepController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _stepController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  // ── Validações ────────────────────────────
  bool _validateStep1() {
    bool ok = true;
    setState(() {
      _nameError = _nameController.text.trim().length < 3
          ? 'Informe seu nome completo'
          : null;
      final emailReg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      _emailError = !emailReg.hasMatch(_emailController.text.trim())
          ? 'E-mail inválido'
          : null;
      if (_nameError != null || _emailError != null) ok = false;
    });
    return ok;
  }

  bool _validateStep2() {
    bool ok = true;
    setState(() {
      _passwordError = _passwordController.text.length < 6
          ? 'Mínimo de 6 caracteres'
          : null;
      _confirmError = _confirmController.text != _passwordController.text
          ? 'As senhas não coincidem'
          : null;
      if (_passwordError != null || _confirmError != null) ok = false;
    });
    return ok;
  }

  bool _validateStep3() {
    bool ok = true;
    setState(() {
      final phoneClean = _phoneController.text.replaceAll(RegExp(r'\D'), '');
      _phoneError = phoneClean.length < 10 ? 'Telefone inválido' : null;
      _birthError = _birthController.text.isEmpty
          ? 'Informe sua data de nascimento'
          : null;
      if (_phoneError != null || _birthError != null) ok = false;
    });
    return ok;
  }

  void _nextStep() {
    final valid = _currentStep == 0
        ? _validateStep1()
        : _currentStep == 1
        ? _validateStep2()
        : _validateStep3();
    if (!valid) return;
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _stepController
        ..reset()
        ..forward();
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _stepController
        ..reset()
        ..forward();
    }
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      await context.read<UserManager>().createUser(
        fullName:_nameController.text,
        email: _emailController.text,
        password: _phoneController.text,
        phone: _phoneController.text,
        birthDate: DateFormatter.toIsoDate(_birthController.text),
      );



      print('192831093801298 ');

      if (!mounted) return;
      FinancaSnackBar.success(context, 'Bem-vindo ao Finança!\nSua conta foi criada com sucesso.');
      await Future.delayed(Duration(milliseconds: 200));

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          _buildBlobs(),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                children: [
                  _buildHeader(),
                  _buildStepper(),
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
                            _buildButtons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          if (_currentStep > 0)
            GestureDetector(
              onTap: _prevStep,
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
            )
          else
            GestureDetector(
              onTap: () => Navigator.pop(context),
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
                'Criar conta',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 22,
                  color: _textPrimary,
                ),
              ),
              Text(
                'Etapa ${_currentStep + 1} de 3',
                style: GoogleFonts.dmSans(fontSize: 12, color: _textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    const labels = ['Dados', 'Senha', 'Contato'];
    const icons = ['👤', '🔐', '📱'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
      child: Row(
        children: List.generate(3, (i) {
          final done = i < _currentStep;
          final active = i == _currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: done || active
                              ? _accent
                              : Colors.white.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            done ? '✓ ' : '${icons[i]} ',
                            style: TextStyle(
                              fontSize: 11,
                              color: done
                                  ? _accent
                                  : active
                                  ? _textPrimary
                                  : _textSecondary,
                            ),
                          ),
                          Text(
                            labels[i],
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              fontWeight: active
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: done
                                  ? _accent
                                  : active
                                  ? _textPrimary
                                  : _textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (i < 2) const SizedBox(width: 4),
              ],
            ),
          );
        }),
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
      child: [_buildStep1, _buildStep2, _buildStep3][_currentStep](),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepTitle(
          emoji: '👤',
          title: 'Quem é você?',
          subtitle: 'Vamos começar pelo básico',
        ),
        const SizedBox(height: 24),
        FieldLabel('Nome completo'),
        const SizedBox(height: 8),
        FinanceTextField(
          controller: _nameController,
          hint: 'Ex: Binho Santos',
          icon: Icons.person_outline_rounded,
          error: _nameError,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 18),
        FieldLabel('E-mail'),
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

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepTitle(
          emoji: '🔐',
          title: 'Crie sua senha',
          subtitle: 'Mínimo de 6 caracteres',
        ),
        const SizedBox(height: 24),
        FieldLabel('Senha'),
        const SizedBox(height: 8),
        FinanceTextField(
          controller: _passwordController,
          hint: '••••••••',
          icon: Icons.lock_outline_rounded,
          error: _passwordError,
          obscureText: _obscurePassword,
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: _textSecondary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 18),
        FieldLabel('Confirmar senha'),
        const SizedBox(height: 8),
        FinanceTextField(
          controller: _confirmController,
          hint: '••••••••',
          icon: Icons.lock_outline_rounded,
          error: _confirmError,
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
        const SizedBox(height: 16),
        PasswordStrengthBar(password: _passwordController.text),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepTitle(
          emoji: '📱',
          title: 'Dados de contato',
          subtitle: 'Quase lá! Só mais um passo.',
        ),
        const SizedBox(height: 24),
        FieldLabel('Telefone'),
        const SizedBox(height: 8),
        FinanceTextField(
          controller: _phoneController,
          hint: '(51) 99999-9999',
          icon: Icons.phone_outlined,
          error: _phoneError,
          keyboardType: TextInputType.phone,
          inputFormatters: [PhoneMask()],
        ),
        const SizedBox(height: 18),
        FieldLabel('Data de nascimento'),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1920),
              lastDate: DateTime.now(),
              builder: (ctx, child) => Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: _accent,
                    onPrimary: Colors.black,
                    surface: Color(0xFF1A2B45),
                    onSurface: _textPrimary,
                  ),
                  dialogBackgroundColor: const Color(0xFF131F35),
                ),
                child: child!,
              ),
            );
            if (picked != null) {
              _birthController.text =
                  '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
              setState(() => _birthError = null);
            }
          },
          child: AbsorbPointer(
            child: FinanceTextField(
              controller: _birthController,
              hint: 'dd/mm/aaaa',
              icon: Icons.cake_outlined,
              error: _birthError,
              suffixIcon: const Icon(
                Icons.calendar_month_outlined,
                color: Color(0xFF64748B),
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    final isLast = _currentStep == 2;
    return PrimaryButton(
      label: isLast ? 'Criar conta' : 'Continuar',
      isLoading: _isLoading,
      onTap: _nextStep,
    );
  }

  // ── Background ────────────────────────────
  Widget _buildBlobs() {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -80,
          child: Blob(color: _accentBlue.withOpacity(0.10), size: 240),
        ),
        Positioned(
          bottom: 80,
          right: -100,
          child: Blob(color: _accentPink.withOpacity(0.08), size: 280),
        ),
      ],
    );
  }
}
