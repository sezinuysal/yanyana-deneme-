import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/features/community_rooms/data/mock_community_rooms_data.dart';
import 'package:yanyana_p/features/community_rooms/room_detail_page.dart';
import 'package:yanyana_p/features/community_rooms/widgets/community_room_card.dart';
import 'package:yanyana_p/shared/models/community_room.dart';

/// Offline mock list of community rooms (independent of Firebase).
class CommunityRoomsPage extends StatefulWidget {
  const CommunityRoomsPage({super.key});

  @override
  State<CommunityRoomsPage> createState() => _CommunityRoomsPageState();
}

class _CommunityRoomsPageState extends State<CommunityRoomsPage> {
  final Set<String> _joinedRoomIds = {};
  String _selectedCategory = 'Tümü';

  List<CommunityRoom> get _filteredRooms =>
      MockCommunityRoomsData.filterByCategory(_selectedCategory);

  void _openRoom(CommunityRoom room) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => RoomDetailPage(
          room: room,
          initiallyJoined: _joinedRoomIds.contains(room.id),
          onJoinChanged: (joined) {
            setState(() {
              if (joined) {
                _joinedRoomIds.add(room.id);
              } else {
                _joinedRoomIds.remove(room.id);
              }
            });
          },
        ),
      ),
    );
  }

  void _joinRoom(CommunityRoom room) {
    setState(() => _joinedRoomIds.add(room.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${room.title} odasına katıldınız (yerel).')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rooms = _filteredRooms;

    return Scaffold(
      backgroundColor: YanYanaColors.background,
      appBar: AppBar(
        backgroundColor: YanYanaColors.surface,
        elevation: 0,
        leading: Semantics(
          label: 'Geri dön',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: YanYanaColors.textDark,
            onPressed: () => Navigator.pop(context),
            tooltip: 'Geri',
          ),
        ),
        title: Semantics(
          header: true,
          child: const Text(
            'Topluluk Odaları',
            style: TextStyle(
              color: YanYanaColors.textDark,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Semantics(
                label: 'Topluluk odaları açıklaması',
                child: const Text(
                  'Destek, mentorluk, sosyal katılım ve erişilebilirlik için '
                  'güvenli alanlar. Yerel örnek verilerle çalışır.',
                  style: TextStyle(
                    color: YanYanaColors.textMuted,
                    fontSize: 15,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _CategoryChips(
              selected: _selectedCategory,
              onSelected: (c) => setState(() => _selectedCategory = c),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: rooms.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          '“$_selectedCategory” için örnek oda bulunamadı.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: YanYanaColors.textMuted,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      itemCount: rooms.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        final joined = _joinedRoomIds.contains(room.id);
                        return CommunityRoomCard(
                          room: room,
                          joined: joined,
                          onOpen: () => _openRoom(room),
                          onJoin: () => _joinRoom(room),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _CategoryChips({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: MockCommunityRoomsData.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final c = MockCommunityRoomsData.categories[i];
          final isSelected = c == selected;
          return Semantics(
            label: '$c kategorisi${isSelected ? ", seçili" : ""}',
            button: true,
            selected: isSelected,
            child: GestureDetector(
              onTap: () => onSelected(c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? YanYanaColors.primary : YanYanaColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected ? YanYanaColors.primary : YanYanaColors.border,
                  ),
                  boxShadow: isSelected ? YanYanaShadows.soft : null,
                ),
                child: Text(
                  c,
                  style: TextStyle(
                    color: isSelected ? Colors.white : YanYanaColors.textMuted,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
