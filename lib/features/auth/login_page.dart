import 'package:flutter/material.dart';
import 'package:yanyana_p/core/services/backend_orchestrator.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/features/home/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              SizedBox(
                height: 540,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _LoginForm(tabController: _tabController),
                    const _RegisterForm(),
                  ],
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 32),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: YanYanaShadows.card,
      ),
      child: Column(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.diversity_1_rounded,
              color: Colors.white,
              size: 44,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'YanYana',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Güvenli, erişilebilir ve destekleyici bir topluluk',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 0),
      child: Container(
        height: 54,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: YanYanaColors.surfaceSoft,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: YanYanaColors.border),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            gradient: supportGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: YanYanaShadows.soft,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: YanYanaColors.textMuted,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Giriş Yap'),
            Tab(text: 'Kayıt Ol'),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 8),
      child: Text(
        'Gizlilik Politikası · Kullanım Koşulları',
        style: TextStyle(
          color: YanYanaColors.textMuted.withOpacity(0.7),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  final TabController tabController;

  const _LoginForm({required this.tabController});

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await BackendOrchestrator.instance.authService.signInWithEmailAndPassword(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );
      if (!mounted) return;
      setState(() => _loading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            YanYanaTextField(
              controller: _emailCtrl,
              label: 'E-posta',
              hint: 'ornek@mail.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'E-posta boş bırakılamaz';
                }
                if (!v.contains('@')) {
                  return 'Geçerli bir e-posta girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            YanYanaTextField(
              controller: _passCtrl,
              label: 'Şifre',
              hint: 'En az 8 karakter',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscure,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: YanYanaColors.textMuted,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Şifre boş bırakılamaz';
                }
                if (v.length < 8) {
                  return 'Şifre en az 8 karakter olmalı';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: YanYanaColors.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Şifremi Unuttum',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            GradientButton(
              label: 'Giriş Yap',
              icon: Icons.arrow_forward_rounded,
              isLoading: _loading,
              onPressed: _login,
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hesabın yok mu? ',
                  style: TextStyle(
                    color: YanYanaColors.textMuted,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () => widget.tabController.animateTo(1),
                  child: const Text(
                    'Kayıt Ol',
                    style: TextStyle(
                      color: YanYanaColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  String _role = 'disabled_user';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await BackendOrchestrator.instance.authService.registerWithEmailAndPassword(
        _nameCtrl.text.trim(),
        _emailCtrl.text.trim(),
        _passCtrl.text,
        _role,
      );
      if (!mounted) return;
      setState(() => _loading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _RoleChip(
                  label: 'Kullanıcı',
                  icon: Icons.accessibility_new_rounded,
                  selected: _role == 'disabled_user',
                  color: YanYanaColors.primary,
                  onTap: () => setState(() => _role = 'disabled_user'),
                ),
                const SizedBox(width: 10),
                _RoleChip(
                  label: 'Gönüllü',
                  icon: Icons.volunteer_activism_rounded,
                  selected: _role == 'volunteer',
                  color: YanYanaColors.secondary,
                  onTap: () => setState(() => _role = 'volunteer'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            YanYanaTextField(
              controller: _nameCtrl,
              label: 'Ad Soyad',
              hint: 'Adınızı girin',
              icon: Icons.person_outline_rounded,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Ad soyad boş bırakılamaz';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            YanYanaTextField(
              controller: _emailCtrl,
              label: 'E-posta',
              hint: 'ornek@mail.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'E-posta boş bırakılamaz';
                }
                if (!v.contains('@')) {
                  return 'Geçerli bir e-posta girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            YanYanaTextField(
              controller: _passCtrl,
              label: 'Şifre',
              hint: 'En az 8 karakter',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscurePass,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: YanYanaColors.textMuted,
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _obscurePass = !_obscurePass);
                },
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Şifre boş bırakılamaz';
                }
                if (v.length < 8) {
                  return 'Şifre en az 8 karakter olmalı';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            YanYanaTextField(
              controller: _confirmCtrl,
              label: 'Şifre Tekrar',
              hint: 'Şifrenizi tekrar girin',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: YanYanaColors.textMuted,
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _obscureConfirm = !_obscureConfirm);
                },
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Şifre tekrar boş bırakılamaz';
                }
                if (v != _passCtrl.text) {
                  return 'Şifreler eşleşmiyor';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            GradientButton(
              label: 'Kayıt Ol',
              icon: Icons.person_add_alt_1_rounded,
              isLoading: _loading,
              onPressed: _register,
              gradient: supportGradient,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: selected ? color : YanYanaColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? Colors.transparent : YanYanaColors.border,
            ),
            boxShadow: selected ? YanYanaShadows.soft : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : YanYanaColors.textMuted,
                size: 22,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : YanYanaColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}