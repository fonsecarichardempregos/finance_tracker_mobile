import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
//  TELA DE ADICIONAR TRANSAÇÃO
// ─────────────────────────────────────────────

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with TickerProviderStateMixin {
  // ── Paleta ────────────────────────────────
  static const _bg = Color(0xFF0B1120);
  static const _surface = Color(0xFF131F35);
  static const _card = Color(0xFF1A2B45);
  static const _accent = Color(0xFF34D399);
  static const _accentPink = Color(0xFFF472B6);
  static const _accentBlue = Color(0xFF60A5FA);
  static const _accentYellow = Color(0xFFFBBF24);
  static const _accentPurple = Color(0xFFA78BFA);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF64748B);
  static const _errorColor = Color(0xFFFC8181);

  // ── Estado ────────────────────────────────
  bool _isExpense = true; // false = receita
  String _amount = '0';
  String? _selectedCategory;
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  String? _amountError;
  String? _categoryError;

  late AnimationController _fadeController;
  late AnimationController _typeController;
  late Animation<double> _fadeAnim;
  late Animation<double> _typeAnim;

  // ── Categorias ────────────────────────────
  final _expenseCategories = [
    _Category('Alimentação', '🛒', Color(0xFF60A5FA)),
    _Category('Transporte', '🚗', Color(0xFF34D399)),
    _Category('Lazer', '🎬', Color(0xFFF472B6)),
    _Category('Saúde', '💊', Color(0xFFFBBF24)),
    _Category('Moradia', '🏠', Color(0xFFA78BFA)),
    _Category('Educação', '📚', Color(0xFF60A5FA)),
    _Category('Vestuário', '👕', Color(0xFFF472B6)),
    _Category('Outros', '📦', Color(0xFF94A3B8)),
  ];

  final _incomeCategories = [
    _Category('Salário', '💼', Color(0xFF34D399)),
    _Category('Freelance', '💻', Color(0xFF60A5FA)),
    _Category('Investimentos', '📈', Color(0xFFFBBF24)),
    _Category('Presente', '🎁', Color(0xFFF472B6)),
    _Category('Outros', '📦', Color(0xFF94A3B8)),
  ];

  List<_Category> get _categories =>
      _isExpense ? _expenseCategories : _incomeCategories;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _typeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _typeAnim =
        CurvedAnimation(parent: _typeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _typeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // ── Teclado numérico ─────────────────────
  void _onKeyTap(String key) {
    setState(() {
      if (key == '⌫') {
        if (_amount.length > 1) {
          _amount = _amount.substring(0, _amount.length - 1);
        } else {
          _amount = '0';
        }
      } else if (key == ',') {
        if (!_amount.contains(',')) _amount += ',';
      } else {
        if (_amount == '0') {
          _amount = key;
        } else if (_amount.contains(',') &&
            _amount.split(',').last.length >= 2) {
          return;
        } else {
          _amount += key;
        }
      }
      _amountError = null;
    });
  }

  String get _displayAmount {
    final parts = _amount.split(',');
    final intPart = int.tryParse(parts[0]) ?? 0;
    final formatted = intPart.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.');
    return parts.length > 1 ? '$formatted,${parts[1]}' : formatted;
  }

  // ── Submit ────────────────────────────────
  Future<void> _submit() async {
    bool ok = true;
    setState(() {
      final val = double.tryParse(_amount.replaceAll(',', '.')) ?? 0;
      _amountError = val <= 0 ? 'Informe um valor válido' : null;
      _categoryError =
          _selectedCategory == null ? 'Selecione uma categoria' : null;
      if (_amountError != null || _categoryError != null) ok = false;
    });
    if (!ok) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Simula sucesso — troque pela sua lógica
    const success = true;
    _showResultSheet(success: success);
  }

  void _showResultSheet({required bool success}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => _TransactionResultSheet(
        success: success,
        isExpense: _isExpense,
        amount: _displayAmount,
        category: _selectedCategory ?? '',
        onAction: () {
          Navigator.pop(context); // fecha sheet
          if (success) Navigator.pop(context); // volta pro dashboard
        },
      ),
    );
  }

  // ── Build ─────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      resizeToAvoidBottomInset: false,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            SafeArea(child: _buildHeader()),
            _buildTypeSelector(),
            _buildAmountDisplay(),
            if (_amountError != null) _buildAmountError(),
            _buildDatePill(),
            Expanded(child: _buildBottomPanel()),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: Colors.white.withOpacity(0.07)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: _textPrimary, size: 15),
            ),
          ),
          const SizedBox(width: 14),
          Text('Nova transação',
              style: GoogleFonts.dmSerifDisplay(
                  fontSize: 20, color: _textPrimary)),
        ],
      ),
    );
  }

  // ── Type Selector ─────────────────────────
  Widget _buildTypeSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        height: 46,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            _TypeTab(
              label: 'Despesa',
              icon: '↓',
              selected: _isExpense,
              selectedColor: _accentPink,
              onTap: () {
                if (!_isExpense) {
                  setState(() {
                    _isExpense = true;
                    _selectedCategory = null;
                  });
                  _typeController
                    ..reset()
                    ..forward();
                }
              },
            ),
            _TypeTab(
              label: 'Receita',
              icon: '↑',
              selected: !_isExpense,
              selectedColor: _accent,
              onTap: () {
                if (_isExpense) {
                  setState(() {
                    _isExpense = false;
                    _selectedCategory = null;
                  });
                  _typeController
                    ..reset()
                    ..forward();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Amount Display ────────────────────────
  Widget _buildAmountDisplay() {
    final color = _isExpense ? _accentPink : _accent;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        children: [
          Text(
            _isExpense ? 'Quanto você gastou?' : 'Quanto você recebeu?',
            style: GoogleFonts.dmSans(
                fontSize: 13, color: _textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('R\$',
                  style: GoogleFonts.dmSerifDisplay(
                      fontSize: 24, color: _textSecondary)),
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: _amount.length > 6 ? 42 : 56,
                  color: color,
                  height: 1,
                ),
                child: Text(_displayAmount),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountError() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 13, color: _errorColor),
          const SizedBox(width: 4),
          Text(_amountError!,
              style: GoogleFonts.dmSans(
                  fontSize: 12, color: _errorColor)),
        ],
      ),
    );
  }

  // ── Date Pill ─────────────────────────────
  Widget _buildDatePill() {
    final formatted =
        '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}';
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2020),
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
          if (picked != null) setState(() => _selectedDate = picked);
        },
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 14, color: _textSecondary),
              const SizedBox(width: 6),
              Text(formatted,
                  style: GoogleFonts.dmSans(
                      fontSize: 13, color: _textSecondary)),
              const SizedBox(width: 4),
              const Icon(Icons.expand_more_rounded,
                  size: 14, color: _textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom Panel ──────────────────────────
  Widget _buildBottomPanel() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 10, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection(),
                  const SizedBox(height: 20),
                  _buildDescriptionField(),
                  const SizedBox(height: 20),
                  _buildNumpad(),
                  const SizedBox(height: 16),
                  _buildSaveButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Categorias ────────────────────────────
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Categoria',
                style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _textSecondary)),
            if (_categoryError != null) ...[
              const SizedBox(width: 8),
              const Icon(Icons.error_outline_rounded,
                  size: 13, color: _errorColor),
              const SizedBox(width: 3),
              Text(_categoryError!,
                  style: GoogleFonts.dmSans(
                      fontSize: 12, color: _errorColor)),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((c) {
            final selected = _selectedCategory == c.name;
            return GestureDetector(
              onTap: () => setState(() {
                _selectedCategory = c.name;
                _categoryError = null;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? c.color.withOpacity(0.18)
                      : _card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? c.color.withOpacity(0.5)
                        : Colors.white.withOpacity(0.06),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(c.icon,
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(c.name,
                        style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: selected
                                ? c.color
                                : _textSecondary)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Descrição ─────────────────────────────
  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Descrição (opcional)',
            style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _textSecondary)),
        const SizedBox(height: 8),
        TextField(
          controller: _descController,
          style: GoogleFonts.dmSans(color: _textPrimary, fontSize: 14),
          cursorColor: _accent,
          decoration: InputDecoration(
            hintText: 'Ex: Almoço com amigos',
            hintStyle:
                GoogleFonts.dmSans(color: _textSecondary, fontSize: 14),
            prefixIcon: const Icon(Icons.notes_rounded,
                color: _textSecondary, size: 20),
            filled: true,
            fillColor: const Color(0xFF0F1E33),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                  color: Color(0xFF1E3A5F), width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: _accent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ── Numpad ────────────────────────────────
  Widget _buildNumpad() {
    const keys = [
      ['7', '8', '9'],
      ['4', '5', '6'],
      ['1', '2', '3'],
      [',', '0', '⌫'],
    ];
    return Column(
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: row.map((key) {
              final isBackspace = key == '⌫';
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onKeyTap(key),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: row.indexOf(key) == 1 ? 8 : 0),
                    height: 52,
                    decoration: BoxDecoration(
                      color: isBackspace
                          ? _accentPink.withOpacity(0.1)
                          : _card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isBackspace
                            ? _accentPink.withOpacity(0.2)
                            : Colors.white.withOpacity(0.06),
                      ),
                    ),
                    child: Center(
                      child: isBackspace
                          ? const Icon(Icons.backspace_outlined,
                              color: _accentPink, size: 20)
                          : Text(key,
                              style: GoogleFonts.dmSerifDisplay(
                                  fontSize: 22,
                                  color: _textPrimary)),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  // ── Save Button ───────────────────────────
  Widget _buildSaveButton() {
    final color = _isExpense ? _accentPink : _accent;
    final darkColor =
        _isExpense ? const Color(0xFFBE185D) : const Color(0xFF059669);
    return GestureDetector(
      onTap: _isLoading ? null : _submit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isLoading
                ? [
                    color.withOpacity(0.3),
                    darkColor.withOpacity(0.3)
                  ]
                : [color, darkColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: _isLoading
              ? []
              : [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: _isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: color,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isExpense
                          ? Icons.remove_circle_outline_rounded
                          : Icons.add_circle_outline_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isExpense
                          ? 'Registrar despesa'
                          : 'Registrar receita',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── Type Tab ──────────────────────────────────
class _TypeTab extends StatelessWidget {
  const _TypeTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });
  final String label;
  final String icon;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: selected
                ? selectedColor.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: selected
                ? Border.all(
                    color: selectedColor.withOpacity(0.35), width: 1)
                : null,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(icon,
                      style: TextStyle(
                          fontSize: 14,
                          color: selected
                              ? selectedColor
                              : const Color(0xFF64748B),
                          fontWeight: FontWeight.w900)),
                  const SizedBox(width: 6),
                  Text(label,
                      style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: selected
                              ? selectedColor
                              : const Color(0xFF64748B))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Result Bottom Sheet ───────────────────────
class _TransactionResultSheet extends StatelessWidget {
  const _TransactionResultSheet({
    required this.success,
    required this.isExpense,
    required this.amount,
    required this.category,
    required this.onAction,
  });
  final bool success;
  final bool isExpense;
  final String amount;
  final String category;
  final VoidCallback onAction;

  static const _surface = Color(0xFF131F35);
  static const _accent = Color(0xFF34D399);
  static const _accentPink = Color(0xFFF472B6);
  static const _errorColor = Color(0xFFFC8181);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final typeColor = isExpense ? _accentPink : _accent;
    final color = success ? typeColor : _errorColor;
    final emoji = success ? (isExpense ? '💸' : '💰') : '😔';
    final title = success
        ? (isExpense ? 'Despesa registrada!' : 'Receita registrada!')
        : 'Erro ao registrar';
    final subtitle = success
        ? 'R\$ $amount em $category\nfoi salvo com sucesso.'
        : 'Não foi possível salvar a transação.\nTente novamente.';

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
            margin: const EdgeInsets.only(bottom: 28),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
              border:
                  Border.all(color: color.withOpacity(0.3), width: 1.5),
            ),
            child: Center(
                child: Text(emoji,
                    style: const TextStyle(fontSize: 36))),
          ),
          const SizedBox(height: 20),
          Text(title,
              style: GoogleFonts.dmSerifDisplay(
                  fontSize: 26, color: _textPrimary)),
          const SizedBox(height: 8),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                  fontSize: 14, color: _textSecondary, height: 1.6)),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: onAction,
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: success
                      ? (isExpense
                          ? [
                              const Color(0xFFF472B6),
                              const Color(0xFFBE185D)
                            ]
                          : [
                              const Color(0xFF34D399),
                              const Color(0xFF059669)
                            ])
                      : [
                          const Color(0xFFFC8181),
                          const Color(0xFFE53E3E)
                        ],
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
                  success ? 'Voltar ao início' : 'Tentar novamente',
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

// ── Category Model ────────────────────────────
class _Category {
  const _Category(this.name, this.icon, this.color);
  final String name;
  final String icon;
  final Color color;
}
