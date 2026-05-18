import 'package:flutter/material.dart';
import 'package:yanyana_p/core/constants/role_constants.dart';
import 'package:yanyana_p/core/services/backend_orchestrator.dart';
import 'package:yanyana_p/core/services/profile_service.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/core/utils/feature_dialogs.dart';
import 'package:yanyana_p/core/widgets/role_badges.dart';
import 'package:yanyana_p/features/admin/admin_dashboard_page.dart';
import 'package:yanyana_p/features/admin/moderator_dashboard_page.dart';
import 'package:yanyana_p/features/home/main_page.dart';
import 'package:yanyana_p/features/home/trusted_contacts_page.dart';
import 'package:yanyana_p/shared/models/app_user.dart';
import 'package:yanyana_p/shared/models/volunteer_application.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _backend = BackendOrchestrator.instance;

  final _nameCtrl = TextEditingController();
  final _aboutCtrl = TextEditingController();
  final _voiceCtrl = TextEditingController();
  final _interestsCtrl = TextEditingController();
  final _emergencyNameCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();

  AppUser? _user;
  VolunteerApplication? _volunteerApp;
  bool _loading = true;
  bool _saving = false;
  String? _loadError;

  String _snapshotName = '';
  String _snapshotAbout = '';
  String _snapshotVoice = '';
  String _snapshotInterests = '';
  String _snapshotEmergencyName = '';
  String _snapshotEmergencyPhone = '';
  final Set<String> _selectedComm = {};
  final Set<String> _selectedAccess = {};
  Set<String> _snapshotComm = {};
  Set<String> _snapshotAccess = {};

  static const _commOptions = [
    'Yazılı iletişim',
    'Sesli iletişim',
    'Yavaş ve net iletişim',
    'Görsel destek',
  ];
  static const _accessOptions = [
    'Görme desteği',
    'İşitme desteği',
    'Hareket desteği',
    'Görünmez engel',
    'Acil destek ihtiyacı',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _aboutCtrl.dispose();
    _voiceCtrl.dispose();
    _interestsCtrl.dispose();
    _emergencyNameCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final uid = _backend.authService.currentUser?.id;
      if (uid == null) {
        setState(() {
          _user = null;
          _loading = false;
        });
        return;
      }
      final user = await ProfileService.instance.getProfile(uid) ??
          _backend.currentUser;
      final volunteerApp = await _backend.getMyVolunteerApplication();
      if (!mounted) return;
      _applyUser(user);
      setState(() {
        _volunteerApp = volunteerApp;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.toString();
        _loading = false;
        _user = _backend.currentUser;
        if (_user != null) _applyUser(_user);
      });
    }
  }

  void _applyUser(AppUser? user) {
    _user = user;
    if (user == null) return;
    _nameCtrl.text = user.name;
    _aboutCtrl.text = user.about;
    _voiceCtrl.text = user.voiceIntro;
    _interestsCtrl.text = user.interests.join(', ');
    _emergencyNameCtrl.text = user.emergencyContactName;
    _emergencyPhoneCtrl.text = user.emergencyContactPhone;
    _selectedComm
      ..clear()
      ..addAll(
        user.communicationPreferences.isEmpty &&
                user.communicationPreference.isNotEmpty
            ? [user.communicationPreference]
            : user.communicationPreferences,
      );
    _selectedAccess
      ..clear()
      ..addAll(user.accessibilityNeeds);
    _takeSnapshot();
  }

  void _takeSnapshot() {
    _snapshotName = _nameCtrl.text;
    _snapshotAbout = _aboutCtrl.text;
    _snapshotVoice = _voiceCtrl.text;
    _snapshotInterests = _interestsCtrl.text;
    _snapshotEmergencyName = _emergencyNameCtrl.text;
    _snapshotEmergencyPhone = _emergencyPhoneCtrl.text;
    _snapshotComm = Set<String>.from(_selectedComm);
    _snapshotAccess = Set<String>.from(_selectedAccess);
  }

  bool get _hasChanges {
    if (_user == null) return false;
    return _nameCtrl.text != _snapshotName ||
        _aboutCtrl.text != _snapshotAbout ||
        _voiceCtrl.text != _snapshotVoice ||
        _interestsCtrl.text != _snapshotInterests ||
        _emergencyNameCtrl.text != _snapshotEmergencyName ||
        _emergencyPhoneCtrl.text != _snapshotEmergencyPhone ||
        !_setEquals(_selectedComm, _snapshotComm) ||
        !_setEquals(_selectedAccess, _snapshotAccess);
  }

  bool _setEquals(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }

  double _profileCompletion(AppUser user) {
    var filled = 0;
    const total = 7;
    if (user.name.trim().isNotEmpty) filled++;
    if (user.about.trim().isNotEmpty) filled++;
    if (user.voiceIntro.trim().isNotEmpty) filled++;
    if (user.interests.isNotEmpty) filled++;
    if (user.communicationPreferences.isNotEmpty ||
        user.communicationPreference.isNotEmpty) {
      filled++;
    }
    if (user.accessibilityNeeds.isNotEmpty) filled++;
    if (user.hasEmergencyContact) filled++;
    return filled / total;
  }

  Future<void> _save() async {
    if (_user == null || !_hasChanges) return;
    setState(() => _saving = true);
    try {
      final updated = await _backend.updateProfile(
        name: _nameCtrl.text,
        about: _aboutCtrl.text,
        voiceIntro: _voiceCtrl.text,
        interests: _interestsCtrl.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        accessibilityNeeds: _selectedAccess.toList(),
        communicationPreferences: _selectedComm.toList(),
        emergencyContactName: _emergencyNameCtrl.text.trim(),
        emergencyContactPhone: _emergencyPhoneCtrl.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _user = updated;
        _saving = false;
      });
      _takeSnapshot();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil güncellendi.')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil kaydedilemedi: $e'),
          backgroundColor: YanYanaColors.sos,
        ),
      );
    }
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Çıkış yap'),
        content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: YanYanaColors.sos),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await _backend.signOut();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Çıkış yapılamadı: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: YanYanaColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      return Scaffold(
        backgroundColor: YanYanaColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_off_outlined, size: 48),
                const SizedBox(height: 12),
                Text(
                  _loadError ?? 'Oturum bulunamadı.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _load,
                  child: const Text('Yeniden dene'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final user = _user!;

    return Scaffold(
      backgroundColor: YanYanaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _load,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Profil',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: YanYanaColors.textDark,
                        ),
                      ),
                      if (_loadError != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Bazı alanlar önbellekten yüklendi.',
                          style: TextStyle(
                            color: YanYanaColors.warning.withOpacity(0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      _ProfileHeaderCard(
                        user: user,
                        completion: _profileCompletion(user),
                      ),
                      const SizedBox(height: 14),
                      _SectionCard(
                        title: 'Kişisel bilgiler',
                        icon: Icons.person_outline_rounded,
                        child: Column(
                          children: [
                            _ProfileField(
                              label: 'Ad Soyad',
                              controller: _nameCtrl,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 12),
                            _ProfileField(
                              label: 'Hakkında',
                              controller: _aboutCtrl,
                              maxLines: 3,
                              hint: 'Kendinizi kısaca tanıtın',
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 12),
                            _ProfileField(
                              label: 'Sesli tanıtım metni',
                              controller: _voiceCtrl,
                              maxLines: 2,
                              hint: 'Sesli tanıtım için kısa metin',
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 12),
                            _ProfileField(
                              label: 'İlgi alanları',
                              controller: _interestsCtrl,
                              hint: 'Virgülle ayırın (ör. müzik, spor)',
                              onChanged: (_) => setState(() {}),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      _SectionCard(
                        title: 'Erişilebilirlik tercihleri',
                        icon: Icons.accessibility_new_rounded,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _SubsectionLabel('İletişim tercihleri'),
                            const SizedBox(height: 8),
                            _PreferenceChips(
                              options: _commOptions,
                              selected: _selectedComm,
                              onChanged: (next) => setState(() {
                                _selectedComm
                                  ..clear()
                                  ..addAll(next);
                              }),
                            ),
                            const SizedBox(height: 16),
                            const _SubsectionLabel('Erişilebilirlik ihtiyaçları'),
                            const SizedBox(height: 8),
                            _PreferenceChips(
                              options: _accessOptions,
                              selected: _selectedAccess,
                              onChanged: (next) => setState(() {
                                _selectedAccess
                                  ..clear()
                                  ..addAll(next);
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      _SectionCard(
                        title: 'Acil durum kişisi',
                        icon: Icons.emergency_rounded,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SOS ve güvenli arama bu bilgiyi kullanır.',
                              style: TextStyle(
                                color: YanYanaColors.textMuted,
                                fontSize: 13,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (user.hasEmergencyContact &&
                                _emergencyNameCtrl.text.trim().isNotEmpty)
                              _EmergencyContactPreview(
                                name: _emergencyNameCtrl.text.trim(),
                                phone: _emergencyPhoneCtrl.text.trim(),
                              ),
                            if (!user.hasEmergencyContact &&
                                _emergencyNameCtrl.text.trim().isEmpty)
                              const Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: Text(
                                  'Henüz acil durum kişisi eklenmedi.',
                                  style: TextStyle(
                                    color: YanYanaColors.textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            _ProfileField(
                              label: 'Acil kişi adı',
                              controller: _emergencyNameCtrl,
                              hint: 'Örn. Ayşe Yılmaz',
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 12),
                            _ProfileField(
                              label: 'Acil kişi telefon',
                              controller: _emergencyPhoneCtrl,
                              keyboardType: TextInputType.phone,
                              hint: '05xx xxx xx xx',
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => Navigator.push<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (_) => const TrustedContactsPage(),
                                  ),
                                ).then((_) => _load()),
                                icon: const Icon(Icons.contact_phone_outlined, size: 18),
                                label: const Text('Güvenilir kişileri yönet'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      _VolunteerCard(
                        user: user,
                        application: _volunteerApp,
                        onApply: () async {
                          try {
                            final app = await _backend.submitVolunteerApplication(
                              supportArea: 'Genel destek',
                            );
                            if (!mounted) return;
                            setState(() => _volunteerApp = app);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Gönüllü başvurunuz alındı.'),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                        onEDevlet: () => showFutureFeatureDialog(
                          context,
                          title: 'e-Devlet doğrulama',
                          message:
                              'e-Devlet doğrulama gelecek sürümde eklenecektir. Şu an aktif değildir.',
                        ),
                      ),
                      if (user.isAdmin) ...[
                        const SizedBox(height: 14),
                        _SectionCard(
                          title: 'Yönetim',
                          icon: Icons.admin_panel_settings_outlined,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.dashboard_customize_outlined),
                            title: const Text('Admin Paneli'),
                            subtitle: const Text('Gönüllü başvuruları ve kullanıcı yönetimi'),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () => Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => const AdminDashboardPage(),
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (user.isModerator && !user.isAdmin) ...[
                        const SizedBox(height: 14),
                        _SectionCard(
                          title: 'Moderasyon',
                          icon: Icons.shield_outlined,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.forum_outlined),
                            title: const Text('Moderatör Paneli'),
                            subtitle: const Text('Topluluk moderasyon araçları'),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () => Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => const ModeratorDashboardPage(),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      _AccountActionsCard(onLogout: _logout),
                      SizedBox(height: MainPage.bottomContentPadding * 0.35),
                    ],
                  ),
                ),
              ),
            ),
            _SaveBar(
              hasChanges: _hasChanges,
              saving: _saving,
              onSave: _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final AppUser user;
  final double completion;

  const _ProfileHeaderCard({required this.user, required this.completion});

  String get _initials {
    final parts = user.name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = user.photoURL.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: YanYanaShadows.card,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white24,
            backgroundImage:
                hasPhoto ? NetworkImage(user.photoURL) : null,
            onBackgroundImageError: hasPhoto ? (_, __) {} : null,
            child: hasPhoto
                ? null
                : Text(
                    _initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            user.name.isEmpty ? 'İsimsiz kullanıcı' : user.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          RoleBadgesRow(user: user, lightOnGradient: true),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completion.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Profil tamamlanma: ${(completion * 100).round()}%',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: YanYanaColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: YanYanaColors.border),
        boxShadow: YanYanaShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: YanYanaColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: YanYanaColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SubsectionLabel extends StatelessWidget {
  final String text;
  const _SubsectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: YanYanaColors.textDark,
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final String? hint;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const _ProfileField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: YanYanaColors.textDark,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: YanYanaColors.surfaceSoft,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: YanYanaColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: YanYanaColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _PreferenceChips extends StatelessWidget {
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  const _PreferenceChips({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((label) {
        final on = selected.contains(label);
        return Semantics(
          button: true,
          selected: on,
          label: label,
          child: FilterChip(
            label: Text(label),
            selected: on,
            showCheckmark: false,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: on ? Colors.white : YanYanaColors.textDark,
            ),
            selectedColor: YanYanaColors.primary,
            backgroundColor: YanYanaColors.surface,
            side: BorderSide(
              color: on ? YanYanaColors.primary : YanYanaColors.border,
            ),
            onSelected: (v) {
              final next = Set<String>.from(selected);
              if (v) {
                next.add(label);
              } else {
                next.remove(label);
              }
              onChanged(next);
            },
          ),
        );
      }).toList(),
    );
  }
}

class _EmergencyContactPreview extends StatelessWidget {
  final String name;
  final String phone;

  const _EmergencyContactPreview({required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: YanYanaColors.primaryLight.withOpacity(0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: YanYanaColors.primary.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.contact_emergency_rounded, color: YanYanaColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: YanYanaColors.textDark,
                  ),
                ),
                Text(
                  phone,
                  style: const TextStyle(
                    color: YanYanaColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VolunteerCard extends StatelessWidget {
  final AppUser user;
  final VolunteerApplication? application;
  final VoidCallback onApply;
  final VoidCallback onEDevlet;

  const _VolunteerCard({
    required this.user,
    required this.application,
    required this.onApply,
    required this.onEDevlet,
  });

  String _statusLabel(String status) => VolunteerStatus.label(status).isNotEmpty
      ? VolunteerStatus.label(status)
      : 'Beklemede';

  @override
  Widget build(BuildContext context) {
    final isVolunteer = user.userType == AppUserType.volunteer;

    return _SectionCard(
      title: 'Gönüllülük',
      icon: Icons.volunteer_activism_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isVolunteer)
            const Text(
              'Gönüllü hesabı olarak kayıtlısınız.',
              style: TextStyle(color: YanYanaColors.textMuted, fontSize: 14),
            )
          else if (application != null) ...[
            Text(
              'Başvuru durumu: ${_statusLabel(application!.status)}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: YanYanaColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Başvurunuz inceleniyor. Sonuç bildirimlerde görünecek.',
              style: const TextStyle(
                color: YanYanaColors.textMuted,
                fontSize: 13,
              ),
            ),
          ] else
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: onApply,
                icon: const Icon(Icons.volunteer_activism_rounded),
                label: const Text('Gönüllü olmak istiyorum'),
              ),
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onEDevlet,
            icon: const Icon(Icons.verified_user_outlined, size: 20),
            label: const Text('e-Devlet doğrulama'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Gelecek sürümde planlandı.',
            style: TextStyle(
              color: YanYanaColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountActionsCard extends StatelessWidget {
  final VoidCallback onLogout;

  const _AccountActionsCard({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Hesap',
      icon: Icons.settings_outlined,
      child: Semantics(
        button: true,
        label: 'Çıkış Yap',
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded, color: YanYanaColors.sos),
            label: const Text(
              'Çıkış Yap',
              style: TextStyle(
                color: YanYanaColors.sos,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: YanYanaColors.sosLight),
              backgroundColor: YanYanaColors.sosLight.withOpacity(0.35),
            ),
          ),
        ),
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  final bool hasChanges;
  final bool saving;
  final VoidCallback onSave;

  const _SaveBar({
    required this.hasChanges,
    required this.saving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: YanYanaColors.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Semantics(
            button: true,
            label: 'Profil güncelle',
            enabled: hasChanges && !saving,
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: (!hasChanges || saving) ? null : onSave,
                style: FilledButton.styleFrom(
                  backgroundColor: YanYanaColors.primary,
                  disabledBackgroundColor: YanYanaColors.surfaceSoft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Değişiklikleri Kaydet',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: hasChanges
                              ? Colors.white
                              : YanYanaColors.textMuted,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
