import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../login/login_screen.dart';

// ─────────────────────────────────────────────
//  TELA DE MENU / PERFIL
// ─────────────────────────────────────────────

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {


  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  // Dados do usuário (substituir por dados reais)
  final _user = _UserData(
    name: 'Binho Santos',
    email: 'binho@email.com',
    phone: '(51) 99999-9999',
    initials: 'BS',
    memberSince: 'Membro desde Mai 2025',
  );

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _confirmLogout() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _LogoutSheet(
        onConfirm: () {
          Navigator.pop(context); // fecha sheet
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => const LoginScreen(),
              transitionsBuilder: (_, anim, __, child) =>
                  FadeTransition(opacity: anim, child: child),
            ),
            (route) => false,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Column(
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 24),
                    _buildStatsRow(),
                    const SizedBox(height: 28),
                    _buildMenuSection('Conta', [
                      _MenuItem('Editar Perfil', '✏️', AppColors.accentBlue,
                          () {}),
                      _MenuItem('Segurança', '🔐', AppColors.accentPurple, () {}),
                      _MenuItem(
                          'Notificações', '🔔', AppColors.accentYellow, () {}),
                    ]),
                    const SizedBox(height: 16),
                    _buildMenuSection('Preferências', [
                      _MenuItem('Moeda & Região', '🌎', AppColors.accentBlue,
                          () {}),
                      _MenuItem('Aparência', '🎨', AppColors.accentPink, () {}),
                      _MenuItem('Exportar dados', '📤', AppColors.accent, () {}),
                    ]),
                    const SizedBox(height: 16),
                    _buildMenuSection('Suporte', [
                      _MenuItem('Ajuda & FAQ', '❓', AppColors.accentBlue, () {}),
                      _MenuItem('Fale conosco', '💬', AppColors.accent, () {}),
                      _MenuItem('Avaliar o app', '⭐', AppColors.accentYellow,
                          () {}),
                    ]),
                    const SizedBox(height: 24),
                    _buildLogoutButton(),
                    const SizedBox(height: 16),
                    Text(
                      'Finança v1.0.0',
                      style: GoogleFonts.dmSans(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.bg,
      pinned: true,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.07)),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 15),
        ),
      ),
      title: Text('Perfil',
          style: GoogleFonts.dmSerifDisplay(
              fontSize: 20, color: AppColors.textPrimary)),
    );
  }

  // ── Profile Card ──────────────────────────
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A5F), Color(0xFF0F2440)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.accent.withOpacity(0.2), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF34D399), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(_user.initials,
                      style: GoogleFonts.dmSerifDisplay(
                          fontSize: 22, color: Colors.white)),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF0F2440), width: 2),
                  ),
                  child: const Icon(Icons.check,
                      size: 10, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_user.name,
                    style: GoogleFonts.dmSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 3),
                Text(_user.email,
                    style: GoogleFonts.dmSans(
                        fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_user.memberSince,
                      style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.edit_outlined,
                  size: 16, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Row ─────────────────────────────
  Widget _buildStatsRow() {
    return Row(
      children: [
        _StatCard(label: 'Transações', value: '47', icon: '🔁',
            color: AppColors.accentBlue),
        const SizedBox(width: 10),
        _StatCard(label: 'Categorias', value: '8', icon: '🏷️',
            color: AppColors.accentPurple),
        const SizedBox(width: 10),
        _StatCard(label: 'Meses', value: '3', icon: '📅',
            color: AppColors.accentYellow),
      ],
    );
  }

  // ── Menu Section ──────────────────────────
  Widget _buildMenuSection(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 4),
          child: Text(title,
              style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.4)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              return _buildMenuItem(e.value, isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(_MenuItem item, bool isLast) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                      color: Colors.white.withOpacity(0.05))),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Center(
                  child: Text(item.icon,
                      style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(item.label,
                  style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary)),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Color(0xFF3D5A7A)),
          ],
        ),
      ),
    );
  }

  // ── Logout Button ─────────────────────────
  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: _confirmLogout,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: AppColors.error.withOpacity(0.2), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded,
                color: Color(0xFFFC8181), size: 20),
            const SizedBox(width: 10),
            Text('Sair da conta',
                style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFC8181))),
          ],
        ),
      ),
    );
  }

}

// ── Logout Sheet ──────────────────────────────
class _LogoutSheet extends StatelessWidget {
  const _LogoutSheet({required this.onConfirm});
  final VoidCallback onConfirm;

  static const _surface = Color(0xFF131F35);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF64748B);
  static const _errorColor = Color(0xFFFC8181);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Text('🚪', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 16),
          Text('Sair da conta?',
              style: GoogleFonts.dmSerifDisplay(
                  fontSize: 24, color: _textPrimary)),
          const SizedBox(height: 8),
          Text(
            'Você precisará fazer login novamente\npara acessar sua conta.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
                fontSize: 14, color: _textSecondary, height: 1.6),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Center(
                      child: Text('Cancelar',
                          style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _textPrimary)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: _errorColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: _errorColor.withOpacity(0.3), width: 1.2),
                    ),
                    child: Center(
                      child: Text('Sair',
                          style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _errorColor)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Modelos ───────────────────────────────────
class _UserData {
  const _UserData({
    required this.name,
    required this.email,
    required this.phone,
    required this.initials,
    required this.memberSince,
  });
  final String name;
  final String email;
  final String phone;
  final String initials;
  final String memberSince;
}

class _MenuItem {
  const _MenuItem(this.label, this.icon, this.color, this.onTap);
  final String label;
  final String icon;
  final Color color;
  final VoidCallback onTap;
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});
  final String label;
  final String value;
  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF131F35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 6),
            Text(value,
                style: GoogleFonts.dmSerifDisplay(
                    fontSize: 20,
                    color: const Color(0xFFE2E8F0))),
            const SizedBox(height: 2),
            Text(label,
                style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: const Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }
}
