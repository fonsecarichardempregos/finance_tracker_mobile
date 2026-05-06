import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
//  TELA DE NOTIFICAÇÕES
// ─────────────────────────────────────────────

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  // ── Paleta ────────────────────────────────
  static const _bg = Color(0xFF0B1120);
  static const _surface = Color(0xFF131F35);
  static const _card = Color(0xFF1A2B45);
  static const _accent = Color(0xFF34D399);
  static const _accentBlue = Color(0xFF60A5FA);
  static const _accentPink = Color(0xFFF472B6);
  static const _accentYellow = Color(0xFFFBBF24);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF64748B);

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  final List<_Notification> _notifications = [
    _Notification(
      id: '1',
      title: 'Salário recebido!',
      body: 'Uma entrada de R\$ 3.000,00 foi registrada na sua conta.',
      time: 'Agora',
      icon: '💼',
      color: Color(0xFF34D399),
      type: NotifType.transaction,
      isRead: false,
    ),
    _Notification(
      id: '2',
      title: 'Meta quase atingida',
      body: 'Você já usou 88% do seu limite de gastos com Alimentação este mês.',
      time: '2h atrás',
      icon: '⚠️',
      color: Color(0xFFFBBF24),
      type: NotifType.alert,
      isRead: false,
    ),
    _Notification(
      id: '3',
      title: 'Nova despesa registrada',
      body: 'Mercado — R\$ 120,00 foi adicionado às suas despesas.',
      time: '5h atrás',
      icon: '🛒',
      color: Color(0xFF60A5FA),
      type: NotifType.transaction,
      isRead: false,
    ),
    _Notification(
      id: '4',
      title: 'Dica financeira',
      body: 'Você gasta em média R\$ 680/mês com alimentação. Que tal revisar esse orçamento?',
      time: 'Ontem',
      icon: '💡',
      color: Color(0xFFA78BFA),
      type: NotifType.tip,
      isRead: true,
    ),
    _Notification(
      id: '5',
      title: 'Resumo semanal',
      body: 'Esta semana você gastou R\$ 340,00. Confira o relatório completo.',
      time: 'Ontem',
      icon: '📊',
      color: Color(0xFF60A5FA),
      type: NotifType.summary,
      isRead: true,
    ),
    _Notification(
      id: '6',
      title: 'Uber — R\$ 25,00',
      body: 'Despesa de transporte registrada com sucesso.',
      time: '2 dias atrás',
      icon: '🚗',
      color: Color(0xFF34D399),
      type: NotifType.transaction,
      isRead: true,
    ),
    _Notification(
      id: '7',
      title: 'Lembrete de conta',
      body: 'Você tem uma conta de internet vencendo em 3 dias.',
      time: '3 dias atrás',
      icon: '🔔',
      color: Color(0xFFF472B6),
      type: NotifType.alert,
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

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

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _dismissNotification(String id) {
    setState(() => _notifications.removeWhere((n) => n.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            if (_notifications.isEmpty)
              SliverFillRemaining(child: _buildEmpty())
            else ...[
              if (_unreadCount > 0) _buildSection('Novas', _unreadCount),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    final unread =
                        _notifications.where((n) => !n.isRead).toList();
                    if (i >= unread.length) return null;
                    return _buildItem(unread[i]);
                  },
                  childCount:
                      _notifications.where((n) => !n.isRead).length,
                ),
              ),
              _buildSection('Anteriores', null),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    final read =
                        _notifications.where((n) => n.isRead).toList();
                    if (i >= read.length) return null;
                    return _buildItem(read[i]);
                  },
                  childCount:
                      _notifications.where((n) => n.isRead).length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: _bg,
      pinned: true,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.07)),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _textPrimary, size: 15),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notificações',
              style: GoogleFonts.dmSerifDisplay(
                  fontSize: 20, color: _textPrimary)),
          if (_unreadCount > 0)
            Text('$_unreadCount não lidas',
                style: GoogleFonts.dmSans(
                    fontSize: 12, color: _accent)),
        ],
      ),
      actions: [
        if (_unreadCount > 0)
          GestureDetector(
            onTap: _markAllRead,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: _accent.withOpacity(0.25), width: 1),
              ),
              child: Text('Ler todas',
                  style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: _accent,
                      fontWeight: FontWeight.w600)),
            ),
          ),
      ],
    );
  }

  Widget _buildSection(String title, int? count) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Row(
          children: [
            Text(title,
                style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _textSecondary,
                    letterSpacing: 0.5)),
            if (count != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('$count',
                    style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: _accent,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItem(_Notification notif) {
    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.redAccent, size: 22),
      ),
      onDismissed: (_) => _dismissNotification(notif.id),
      child: GestureDetector(
        onTap: () => setState(() => notif.isRead = true),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notif.isRead
                ? _surface
                : _surface.withRed((_surface.red + 10).clamp(0, 255)),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: notif.isRead
                  ? Colors.white.withOpacity(0.05)
                  : notif.color.withOpacity(0.2),
              width: 1.2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: notif.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: Text(notif.icon,
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(notif.title,
                              style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: notif.isRead
                                      ? FontWeight.w500
                                      : FontWeight.w700,
                                  color: _textPrimary)),
                        ),
                        const SizedBox(width: 8),
                        if (!notif.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: notif.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(notif.body,
                        style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: _textSecondary,
                            height: 1.5)),
                    const SizedBox(height: 6),
                    Text(notif.time,
                        style: GoogleFonts.dmSans(
                            fontSize: 11, color: _textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🔔', style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text('Tudo em dia!',
              style: GoogleFonts.dmSerifDisplay(
                  fontSize: 24, color: _textPrimary)),
          const SizedBox(height: 8),
          Text('Nenhuma notificação por aqui.',
              style:
                  GoogleFonts.dmSans(fontSize: 14, color: _textSecondary)),
        ],
      ),
    );
  }
}

// ── Model ─────────────────────────────────────
enum NotifType { transaction, alert, tip, summary }

class _Notification {
  _Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.color,
    required this.type,
    required this.isRead,
  });
  final String id;
  final String title;
  final String body;
  final String time;
  final String icon;
  final Color color;
  final NotifType type;
  bool isRead;
}
