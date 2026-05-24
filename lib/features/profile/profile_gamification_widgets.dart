// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:yanyana_p/core/services/backend_orchestrator.dart';
import 'package:yanyana_p/core/services/physio_notification_service.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/shared/models/app_user.dart';

// =======================================================================
// Rozet Tanımları
// =======================================================================
class BadgeDef {
  final String id;
  final String emoji;
  final String name;
  final String desc;
  final int points;
  const BadgeDef({
    required this.id,
    required this.emoji,
    required this.name,
    required this.desc,
    required this.points,
  });
}

const allBadges = <BadgeDef>[
  BadgeDef(id: 'first_login',       emoji: '🌟', name: 'İlk Adım',           desc: 'Platforma hoş geldiniz! İlk girişiniz kaydedildi.',            points: 10),
  BadgeDef(id: 'profile_complete',  emoji: '✅', name: 'Tam Profil',          desc: 'Profilinizi %100 tamamladınız.',                               points: 50),
  BadgeDef(id: 'first_post',        emoji: '💬', name: 'İlk Paylaşım',        desc: 'İlk topluluk gönderinizi paylaştınız.',                         points: 25),
  BadgeDef(id: 'helper',            emoji: '🤝', name: 'Yardımsever',         desc: 'Topluluğa en az 5 kez yardım ettiniz.',                        points: 75),
  BadgeDef(id: 'invisible_warrior', emoji: '🛡️', name: 'Görünmez Savaşçı',   desc: 'Görünmez engel profilinizi tanımladınız. Cesursunuz!',          points: 30),
  BadgeDef(id: 'physio_streak',     emoji: '💪', name: 'Tedavi Şampiyonu',    desc: '7 gün arka arkaya fizik tedavi egzersizi tamamladınız!',       points: 100),
];

BadgeDef? badgeDefById(String id) {
  try { return allBadges.firstWhere((b) => b.id == id); } catch (_) { return null; }
}

// =======================================================================
// GamificationSection
// =======================================================================
class GamificationSection extends StatelessWidget {
  final AppUser user;
  final ValueChanged<AppUser> onBadgeAwarded;

  const GamificationSection({super.key, required this.user, required this.onBadgeAwarded});

  @override
  Widget build(BuildContext context) {
    final earned = user.badges.where((id) => badgeDefById(id) != null).toList();
    return _card(
      title: 'Puanlar & Rozetler',
      icon: Icons.emoji_events_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Puan banner ──
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFA78BFA)], begin: Alignment.centerLeft, end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Text('⭐', style: TextStyle(fontSize: 26)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${user.points} Puan', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                    Text('${earned.length} rozet kazanıldı', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                const Spacer(),
                _levelBadge(user.points),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Rozetlerin', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: YanYanaColors.textDark)),
          const SizedBox(height: 10),
          // Kazanılan rozetler
          if (earned.isEmpty)
            const Text('Henüz rozet kazanılmadı. Profili tamamla, gönderi paylaş!', style: TextStyle(color: YanYanaColors.textMuted, fontSize: 13))
          else
            Wrap(
              spacing: 10, runSpacing: 10,
              children: earned.map((id) {
                final def = badgeDefById(id);
                return GestureDetector(
                  onTap: () => _showBadgeDialog(context, def, id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: YanYanaColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: YanYanaColors.primary.withValues(alpha: 0.25))),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [Text(def?.emoji ?? '🏅', style: const TextStyle(fontSize: 18)), const SizedBox(width: 6), Text(def?.name ?? id, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: YanYanaColors.primary))]),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: YanYanaColors.border),
          const SizedBox(height: 12),
          const Text('Kazanılabilecek Rozetler', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: YanYanaColors.textDark)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10, runSpacing: 10,
            children: allBadges.map((def) {
              final has = earned.contains(def.id);
              return GestureDetector(
                onTap: () => _showBadgeDialog(context, def, def.id),
                child: AnimatedOpacity(
                  opacity: has ? 1.0 : 0.35,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                    decoration: BoxDecoration(
                      color: has ? YanYanaColors.primary.withValues(alpha: 0.1) : YanYanaColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: has ? YanYanaColors.primary.withValues(alpha: 0.3) : YanYanaColors.border),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(def.emoji, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 5),
                      Text(def.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: has ? YanYanaColors.primary : YanYanaColors.textMuted)),
                      const SizedBox(width: 4),
                      Text('+${def.points}p', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: YanYanaColors.accentYellow)),
                    ]),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showBadgeDialog(BuildContext context, BadgeDef? def, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(def?.emoji ?? '🏅', style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(def?.name ?? id, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(def?.desc ?? '', style: const TextStyle(color: YanYanaColors.textMuted, fontSize: 14), textAlign: TextAlign.center),
            if (def != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(color: YanYanaColors.accentYellow.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                child: Text('+${def.points} puan', style: const TextStyle(fontWeight: FontWeight.w800, color: YanYanaColors.warning, fontSize: 14)),
              ),
            ],
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))],
      ),
    );
  }

  Widget _levelBadge(int points) {
    String level; Color color;
    if (points < 50) { level = 'Başlangıç'; color = const Color(0xFF94A3B8); }
    else if (points < 150) { level = 'Bronz'; color = const Color(0xFFCD7F32); }
    else if (points < 350) { level = 'Gümüş'; color = const Color(0xFF94A3B8); }
    else if (points < 700) { level = 'Altın'; color = const Color(0xFFFBBF24); }
    else { level = 'Elmas'; color = const Color(0xFF60A5FA); }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.5))),
      child: Text(level, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }
}

