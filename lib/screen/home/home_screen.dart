import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  int? _touchedIndex;

  static const _bg = Color(0xFF0B1120);
  static const _surface = Color(0xFF131F35);
  static const _card = Color(0xFF1A2B45);
  static const _accent = Color(0xFF34D399);   // emerald
  static const _accentBlue = Color(0xFF60A5FA);
  static const _accentPink = Color(0xFFF472B6);
  static const _accentYellow = Color(0xFFFBBF24);
  static const _accentPurple = Color(0xFFA78BFA);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF64748B);

  final List<_Category> _categories = [
    _Category('Alimentação', 680, _accentBlue),
    _Category('Transporte', 320, _accent),
    _Category('Lazer', 210, _accentPink),
    _Category('Saúde', 150, _accentYellow),
    _Category('Outros', 190, _accentPurple),
  ];

  final List<_Transaction> _transactions = [
    _Transaction('Salário', 'Renda', 3000, true, '💼', 'Hoje'),
    _Transaction('Mercado', 'Alimentação', -120, false, '🛒', 'Hoje'),
    _Transaction('Uber', 'Transporte', -25, false, '🚗', 'Ontem'),
    _Transaction('Netflix', 'Lazer', -45, false, '🎬', 'Ontem'),
    _Transaction('Farmácia', 'Saúde', -38, false, '💊', '22 Mai'),
    _Transaction('Freelance', 'Renda', 800, true, '💻', '20 Mai'),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  double get _totalSpent =>
      _categories.fold(0, (sum, c) => sum + c.value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      extendBodyBehindAppBar: true,
      floatingActionButton: _buildFAB(),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildBalanceCard(),
                      const SizedBox(height: 20),
                      _buildIncomeExpenseRow(),
                      const SizedBox(height: 28),
                      _buildSectionTitle('Gastos por Categoria'),
                      const SizedBox(height: 16),
                      _buildChart(),
                      const SizedBox(height: 28),
                      _buildSectionTitle('Últimas Transações'),
                      const SizedBox(height: 12),
                      ..._transactions.map(_buildTransactionItem),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: 80,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1120), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 52, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Olá, Binho 👋',
                  style: GoogleFonts.dmSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                Text(
                  'Veja como estão suas finanças',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
            _GlassButton(
              child: const Text('🔔', style: TextStyle(fontSize: 18)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  // ── Balance Card ───────────────────────────
  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A5F), Color(0xFF0F2440)],
        ),
        border: Border.all(
          color: _accent.withOpacity(0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: _accent.withOpacity(0.08),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saldo Total',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: _textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${DateFormat('d \'de\' MMMM', 'pt_BR').format(DateTime.now())}',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: _accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 22,
                  color: _textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '2.450',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 48,
                  color: _textPrimary,
                  height: 1,
                ),
              ),
              Text(
                ',00',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 28,
                  color: _textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Mini progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.62,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.07),
              valueColor: const AlwaysStoppedAnimation<Color>(_accent),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '62% da meta mensal atingida',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Income / Expense Row ───────────────────
  Widget _buildIncomeExpenseRow() {
    return Row(
      children: [
        Expanded(
          child: _MiniCard(
            label: 'Receitas',
            value: 'R\$ 3.800',
            icon: '↑',
            color: _accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MiniCard(
            label: 'Gastos',
            value: 'R\$ 1.350',
            icon: '↓',
            color: _accentPink,
          ),
        ),
      ],
    );
  }

  // ── Section Title ──────────────────────────
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: _textPrimary,
        letterSpacing: 0.2,
      ),
    );
  }

  // ── Donut Chart ────────────────────────────
  Widget _buildChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sectionsSpace: 3,
                    centerSpaceRadius: 60,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          if (response == null ||
                              response.touchedSection == null) {
                            _touchedIndex = null;
                            return;
                          }
                          _touchedIndex = response
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: _categories.asMap().entries.map((e) {
                      final isTouched = e.key == _touchedIndex;
                      final pct = (e.value.value / _totalSpent * 100)
                          .toStringAsFixed(0);
                      return PieChartSectionData(
                        value: e.value.value,
                        color: e.value.color,
                        radius: isTouched ? 46 : 38,
                        title: isTouched ? '$pct%' : '',
                        titleStyle: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        borderSide: isTouched
                            ? BorderSide(color: e.value.color, width: 2)
                            : const BorderSide(color: Colors.transparent),
                      );
                    }).toList(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'R\$ ${_totalSpent.toStringAsFixed(0)}',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 20,
                        color: _textPrimary,
                      ),
                    ),
                    Text(
                      'total gasto',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _categories.map((c) => _LegendDot(category: c)).toList(),
          ),
        ],
      ),
    );
  }

  // ── Transaction Item ───────────────────────
  Widget _buildTransactionItem(_Transaction t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(t.icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.name,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${t.category} · ${t.date}',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${t.isIncome ? '+' : ''}R\$ ${t.amount.abs()}',
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: t.isIncome ? _accent : _accentPink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF34D399), Color(0xFF059669)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: _accent.withOpacity(0.45),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}


class _MiniCard extends StatelessWidget {
  const _MiniCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131F35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                icon,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE2E8F0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.category});
  final _Category category;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: category.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          category.name,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}


class _Category {
  const _Category(this.name, this.value, this.color);
  final String name;
  final double value;
  final Color color;
}

class _Transaction {
  const _Transaction(
    this.name,
    this.category,
    this.amount,
    this.isIncome,
    this.icon,
    this.date,
  );
  final String name;
  final String category;
  final double amount;
  final bool isIncome;
  final String icon;
  final String date;
}
