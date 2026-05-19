import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yanyana_p/core/services/backend_orchestrator.dart';
import 'package:yanyana_p/features/home/main_page.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/features/community_rooms/community_rooms_page.dart';
import 'package:yanyana_p/features/community_rooms/data/mock_community_rooms_data.dart';
import 'package:yanyana_p/features/community_rooms/room_detail_page.dart' as mock_rooms;
import 'package:yanyana_p/features/community_rooms/widgets/community_room_card.dart';
import 'package:yanyana_p/features/rooms/room_detail_page.dart' as live_rooms;
import 'package:yanyana_p/features/community/widgets/community_board_section.dart';
import 'package:yanyana_p/features/community/widgets/community_feed_section.dart';
import 'package:yanyana_p/features/rooms/rooms_module.dart';
import 'package:yanyana_p/shared/models/community_room.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final _orchestrator = BackendOrchestrator.instance;

  List<CommunityRoom> _rooms = const [];

  String _selectedCategory = 'Tümü';
  final Set<String> _joinedMockRoomIds = {};
  StreamSubscription<List<CommunityRoom>>? _roomsSub;

  @override
  void initState() {
    super.initState();
    _roomsSub = _orchestrator.streamCommunityRooms().listen((rooms) {
      if (!mounted) return;
      setState(() => _rooms = rooms);
    });
  }

  @override
  void dispose() {
    _roomsSub?.cancel();
    super.dispose();
  }

  Future<void> _showCreatePostSheet() async {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: Container(
            decoration: BoxDecoration(
              color: YanYanaColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: YanYanaShadows.card,
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Gönderi Paylaş',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: YanYanaColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Başlık'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bodyCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'İçerik'),
                ),
                const SizedBox(height: 20),
                GradientButton(
                  label: 'Paylaş',
                  icon: Icons.send_rounded,
                  onPressed: () => Navigator.pop(ctx, true),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (ok != true || !mounted) {
      titleCtrl.dispose();
      bodyCtrl.dispose();
      return;
    }

    if (titleCtrl.text.trim().isEmpty || bodyCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başlık ve içerik zorunludur.')),
      );
      titleCtrl.dispose();
      bodyCtrl.dispose();
      return;
    }

    try {
      await _orchestrator.addCommunityPost(
        title: titleCtrl.text,
        content: bodyCtrl.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gönderin başarıyla paylaşıldı.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gönderi paylaşılamadı. Lütfen tekrar deneyin.')),
      );
    } finally {
      titleCtrl.dispose();
      bodyCtrl.dispose();
    }
  }

  List<CommunityRoom> get _filteredMockRooms =>
      MockCommunityRoomsData.filterByCategory(_selectedCategory);

  List<CommunityRoom> get _filteredLiveRooms {
    if (_selectedCategory == 'Tümü') return _rooms;
    return _rooms.where((r) => r.category == _selectedCategory).toList();
  }

  void _openMockRoom(CommunityRoom room) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => mock_rooms.RoomDetailPage(
          room: room,
          initiallyJoined: _joinedMockRoomIds.contains(room.id),
          onJoinChanged: (joined) {
            setState(() {
              if (joined) {
                _joinedMockRoomIds.add(room.id);
              } else {
                _joinedMockRoomIds.remove(room.id);
              }
            });
          },
        ),
      ),
    );
  }

  void _joinMockRoom(CommunityRoom room) {
    setState(() => _joinedMockRoomIds.add(room.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${room.title} odasına katıldınız (yerel).')),
    );
  }

  Future<void> _openLiveRoom(CommunityRoom room) async {
    final joined = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => live_rooms.RoomDetailPage(room: room),
      ),
    );
    if (joined == true) setState(() {});
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
                      items: MockCommunityRoomsData.categories
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
                        onPressed: () async {
                          if (nameCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(content: Text('Oda adı zorunludur.')),
                            );
                            return;
                          }
                          try {
                            await _orchestrator.createCommunityRoom(
                              title: nameCtrl.text,
                              category: category,
                              description: descCtrl.text,
                            );
                            if (!mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(content: Text('Oda oluşturuldu.')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
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

  /// Clears bottom nav + stacked extended FABs (Gönderi + Oda).
  static const double _fabStackHeight = 132;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                MainPage.bottomContentPadding + _fabStackHeight,
              ),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Topluluk',
                style: TextStyle(
                  color: YanYanaColors.textDark,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Paylaşımlar, odalar ve destekleyici topluluk alanları.',
                style: TextStyle(
                  color: YanYanaColors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              const CommunityFeedSection(),
              const SizedBox(height: 28),
              const Text(
                'Topluluk Odaları',
                style: TextStyle(
                  color: YanYanaColors.textDark,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Destek, sohbet ve paylaşım için güvenli alanlar.',
                style: TextStyle(
                  color: YanYanaColors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Semantics(
                      label: 'Örnek topluluk odalarını aç, yerel sohbet',
                      button: true,
                      child: SizedBox(
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => const CommunityRoomsPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat_rounded, size: 22),
                          label: const Text(
                            'Odalar (Örnek)',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: YanYanaColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Semantics(
                      label: 'Canlı topluluk odalarını aç',
                      button: true,
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => const RoomsModulePage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.cloud_rounded, size: 22),
                          label: const Text(
                            'Odalar (Canlı)',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: YanYanaColors.primary,
                            side: const BorderSide(color: YanYanaColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildCategoryChips(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: YanYanaColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Örnek odalar',
                      style: TextStyle(
                        color: YanYanaColors.primaryDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Yerel veri — katılım ve sohbet denemesi',
                      style: TextStyle(
                        color: YanYanaColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_filteredMockRooms.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: YanYanaColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: YanYanaColors.border),
                  ),
                  child: Text(
                    '“$_selectedCategory” için örnek oda bulunamadı.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: YanYanaColors.textMuted),
                  ),
                )
              else
                ..._filteredMockRooms.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CommunityRoomCard(
                      room: r,
                      joined: _joinedMockRoomIds.contains(r.id),
                      onOpen: () => _openMockRoom(r),
                      onJoin: () => _joinMockRoom(r),
                    ),
                  ),
                ),
              if (_filteredLiveRooms.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: YanYanaColors.secondaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Canlı odalar',
                        style: TextStyle(
                          color: YanYanaColors.secondary,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Firestore — gerçek zamanlı',
                        style: TextStyle(
                          color: YanYanaColors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._filteredLiveRooms.map(
                  (r) => _LiveRoomCard(
                    room: r,
                    onOpen: () => _openLiveRoom(r),
                  ),
                ),
              ],
              const SizedBox(height: 28),
              const CommunityBoardSection(previewLimit: 4),
            ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: MainPage.bottomContentPadding,
            child: _CommunityFloatingActions(
              onCreatePost: _showCreatePostSheet,
              onCreateRoom: _showCreateRoomSheet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: MockCommunityRoomsData.categories.length,
        itemBuilder: (context, i) {
          final c = MockCommunityRoomsData.categories[i];
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

/// Gönderi + Oda FABs — pinned above [MainPage] bottom navigation.
class _CommunityFloatingActions extends StatelessWidget {
  final VoidCallback onCreatePost;
  final VoidCallback onCreateRoom;

  const _CommunityFloatingActions({
    required this.onCreatePost,
    required this.onCreateRoom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Semantics(
          label: 'Gönderi paylaş',
          button: true,
          child: FloatingActionButton.extended(
            heroTag: 'community-post-fab',
            onPressed: onCreatePost,
            backgroundColor: YanYanaColors.secondary,
            foregroundColor: Colors.white,
            elevation: 4,
            icon: const Icon(Icons.post_add_rounded),
            label: const Text(
              'Gönderi',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Semantics(
          label: 'Yeni oda oluştur',
          button: true,
          child: FloatingActionButton.extended(
            heroTag: 'community-room-fab',
            onPressed: onCreateRoom,
            backgroundColor: YanYanaColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'Oda',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

class _LiveRoomCard extends StatelessWidget {
  final CommunityRoom room;
  final VoidCallback onOpen;

  const _LiveRoomCard({required this.room, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final backend = BackendOrchestrator.instance;

    return FutureBuilder<bool>(
      future: backend.isRoomJoined(room.id),
      builder: (context, snap) {
        final joined = snap.data == true;
        return _roomCardContent(context, joined);
      },
    );
  }

  Widget _roomCardContent(BuildContext context, bool joined) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onOpen,
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: YanYanaColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: YanYanaShadows.card,
              border: joined
                  ? Border.all(color: YanYanaColors.primary, width: 1.5)
                  : null,
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
              if (joined)
                _pill(label: 'Katıldın', color: YanYanaColors.primary),
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
              onPressed: onOpen,
              icon: Icon(joined ? Icons.check_rounded : Icons.login_rounded),
              label: Text(
                joined ? 'Detay / Katıldın' : 'Odayı Aç',
                style: const TextStyle(fontWeight: FontWeight.w900),
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
        ),
      ),
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

