import 'package:flutter/material.dart';
import '../theme.dart';
import 'login_page.dart';
import 'volunteer_admin_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = 'Ayşe Yılmaz';
  String _email = 'ayse@mail.com';
  String _role = 'Engelli Kullanıcı';

  final int _points = 120;
  final double _completion = 0.75;

  String _about =
      'Merhaba, ben Ayşe. Yazılı iletişimi tercih ediyorum ve acil durumlarda güvenli destek almak istiyorum.';

  final List<String> _interests = ['Müzik', 'Doğa', 'Kitap', 'Teknoloji'];

  final List<String> _badges = const [
    'İlk Adım',
    'İletişimci',
    'Keşifçi',
    'Güvenli Destek',
    'Erişilebilirlik Katkısı',
  ];

  final List<String> _communicationOptions = const [
    'Yazılı iletişim',
    'Sesli iletişim',
    'Altyazılı görüşme',
    'Yavaş ve net iletişim',
    'Görsel destek',
    'Sadece güvenilir kişiler',
  ];

  final Set<String> _selectedCommunication = {
    'Yazılı iletişim',
  };

  final List<String> _accessibilityNeedsOptions = const [
    'Görme desteği',
    'İşitme desteği',
    'Hareket desteği',
    'Bilişsel destek',
    'Psikososyal destek',
    'Görünmez engel',
    'Acil destek ihtiyacı',
  ];

  final Set<String> _selectedAccessibilityNeeds = {
    'Görme desteği',
    'Hareket desteği',
    'Görünmez engel',
  };

  final List<_EmergencyContact> _contacts = [
    const _EmergencyContact(
      name: 'Elif Yılmaz',
      relationship: 'Kardeş',
      phone: '+90 555 000 00 01',
    ),
    const _EmergencyContact(
      name: 'Mehmet Yılmaz',
      relationship: 'Baba',
      phone: '+90 555 000 00 02',
    ),
  ];

  bool _reminderPhysio = true;
  bool _reminderWater = true;
  bool _reminderCommunity = false;

  bool _privacyTrustedOnly = true;
  bool _privacyShareLocationSOSOnly = true;
  bool _privacyAllowMatching = true;
  bool _privacyVisibleInCommunity = true;

  String _volunteerStatus = 'Henüz başvuru yapılmadı';
  final List<String> _volunteerAreas = const [
    'Okuma Desteği',
    'Sosyal Destek',
    'Acil Destek',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 110),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildCommunicationPreferencesCard(),
                    const SizedBox(height: 16),
                    _buildAccessibilityNeedsCard(),
                    const SizedBox(height: 16),
                    _buildVoiceIntroCard(),
                    const SizedBox(height: 16),
                    _buildEmergencyContactsCard(),
                    const SizedBox(height: 16),
                    _buildVolunteerStatusCard(context),
                    const SizedBox(height: 16),
                    _buildBadgesAndPointsCard(),
                    const SizedBox(height: 16),
                    _buildDailyRemindersCard(),
                    const SizedBox(height: 16),
                    _buildPrivacySafetyCard(),
                    const SizedBox(height: 16),
                    _buildSettingsCard(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final initial = _name.trim().isEmpty ? '?' : _name.trim()[0].toUpperCase();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: YanYanaShadows.card,
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: YanYanaColors.primary,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  size: 16,
                  color: YanYanaColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _headerBadge(_role),
              _headerBadge('$_points XP'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Profil Tamamlama: %${(_completion * 100).round()}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.92),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'Demo',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: _completion,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.22),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              label: 'Profili Düzenle',
              icon: Icons.edit_rounded,
              gradient: supportGradient,
              height: 52,
              onPressed: () => _openEditProfileSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _headerBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.28),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  void _openEditProfileSheet(BuildContext context) {
    final nameCtrl = TextEditingController(text: _name);
    final emailCtrl = TextEditingController(text: _email);
    final aboutCtrl = TextEditingController(text: _about);

    String role = _role;
    String commPrimary = _selectedCommunication.isNotEmpty
        ? _selectedCommunication.first
        : 'Yazılı iletişim';

    final roleOptions = const ['Engelli Kullanıcı', 'Gönüllü', 'Mentor'];
    final commOptions = const [
      'Yazılı iletişim',
      'Sesli iletişim',
      'Altyazılı görüşme',
      'Yavaş ve net iletişim',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: YanYanaColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: YanYanaShadows.card,
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: YanYanaColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              color: YanYanaColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Profili Düzenle (Prototip)',
                              style: TextStyle(
                                color: YanYanaColors.textDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      YanYanaTextField(
                        controller: nameCtrl,
                        label: 'Ad Soyad',
                        hint: 'Adınızı girin',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 12),
                      YanYanaTextField(
                        controller: emailCtrl,
                        label: 'E-posta',
                        hint: 'ornek@mail.com',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Kullanıcı Rolü',
                        style: TextStyle(
                          color: YanYanaColors.textDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: roleOptions.map((r) {
                          final selected = r == role;
                          return _ChoiceChip(
                            label: r,
                            selected: selected,
                            onTap: () => setModalState(() => role = r),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'İletişim Tercihi',
                        style: TextStyle(
                          color: YanYanaColors.textDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: commOptions.map((c) {
                          final selected = c == commPrimary;
                          return _ChoiceChip(
                            label: c,
                            selected: selected,
                            onTap: () => setModalState(() => commPrimary = c),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: aboutCtrl,
                        minLines: 2,
                        maxLines: 4,
                        decoration: _inputDeco(
                          label: 'Kısa Tanıtım / Hakkımda',
                          hint: 'Kendini kısaca anlat',
                          icon: Icons.notes_rounded,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: YanYanaColors.textDark,
                                side: const BorderSide(color: YanYanaColors.border),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                'İptal',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GradientButton(
                              label: 'Kaydet',
                              icon: Icons.check_rounded,
                              height: 52,
                              onPressed: () {
                                final n = nameCtrl.text.trim();
                                final e = emailCtrl.text.trim();
                                if (n.isEmpty) {
                                  ScaffoldMessenger.of(this.context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Ad Soyad boş bırakılamaz'),
                                    ),
                                  );
                                  return;
                                }
                                if (e.isEmpty || !e.contains('@')) {
                                  ScaffoldMessenger.of(this.context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Geçerli bir e-posta girin'),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  _name = n;
                                  _email = e;
                                  _role = role;
                                  final a = aboutCtrl.text.trim();
                                  if (a.isNotEmpty) _about = a;
                                  _selectedCommunication
                                    ..clear()
                                    ..add(commPrimary);
                                });

                                Navigator.pop(context);
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Profil bilgileri prototip olarak güncellendi.',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    ).whenComplete(() {
      nameCtrl.dispose();
      emailCtrl.dispose();
      aboutCtrl.dispose();
    });
  }

  Widget _buildCommunicationPreferencesCard() {
    return _SectionCard(
      title: 'İletişim Tercihleri',
      icon: Icons.chat_bubble_outline_rounded,
      color: YanYanaColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _communicationOptions.map((c) {
              final selected = _selectedCommunication.contains(c);
              return _ChoiceChip(
                label: c,
                selected: selected,
                onTap: () {
                  setState(() {
                    if (selected) {
                      _selectedCommunication.remove(c);
                    } else {
                      _selectedCommunication.add(c);
                    }
                    if (_selectedCommunication.isEmpty) {
                      _selectedCommunication.add('Yazılı iletişim');
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            'Bu tercihler eşleşme ve destek süreçlerinde kullanılmak üzere tasarlanmıştır.',
            style: TextStyle(
              color: YanYanaColors.textMuted.withOpacity(0.95),
              fontSize: 12.5,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityNeedsCard() {
    return _SectionCard(
      title: 'Erişilebilirlik İhtiyaçları',
      icon: Icons.accessibility_new_rounded,
      color: YanYanaColors.secondary,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _accessibilityNeedsOptions.map((n) {
          final selected = _selectedAccessibilityNeeds.contains(n);
          return _ChoiceChip(
            label: n,
            selected: selected,
            onTap: () {
              setState(() {
                if (selected) {
                  _selectedAccessibilityNeeds.remove(n);
                } else {
                  _selectedAccessibilityNeeds.add(n);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVoiceIntroCard() {
    return _SectionCard(
      title: 'Sesli Tanıtım Alanı',
      icon: Icons.record_voice_over_outlined,
      color: YanYanaColors.accentPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: YanYanaColors.accentBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: YanYanaColors.accentBlue.withOpacity(0.18),
                  ),
                ),
                child: const Text(
                  'Prototype',
                  style: TextStyle(
                    color: YanYanaColors.textDark,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _about,
            style: const TextStyle(
              color: YanYanaColors.textMuted,
              fontSize: 13,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sesli tanıtım prototip olarak simüle edildi.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text(
                    'Tanıtımı Dinle',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: YanYanaColors.primary,
                    side: const BorderSide(color: YanYanaColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sesli tanıtım prototip olarak simüle edildi.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.mic_rounded),
                  label: const Text(
                    'Tanıtım Ekle',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: YanYanaColors.secondary,
                    side: const BorderSide(color: YanYanaColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
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

  Widget _buildEmergencyContactsCard() {
    return _SectionCard(
      title: 'Acil Durum Kişileri',
      icon: Icons.emergency_share_rounded,
      color: YanYanaColors.sos,
      child: Column(
        children: [
          ..._contacts.map(
            (c) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: YanYanaColors.surfaceSoft,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: YanYanaColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: YanYanaColors.sosLight,
                    child: Text(
                      c.name.isEmpty ? '?' : c.name[0],
                      style: const TextStyle(
                        color: YanYanaColors.sos,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: const TextStyle(
                            color: YanYanaColors.textDark,
                            fontWeight: FontWeight.w900,
                            fontSize: 14.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${c.relationship} · ${c.phone}',
                          style: const TextStyle(
                            color: YanYanaColors.textMuted,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'SOS durumunda bilgilendirilir',
                          style: TextStyle(
                            color: YanYanaColors.sos.withOpacity(0.9),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _openAddContactSheet,
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text(
                'Acil Kişi Ekle',
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
        ],
      ),
    );
  }

  void _openAddContactSheet() {
    final nameCtrl = TextEditingController();
    final relCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: YanYanaColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: YanYanaShadows.card,
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: YanYanaColors.sosLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.emergency_share_rounded,
                        color: YanYanaColors.sos,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Acil Kişi Ekle (Prototip)',
                        style: TextStyle(
                          color: YanYanaColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  decoration: _inputDeco(
                    label: 'Ad Soyad',
                    hint: 'Örn: Elif Yılmaz',
                    icon: Icons.person_outline_rounded,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: relCtrl,
                  decoration: _inputDeco(
                    label: 'Yakınlık',
                    hint: 'Örn: Kardeş',
                    icon: Icons.people_alt_outlined,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDeco(
                    label: 'Telefon',
                    hint: '+90 5xx xxx xx xx',
                    icon: Icons.call_rounded,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    label: 'Kaydet',
                    icon: Icons.check_rounded,
                    gradient: sosGradient,
                    onPressed: () {
                      final n = nameCtrl.text.trim();
                      final r = relCtrl.text.trim();
                      final p = phoneCtrl.text.trim();
                      if (n.isEmpty || r.isEmpty || p.isEmpty) {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Lütfen tüm alanları doldurun'),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        _contacts.add(
                          _EmergencyContact(
                            name: n,
                            relationship: r,
                            phone: p,
                          ),
                        );
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text('Acil kişi prototip olarak eklendi.'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      nameCtrl.dispose();
      relCtrl.dispose();
      phoneCtrl.dispose();
    });
  }

  Widget _buildVolunteerStatusCard(BuildContext context) {
    return _SectionCard(
      title: 'Gönüllü Durumu',
      icon: Icons.volunteer_activism_rounded,
      color: YanYanaColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            icon: Icons.info_outline_rounded,
            label: 'Durum',
            value: _volunteerStatus,
          ),
          const SizedBox(height: 12),
          const Text(
            'Destek Alanları',
            style: TextStyle(
              color: YanYanaColors.textDark,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _volunteerAreas
                .map(
                  (a) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: YanYanaColors.secondary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: YanYanaColors.secondary.withOpacity(0.18),
                      ),
                    ),
                    child: Text(
                      a,
                      style: const TextStyle(
                        color: YanYanaColors.textDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              label: 'Gönüllü Başvurusu',
              icon: Icons.arrow_forward_rounded,
              gradient: supportGradient,
              height: 52,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VolunteerAdminPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesAndPointsCard() {
    const nextBadgeProgress = 0.55;
    return _SectionCard(
      title: 'Rozetler ve Puanlar',
      icon: Icons.military_tech_rounded,
      color: YanYanaColors.accentPink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  gradient: supportGradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: YanYanaShadows.soft,
                ),
                child: Text(
                  '$_points XP',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sonraki rozete ilerleme',
                      style: TextStyle(
                        color: YanYanaColors.textMuted,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: const LinearProgressIndicator(
                        value: nextBadgeProgress,
                        minHeight: 10,
                        backgroundColor: YanYanaColors.surfaceSoft,
                        valueColor: AlwaysStoppedAnimation(
                          YanYanaColors.accentPink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _badges.map((b) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: YanYanaColors.accentPink.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: YanYanaColors.accentPink.withOpacity(0.18),
                  ),
                ),
                child: Text(
                  b,
                  style: const TextStyle(
                    color: YanYanaColors.textDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text(
                'İlgi Alanları:',
                style: TextStyle(
                  color: YanYanaColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _interests
                      .map(
                        (i) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: YanYanaColors.accentBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: YanYanaColors.accentBlue.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            i,
                            style: const TextStyle(
                              color: YanYanaColors.textDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyRemindersCard() {
    return _SectionCard(
      title: 'Günlük Hatırlatıcılar',
      icon: Icons.alarm_rounded,
      color: YanYanaColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToggleRow(
            title: 'Fizik tedavi egzersizi',
            subtitle: '10:00',
            value: _reminderPhysio,
            onChanged: (v) => setState(() => _reminderPhysio = v),
          ),
          const Divider(height: 18, color: YanYanaColors.divider),
          _ToggleRow(
            title: 'Su içme hatırlatıcısı',
            subtitle: '14:00',
            value: _reminderWater,
            onChanged: (v) => setState(() => _reminderWater = v),
          ),
          const Divider(height: 18, color: YanYanaColors.divider),
          _ToggleRow(
            title: 'Günlük topluluk kontrolü',
            subtitle: '18:00',
            value: _reminderCommunity,
            onChanged: (v) => setState(() => _reminderCommunity = v),
          ),
          const SizedBox(height: 10),
          Text(
            'Gerçek bildirim entegrasyonu NotificationDispatcher ile future integration olarak planlanmıştır.',
            style: TextStyle(
              color: YanYanaColors.textMuted.withOpacity(0.95),
              fontSize: 12.5,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySafetyCard() {
    return _SectionCard(
      title: 'Gizlilik ve Güvenlik',
      icon: Icons.shield_outlined,
      color: YanYanaColors.secondary,
      child: Column(
        children: [
          _ToggleRow(
            title: 'Profilimi sadece güvenilir kişiler görsün',
            subtitle: 'Görünürlük kontrolü (mock)',
            value: _privacyTrustedOnly,
            onChanged: (v) => setState(() => _privacyTrustedOnly = v),
          ),
          const Divider(height: 18, color: YanYanaColors.divider),
          _ToggleRow(
            title: 'Konumumu yalnızca SOS anında paylaş',
            subtitle: 'Acil durumda konum paylaşımı',
            value: _privacyShareLocationSOSOnly,
            onChanged: (v) => setState(() => _privacyShareLocationSOSOnly = v),
          ),
          const Divider(height: 18, color: YanYanaColors.divider),
          _ToggleRow(
            title: 'Gönüllülerle eşleşmeye izin ver',
            subtitle: 'Eşleşme motoru için tercih',
            value: _privacyAllowMatching,
            onChanged: (v) => setState(() => _privacyAllowMatching = v),
          ),
          const Divider(height: 18, color: YanYanaColors.divider),
          _ToggleRow(
            title: 'Topluluk odalarında görünür ol',
            subtitle: 'Sosyal katılım ayarı (mock)',
            value: _privacyVisibleInCommunity,
            onChanged: (v) => setState(() => _privacyVisibleInCommunity = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return _SectionCard(
      title: 'Ayarlar',
      icon: Icons.settings_outlined,
      color: YanYanaColors.primary,
      child: Column(
        children: [
          _SettingRow(
            icon: Icons.person_outline_rounded,
            label: 'Profil Bilgileri',
            onTap: () => _openEditProfileSheet(context),
          ),
          const Divider(height: 1, color: YanYanaColors.divider),
          _SettingRow(
            icon: Icons.notifications_outlined,
            label: 'Bildirimler',
            onTap: () {},
          ),
          const Divider(height: 1, color: YanYanaColors.divider),
          _SettingRow(
            icon: Icons.lock_outline_rounded,
            label: 'Gizlilik',
            onTap: () {},
          ),
          const Divider(height: 1, color: YanYanaColors.divider),
          _SettingRow(
            icon: Icons.help_outline_rounded,
            label: 'Yardım & Destek',
            onTap: () {},
          ),
          const Divider(height: 1, color: YanYanaColors.divider),
          _SettingRow(
            icon: Icons.logout_rounded,
            label: 'Çıkış Yap',
            isDestructive: true,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  static InputDecoration _inputDeco({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: YanYanaColors.primary, size: 21),
      filled: true,
      fillColor: YanYanaColors.surfaceSoft,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: YanYanaColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: YanYanaColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: YanYanaColors.primary, width: 1.6),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
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
                  color: color.withOpacity(0.13),
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
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: YanYanaColors.textMuted, size: 19),
        const SizedBox(width: 11),
        Text(
          label,
          style: const TextStyle(
            color: YanYanaColors.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: YanYanaColors.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? YanYanaColors.sos : YanYanaColors.textDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Icon(icon, color: color, size: 21),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: isDestructive
                  ? YanYanaColors.sos.withOpacity(0.5)
                  : YanYanaColors.textLight,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? YanYanaColors.primary : YanYanaColors.surfaceSoft,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? YanYanaColors.primary : YanYanaColors.border,
          ),
          boxShadow: selected ? YanYanaShadows.soft : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : YanYanaColors.textMuted,
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: YanYanaColors.textDark,
                  fontWeight: FontWeight.w900,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: YanYanaColors.textMuted,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: YanYanaColors.primary,
        ),
      ],
    );
  }
}

class _EmergencyContact {
  final String name;
  final String relationship;
  final String phone;

  const _EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phone,
  });
}