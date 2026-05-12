import 'package:flutter/material.dart';

import '../models/support_request.dart';
import '../services/backend_orchestrator.dart';
import '../theme.dart';
import 'volunteer_admin_page.dart';

class AccessibilityPage extends StatefulWidget {
  const AccessibilityPage({super.key});

  @override
  State<AccessibilityPage> createState() => _AccessibilityPageState();
}

class _AccessibilityPageState extends State<AccessibilityPage> {
  final _orchestrator = BackendOrchestrator.instance;
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _triggerSOS() async {
    await _run(() async {
      final result = await _orchestrator.triggerSOS();
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('SOS'),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _startSafeCall() async {
    await _run(() async {
      final result = await _orchestrator.startSafeCall();
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Güvenli Arama'),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _quickSupport() async {
    await _run(() async {
      final user = _orchestrator.getCurrentUser();
      final req = SupportRequest(
        id: 'sr_${DateTime.now().millisecondsSinceEpoch}',
        requesterName: user.name,
        requestType: 'Hızlı Destek',
        description: 'Hızlı destek prototipi: kısa yardım ihtiyacı.',
        status: 'Açık',
        assignedVolunteerName: null,
      );
      final updated = await _orchestrator.createSupportRequest(req);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Destek Talebi'),
          content: Text(
            'Destek talebi oluşturuldu ve en uygun gönüllü eşleştirildi.\n\n'
            'Durum: ${updated.status}\n'
            'Gönüllü: ${updated.assignedVolunteerName ?? '-'}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Erişilebilirlik ve Hızlı Destek',
                style: TextStyle(
                  color: YanYanaColors.textDark,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Acil durum, güvenli iletişim ve erişilebilir etkileşim prototipleri.',
                style: TextStyle(
                  color: YanYanaColors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              _sectionCard(
                title: 'Acil / Güvenli İletişim',
                icon: Icons.shield_rounded,
                color: YanYanaColors.sos,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GradientButton(
                            label: _busy ? '...' : 'SOS',
                            icon: Icons.emergency_share_rounded,
                            gradient: sosGradient,
                            onPressed: _busy ? () {} : _triggerSOS,
                            height: 52,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GradientButton(
                            label: _busy ? '...' : 'Güvenli Arama',
                            icon: Icons.call_rounded,
                            gradient: primaryGradient,
                            onPressed: _busy ? () {} : _startSafeCall,
                            height: 52,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        label: _busy ? '...' : 'Hızlı Destek',
                        icon: Icons.volunteer_activism_rounded,
                        gradient: supportGradient,
                        onPressed: _busy ? () {} : _quickSupport,
                        height: 52,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _sectionCard(
                title: 'Erişilebilirlik Özellikleri',
                icon: Icons.accessibility_new_rounded,
                color: YanYanaColors.secondary,
                child: Column(
                  children: const [
                    _FeatureTile(
                      icon: Icons.menu_book_rounded,
                      title: 'Sesli Betimlemeli Okuma',
                      desc: 'Metin okuma prototipi (gerçek TTS yok).',
                      badge: 'Prototype',
                    ),
                    Divider(height: 18, color: YanYanaColors.divider),
                    _FeatureTile(
                      icon: Icons.mic_rounded,
                      title: 'Sesli Komut Sistemi',
                      desc: 'Kısa komutlarla gezinme (planlanan).',
                      badge: 'Future Integration',
                    ),
                    Divider(height: 18, color: YanYanaColors.divider),
                    _FeatureTile(
                      icon: Icons.closed_caption_rounded,
                      title: 'Canlı Altyazı Desteği',
                      desc: 'Prototip akışı (gerçek canlı altyazı yok).',
                      badge: 'Prototype',
                    ),
                    Divider(height: 18, color: YanYanaColors.divider),
                    _FeatureTile(
                      icon: Icons.vibration_rounded,
                      title: 'Titreşimli Geri Bildirim',
                      desc: 'UI geri bildirimi (mock).',
                      badge: 'MVP',
                    ),
                    Divider(height: 18, color: YanYanaColors.divider),
                    _FeatureTile(
                      icon: Icons.notifications_active_rounded,
                      title: 'Push Notification Prototype',
                      desc: 'Bildirim gönderimi mock servisi ile simüle edilir.',
                      badge: 'Prototype',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VolunteerAdminPage()),
                    );
                  },
                  icon: const Icon(Icons.admin_panel_settings_rounded),
                  label: const Text(
                    'Gönüllü Yönetimi',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: YanYanaColors.primary,
                    side: const BorderSide(color: YanYanaColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: YanYanaColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: YanYanaShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 19),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: YanYanaColors.textDark,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final String badge;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.desc,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    switch (badge) {
      case 'MVP':
        badgeColor = YanYanaColors.success;
        break;
      case 'Future Integration':
        badgeColor = YanYanaColors.warning;
        break;
      default:
        badgeColor = YanYanaColors.accentBlue;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: badgeColor, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: YanYanaColors.textDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: badgeColor.withOpacity(0.18)),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: YanYanaColors.textDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                desc,
                style: const TextStyle(
                  color: YanYanaColors.textMuted,
                  fontSize: 12.5,
                  height: 1.35,
                ),
              ),
              if (title == 'Sesli Betimlemeli Okuma') ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sesli okuma prototip olarak simüle edildi.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.volume_up_rounded),
                  label: const Text(
                    'Metni Oku',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: YanYanaColors.primary,
                    side: const BorderSide(color: YanYanaColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

