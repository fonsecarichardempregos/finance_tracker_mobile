import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/app_colors.dart';


Widget buildSkeleton() => const _HomeScreenSkeleton();

class _HomeScreenSkeleton extends StatefulWidget {
  const _HomeScreenSkeleton();

  @override
  State<_HomeScreenSkeleton> createState() => _HomeScreenSkeletonState();
}

class _HomeScreenSkeletonState extends State<_HomeScreenSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBodyBehindAppBar: true,
      floatingActionButton: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: _shimmerColor,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            _buildAppBarSkeleton(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildBalanceCardSkeleton(),
                    const SizedBox(height: 20),
                    _buildIncomeExpenseRowSkeleton(),
                    const SizedBox(height: 28),
                    _box(h: 16, w: 180),
                    const SizedBox(height: 16),
                    _buildChartSkeleton(),
                    const SizedBox(height: 28),
                    _box(h: 16, w: 160),
                    const SizedBox(height: 12),
                    ..._buildTransactionsSkeleton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarSkeleton() {
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
                _box(h: 22, w: 150),
                const SizedBox(height: 6),
                _box(h: 13, w: 200),
              ],
            ),
            const Spacer(),
            _glassButtonSkeleton(),
            const SizedBox(width: 12),
            _glassButtonSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _glassButtonSkeleton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _shimmerColor.withOpacity(0.6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.07)),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCardSkeleton() {
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
        border: Border.all(color: AppColors.accent.withOpacity(0.10), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _box(h: 13, w: 70),
              _box(h: 22, w: 90, r: 20),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _box(h: 22, w: 28),
              const SizedBox(width: 6),
              _box(h: 52, w: 160),
              const SizedBox(width: 4),
              _box(h: 28, w: 40),
            ],
          ),
          const SizedBox(height: 20),
          _box(h: 6, w: double.infinity, r: 8),
          const SizedBox(height: 8),
          _box(h: 12, w: 180),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseRowSkeleton() {
    return Row(
      children: [
        Expanded(child: _miniCardSkeleton()),
        const SizedBox(width: 12),
        Expanded(child: _miniCardSkeleton()),
      ],
    );
  }

  Widget _miniCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          _box(h: 36, w: 36, r: 10),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(h: 11, w: 50),
              const SizedBox(height: 5),
              _box(h: 14, w: 80),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSkeleton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
                _box(h: 180, w: 180, r: 90),
                Container(
                  width: 124,
                  height: 124,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _box(h: 18, w: 80),
                        const SizedBox(height: 5),
                        _box(h: 11, w: 55),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: List.generate(
              5,
                  (_) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _box(h: 8, w: 8, r: 4),
                  const SizedBox(width: 5),
                  _box(h: 12, w: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTransactionsSkeleton() {
    return List.generate(
      6,
          (_) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.04)),
        ),
        child: Row(
          children: [
            _box(h: 44, w: 44, r: 12),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(h: 15, w: 110),
                  const SizedBox(height: 5),
                  _box(h: 12, w: 80),
                ],
              ),
            ),
            _box(h: 15, w: 65),
          ],
        ),
      ),
    );
  }

  Color get _shimmerColor =>
      Color.lerp(AppColors.shimmerBase, AppColors.shimmerHigh, _anim.value)!;

  Widget _box({required double h, required double w, double r = 8}) {
    return Container(
      height: h,
      width: w == double.infinity ? null : w,
      decoration: BoxDecoration(
        color: _shimmerColor,
        borderRadius: BorderRadius.circular(r),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  buildError
// ─────────────────────────────────────────────
Widget buildError({
  required String message,
  required VoidCallback onRetry,
}) =>
    _HomeScreenError(message: message, onRetry: onRetry);

class _HomeScreenError extends StatelessWidget {
  const _HomeScreenError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentPink.withOpacity(0.10),
                  border: Border.all(
                    color: AppColors.accentPink.withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Text('😔', style: TextStyle(fontSize: 34)),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Algo deu errado',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 22,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF34D399), Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tentar novamente',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
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
}