// =======================================================================
// InvisibleDisabilityBadgesSection
// =======================================================================
class InvisibleDisabilityBadgesSection extends StatefulWidget {
  final AppUser user;
  final ValueChanged<AppUser> onSaved;
  final ValueChanged<AppUser> onBadgeAwarded;

  const InvisibleDisabilityBadgesSection({super.key, required this.user, required this.onSaved, required this.onBadgeAwarded});

  @override
  State<InvisibleDisabilityBadgesSection> createState() => _InvDisabState();
}

class _InvDisabState extends State<InvisibleDisabilityBadgesSection> {
  bool _isSaving = false;

  static const _items = [
    ('🧠', 'Kronik Ağrı',          'Görünmez ama her gün hissedilen ağrı'),
    ('💙', 'Anksiyete / Depresyon', 'Ruh sağlığı engeli'),
    ('⚡', 'Yorgunluk Sendromu',    'ME/CFS, fibromiyalji vb.'),
    ('🎭', 'Otizm Spektrumu',       'Nöroçeşitlilik'),
    ('🩺', 'Kronik Hastalık',       'Diyabet, lupus, Crohn vb.'),
    ('🌊', 'PTSD / Travma',         'Travma sonrası stres bozukluğu'),
    ('🧩', 'ADHD',                  'Dikkat eksikliği ve hiperaktivite'),
  ];

  static const _prefix = 'inv_';

  Set<String> get _selected => widget.user.accessibilityNeeds.where((n) => n.startsWith(_prefix)).toSet();

  Future<void> _toggle(String label) async {
    final current = Set<String>.from(widget.user.accessibilityNeeds);
    final key = '$_prefix$label';
    current.contains(key) ? current.remove(key) : current.add(key);
    setState(() => _isSaving = true);
    try {
      final updated = await BackendOrchestrator.instance.updateProfile(accessibilityNeeds: current.toList());
      widget.onSaved(updated);
      if (current.any((k) => k.startsWith(_prefix))) {
        final badged = await BackendOrchestrator.instance.awardBadge('invisible_warrior');
        widget.onBadgeAwarded(badged);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    return _card(
      title: 'Görünmez Engel Profili',
      icon: Icons.shield_moon_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(14), border: Border.all(color: YanYanaColors.accentPurple.withValues(alpha: 0.3))),
            child: const Row(children: [
              Text('🛡️', style: TextStyle(fontSize: 20)),
              SizedBox(width: 10),
              Expanded(child: Text('Görünmez engeller dışarıdan belli olmaz, ama her gün yaşanır. Profilinde göstermek istediklerini seç — destek eşleşmeni iyileştirir.', style: TextStyle(color: Color(0xFF5B21B6), fontSize: 12, fontWeight: FontWeight.w600, height: 1.4))),
            ]),
          ),
          const SizedBox(height: 14),
          if (_isSaving)
            const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()))
          else
            Wrap(
              spacing: 10, runSpacing: 10,
              children: _items.map((item) {
                final emoji = item.$1; final label = item.$2; final desc = item.$3;
                final key = '$_prefix$label';
                final on = selected.contains(key);
                return GestureDetector(
                  onLongPress: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      content: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(emoji, style: const TextStyle(fontSize: 36)),
                        const SizedBox(height: 8),
                        Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(height: 6),
                        Text(desc, textAlign: TextAlign.center, style: const TextStyle(color: YanYanaColors.textMuted, fontSize: 13)),
                      ]),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat'))],
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: on ? const Color(0xFF7C3AED).withValues(alpha: 0.12) : YanYanaColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: on ? const Color(0xFF7C3AED).withValues(alpha: 0.5) : YanYanaColors.border, width: on ? 1.5 : 1),
                    ),
                    child: InkWell(
                      onTap: () => _toggle(label),
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(emoji, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: on ? const Color(0xFF5B21B6) : YanYanaColors.textMuted)),
                          if (on) ...[const SizedBox(width: 4), const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF7C3AED))],
                        ]),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 10),
          const Text('Uzun basınca açıklama görünür. Seçimler otomatik kaydedilir.', style: TextStyle(color: YanYanaColors.textLight, fontSize: 11)),
        ],
      ),
    );
  }
}

// =======================================================================
// PhysioReminderSection
// =======================================================================
class PhysioReminderSection extends StatefulWidget {
  final AppUser user;
  const PhysioReminderSection({super.key, required this.user});
  @override
  State<PhysioReminderSection> createState() => _PhysioReminderState();
}

class _PhysioReminderState extends State<PhysioReminderSection> {
  final _backend = BackendOrchestrator.instance;
  final _notif = PhysioNotificationService.instance;

