import 'package:flutter/material.dart';
import 'package:yanyana_p/core/services/backend_orchestrator.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/features/rooms/rooms_module.dart';
import 'package:yanyana_p/shared/models/community_room.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final _orchestrator = BackendOrchestrator.instance;

  String _selectedCategory = 'Tümü';

  final _categories = const [
    'Tümü',
    'Destek',
    'Eğitim',
    'Sağlık',
    'Sosyal',
    'Mentorluk',
  ];

  List<CommunityRoom> get _rooms {
    final rooms = _orchestrator.getRooms();
    if (_selectedCategory == 'Tümü') return rooms;
    return rooms.where((r) => r.category == _selectedCategory).toList();
  }

  void _showJoinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Prototip Bilgilendirmesi'),
        content: const Text(
          'Bu oda prototip olarak açıldı. Gerçek zamanlı mesajlaşma ve sesli konuşma future integration olarak planlanmıştır.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showCreateRoomSheet() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String category = 'Destek';

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
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
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
                            Icons.add_comment_rounded,
                            color: YanYanaColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Oda Oluştur',
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
                      decoration: InputDecoration(
                        labelText: 'Oda Adı',
                        hintText: 'Örn: Sessiz Sohbet',
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
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
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
                      ),
                      items: _categories
                          .where((c) => c != 'Tümü')
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setModalState(() => category = v ?? 'Destek'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descCtrl,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Açıklama',
                        hintText: 'Bu odanın amacı nedir?',
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
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        label: 'Oluştur',
                        icon: Icons.check_rounded,
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Oda oluşturma isteği prototip olarak kaydedildi.'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                );
              },
            ),
          ),
        );
      },
    ).whenComplete(() {
      nameCtrl.dispose();
      descCtrl.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateRoomSheet,
        backgroundColor: YanYanaColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Oda Oluştur',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const RoomsModulePage(),
                    ),
                  );
                },
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Topluluk Odaları',
                      style: TextStyle(
                        color: YanYanaColors.textDark,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Destek, sohbet ve paylaşım için güvenli alanlar.',
                      style: TextStyle(
                        color: YanYanaColors.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _buildCategoryChips(),
              const SizedBox(height: 14),
              ..._rooms.map(_RoomCard.new),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final c = _categories[i];
          final selected = c == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: selected ? YanYanaColors.primary : YanYanaColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selected ? YanYanaColors.primary : YanYanaColors.border,
                ),
                boxShadow: selected ? YanYanaShadows.soft : null,
              ),
              child: Text(
                c,
                style: TextStyle(
                  color: selected ? Colors.white : YanYanaColors.textMuted,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final CommunityRoom room;

  const _RoomCard(this.room);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: YanYanaColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.forum_rounded,
                  color: YanYanaColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.title,
                      style: const TextStyle(
                        color: YanYanaColors.textDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      room.description,
                      style: const TextStyle(
                        color: YanYanaColors.textMuted,
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _pill(
                label: room.category,
                color: YanYanaColors.secondary,
              ),
              _pill(
                label: '${room.memberCount} üye',
                color: YanYanaColors.accentBlue,
              ),
              if (room.isVoiceEnabled)
                _pill(
                  label: 'Sesli sohbet prototipi',
                  color: YanYanaColors.accentPurple,
                ),
              if (room.isAuthorizedRoom)
                _pill(
                  label: 'Yetkili oda',
                  color: YanYanaColors.warning,
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Katılım (Prototip)'),
                    content: const Text(
                      'Bu oda prototip olarak açıldı. Gerçek zamanlı mesajlaşma ve sesli konuşma future integration olarak planlanmıştır.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tamam'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.login_rounded),
              label: const Text(
                'Katıl',
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

  static Widget _pill({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: YanYanaColors.textDark,
          fontWeight: FontWeight.w800,
          fontSize: 11.5,
        ),
      ),
    );
  }
}

