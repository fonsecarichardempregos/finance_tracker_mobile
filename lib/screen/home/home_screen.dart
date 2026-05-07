import 'dart:ui';
import 'package:finance_tracker_app/manager/user_manager.dart';
import 'package:finance_tracker_app/screen/menu/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../common/app_colors.dart';
import '../../manager/dashboard_manager.dart';
import '../../models/dashboard/recent_transaction_model.dart';
import '../add_transaction/add_transaction_screen.dart';
import '../notifications/notifications_screen.dart';
import 'home_states.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  int? _touchedIndex;


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
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardManager>().getDashboard(
        token: context.read<UserManager>().loginModel?.accessToken,
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardManager>(
      builder: (context, manager, _) {
        if (manager.isLoading) return buildSkeleton();
        if (manager.hasError)
          return buildError(
            message:
                manager.errorMessage ?? 'Não foi possível carregar os dados.',
            onRetry: () => context.read<DashboardManager>().getDashboard(
              token: context.read<UserManager>().loginModel?.accessToken,
            ),
          );
        return Scaffold(
          backgroundColor: AppColors.bg,
          extendBodyBehindAppBar: true,
          floatingActionButton: _buildFAB(),
          body: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: RefreshIndicator(
                onRefresh: () => context.read<DashboardManager>().getDashboard(
                  token: context.read<UserManager>().loginModel?.accessToken,
                ),

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
                            ...context
                                .read<DashboardManager>()
                                .dashboardModel!
                                .recentTransactions!
                                .map(_buildTransactionItem),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        ;
      },
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
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Olá, ${context.read<UserManager>().loginModel?.user?.fullName} 👋',
                  style: GoogleFonts.dmSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Veja como estão suas finanças',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Spacer(),
            _GlassButton(
              child: const Text(
                '🔔',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
            ),
            const SizedBox(width: 12),
            _GlassButton(
              child: const Text('📋', style: TextStyle(fontSize: 18)),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MenuScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    final manager  = context.read<DashboardManager>();
    final dashboard = manager.dashboardModel;
    final balance  = dashboard?.balance?.toDouble() ?? 0.0;
    final isNegative = balance < 0;

    final accentColor = isNegative
        ? const Color(0xFFF472B6)
        : const Color(0xFF34D399);

    final cardGradient = isNegative
        ? const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3D1020), Color(0xFF1C0810)],
    )
        : const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1E3A5F), Color(0xFF0F2440)],
    );

    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '',
      decimalDigits: 2,
    );

    final formatted   = formatter.format(balance.abs());
    final parts       = formatted.split(',');
    final intPart     = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '00';

    final progress = ((dashboard?.goalProgressPercent ?? 0) / 100)
        .clamp(0.0, 1.0)
        .toDouble();

    final hasGoal = dashboard?.goalTarget != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: cardGradient,
        border: Border.all(color: accentColor.withOpacity(0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.08),
            blurRadius: 30,
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
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              Row(
                children: [
                  if (isNegative)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF472B6).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'NEGATIVO',
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF472B6),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      dashboard?.month ??
                          DateFormat('MMMM yyyy', 'pt_BR')
                              .format(DateTime.now()),
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
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
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                intPart,
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 48,
                  color: isNegative
                      ? const Color(0xFFF472B6)
                      : AppColors.textPrimary,
                  height: 1,
                ),
              ),
              Text(
                ',$decimalPart',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 28,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.07),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasGoal
                ? '${dashboard!.goalProgressPercent!.toStringAsFixed(0)}% da meta mensal atingida'
                : 'Meta mensal não definida',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: isNegative
                  ? const Color(0xFFF472B6)
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseRow() {
    final dashboard = context.read<DashboardManager>().dashboardModel;

    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
      decimalDigits: 2,
    );

    return Row(
      children: [
        Expanded(
          child: _MiniCard(
            label: 'Receitas',
            value: formatter.format(
                dashboard?.monthIncome?.toDouble() ?? 0.0),
            icon: '↑',
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MiniCard(
            label: 'Gastos',
            value: formatter.format(
                dashboard?.monthExpense?.toDouble() ?? 0.0),
            icon: '↓',
            color: AppColors.accentPink,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildChart() {
    final dashboard = context.read<DashboardManager>().dashboardModel;
    final categories = dashboard?.expensesByCategory ?? [];
    final totalSpent = dashboard?.monthExpense?.toDouble() ?? 0.0;

    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
      decimalDigits: 0,
    );

    if (categories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text('📊', style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 12),
              Text(
                'Nenhum gasto registrado',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:AppColors.surface,
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
                          _touchedIndex =
                              response.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: categories.asMap().entries.map((e) {
                      final category  = e.value!;
                      final isTouched = e.key == _touchedIndex;
                      final color     = _hexToColor(category.color ?? '#94A3B8');
                      final pct       = category.percent?.toStringAsFixed(0) ?? '0';

                      return PieChartSectionData(
                        value:  category.amount?.toDouble() ?? 0,
                        color:  color,
                        radius: isTouched ? 46 : 38,
                        title:  isTouched ? '$pct%' : '',
                        titleStyle: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        borderSide: isTouched
                            ? BorderSide(color: color, width: 2)
                            : const BorderSide(color: Colors.transparent),
                      );
                    }).toList(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatter.format(totalSpent),
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'total gasto',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: AppColors.textSecondary,
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
            children: categories.map((c) {
              final color = _hexToColor(c?.color ?? '#94A3B8');
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    c?.name ?? '',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }
  Widget _buildTransactionItem(RecentTransactionModel? t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(t?.icon ?? '', style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t?.name ?? '',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${t?.category ?? ''} · ${t?.date ?? ''}',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${t?.type == 'income' ? '+' : ''}R\$ ${t?.amount?.abs()}',
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: t?.type == 'income' ? AppColors.accent : AppColors.accentPink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
      ),
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
              color: AppColors.accent.withOpacity(0.45),
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