  bool _doneToday = false;
  int _streak = 0;
  bool _loading = true;
  bool _marking = false;
  bool _enabled = false;
  int _hour = 9;
  int _minute = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final done = await _backend.isPhysioDoneToday();
    final streak = await _backend.getPhysioStreak();
    final s = await _notif.getSavedSettings();
    if (!mounted) return;
    setState(() { _doneToday = done; _streak = streak; _enabled = s.enabled; _hour = s.hour; _minute = s.minute; _loading = false; });
  }

  Future<void> _markDone() async {
    setState(() => _marking = true);
    try {
      await _backend.logPhysioToday();
      final streak = await _backend.getPhysioStreak();
      if (!mounted) return;
      setState(() { _doneToday = true; _streak = streak; _marking = false; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_streak >= 7 ? '🏆 7 günlük seri! Tedavi Şampiyonu rozeti kazandın!' : '💪 Bugünkü egzersiz tamamlandı! Seri: $_streak gün'),
          backgroundColor: YanYanaColors.success,
        ));
      }
    } catch (e) {
      if (mounted) { setState(() => _marking = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'))); }
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay(hour: _hour, minute: _minute), helpText: 'Hatırlatıcı saatini seç');
    if (picked == null || !mounted) return;
    await _notif.scheduleDaily(hour: picked.hour, minute: picked.minute);
    if (!mounted) return;
    setState(() { _enabled = true; _hour = picked.hour; _minute = picked.minute; });
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hatırlatıcı ${picked.format(context)} için ayarlandı 🔔')));
  }

  Future<void> _cancel() async {
    await _notif.cancel();
    if (!mounted) return;
    setState(() => _enabled = false);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hatırlatıcı iptal edildi.')));
  }

  @override
  Widget build(BuildContext context) {
    return _card(
      title: 'Fizik Tedavi Takibi',
      icon: Icons.fitness_center_rounded,
      child: _loading
          ? const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Streak banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _streak >= 7 ? [const Color(0xFFF59E0B), const Color(0xFFFBBF24)] : [YanYanaColors.secondary, YanYanaColors.accentBlue],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(children: [
                    Text(_streak >= 7 ? '🏆' : '🔥', style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('$_streak Günlük Seri', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                      Text(_streak >= 7 ? 'Tedavi Şampiyonu! 🎖️' : '7 güne ulaş → Rozet kazan!', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12, fontWeight: FontWeight.w600)),
                    ])),
                    Row(children: List.generate(7, (i) => Container(
                      width: 10, height: 10, margin: const EdgeInsets.only(left: 3),
                      decoration: BoxDecoration(color: i < _streak.clamp(0, 7) ? Colors.white : Colors.white.withValues(alpha: 0.3), shape: BoxShape.circle),
                    ))),
                  ]),
                ),
                const SizedBox(height: 16),
                // Bugünkü egzersiz
                if (_doneToday)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: YanYanaColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: YanYanaColors.success.withValues(alpha: 0.3))),
                    child: const Row(children: [Icon(Icons.check_circle_rounded, color: YanYanaColors.success, size: 24), SizedBox(width: 10), Text('Bugünkü egzersiz tamamlandı! ✨', style: TextStyle(color: YanYanaColors.success, fontWeight: FontWeight.w700, fontSize: 14))]),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _marking ? null : _markDone,
                      icon: _marking ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.check_rounded),
                      label: const Text('Bugünkü Egzersizi Tamamladım'),
                      style: FilledButton.styleFrom(backgroundColor: YanYanaColors.secondary, padding: const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: YanYanaColors.border),
                const SizedBox(height: 14),
                // Hatırlatıcı
                Row(children: [
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: YanYanaColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.notifications_active_rounded, color: YanYanaColors.primary, size: 20)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Günlük Hatırlatıcı', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: YanYanaColors.textDark)),
                    Text(_enabled ? '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')} — Aktif 🔔' : 'Kapalı',
                        style: TextStyle(color: _enabled ? YanYanaColors.success : YanYanaColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                  ])),
                  if (_enabled)
                    TextButton(onPressed: _cancel, child: const Text('İptal', style: TextStyle(color: YanYanaColors.sos)))
                  else
                    FilledButton.icon(
                      onPressed: _pickTime,
                      icon: const Icon(Icons.alarm_add_rounded, size: 16),
                      label: const Text('Ayarla'),
                      style: FilledButton.styleFrom(backgroundColor: YanYanaColors.primary, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), textStyle: const TextStyle(fontSize: 13)),
                    ),
                ]),
                if (_enabled) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.edit_rounded, size: 14),
                    label: const Text('Saati değiştir', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  ),
                ],
              ],
            ),
    );
  }
}

// ── Ortak kart helper ──────────────────────────────────────────────────
Widget _card({required String title, required IconData icon, required Widget child}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
    decoration: BoxDecoration(color: YanYanaColors.surface, borderRadius: BorderRadius.circular(22), border: Border.all(color: YanYanaColors.border), boxShadow: YanYanaShadows.soft),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 22, color: YanYanaColors.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: YanYanaColors.textDark))),
        ]),
        const SizedBox(height: 14),
        child,
      ],
    ),
  );
}
