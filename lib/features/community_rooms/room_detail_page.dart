import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/features/community_rooms/data/mock_community_rooms_data.dart';
import 'package:yanyana_p/features/community_rooms/widgets/room_actions_bar.dart';
import 'package:yanyana_p/features/community_rooms/widgets/room_activity_bar.dart';
import 'package:yanyana_p/features/community_rooms/widgets/room_chat_composer.dart';
import 'package:yanyana_p/features/community_rooms/widgets/room_chat_panel.dart';
import 'package:yanyana_p/features/community_rooms/widgets/room_community_guidelines.dart';
import 'package:yanyana_p/features/community_rooms/widgets/room_detail_header.dart';
import 'package:yanyana_p/features/community_rooms/widgets/room_members_preview.dart';
import 'package:yanyana_p/features/community_rooms/widgets/room_purpose_section.dart';
import 'package:yanyana_p/shared/models/community_room.dart';
import 'package:yanyana_p/shared/models/room_message.dart';

/// Mock room detail with local chat (no Firebase).
///
/// Distinct from the Firebase-backed detail page under `features/rooms/`.
class RoomDetailPage extends StatefulWidget {
  final CommunityRoom room;
  final bool initiallyJoined;
  final ValueChanged<bool>? onJoinChanged;

  const RoomDetailPage({
    super.key,
    required this.room,
    this.initiallyJoined = false,
    this.onJoinChanged,
  });

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  late bool isJoined;
  late bool _muted;
  late int currentMemberCount;
  late List<RoomMessage> _messages;
  final _messageCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  int _messageSeq = 0;

  @override
  void initState() {
    super.initState();
    isJoined = widget.initiallyJoined;
    _muted = false;
    currentMemberCount = widget.room.memberCount;
    if (widget.initiallyJoined) {
      currentMemberCount += 1;
    }
    _messages = MockCommunityRoomsData.seedMessagesFor(widget.room.id);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollCtrl.hasClients) return;
    final target = _scrollCtrl.position.maxScrollExtent;
    if (animated) {
      _scrollCtrl.animateTo(
        target,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scrollCtrl.jumpTo(target);
    }
  }

  void _toggleJoin() {
    if (isJoined) {
      _setJoined(false);
    } else {
      _setJoined(true);
    }
  }

  void _setJoined(bool value) {
    setState(() {
      if (value && !isJoined) {
        currentMemberCount += 1;
      } else if (!value && isJoined) {
        currentMemberCount = (currentMemberCount - 1).clamp(
          widget.room.memberCount,
          999999,
        );
      }
      isJoined = value;
    });
    widget.onJoinChanged?.call(value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? '${widget.room.title} odasına katıldınız (yerel).'
              : 'Odadan ayrıldınız (yerel).',
        ),
      ),
    );
  }

  void _joinRoom() => _setJoined(true);

  void _leaveRoom() => _setJoined(false);

  void _toggleMute() {
    setState(() => _muted = !_muted);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _muted
              ? 'Bildirimler sessize alındı (yerel).'
              : 'Bildirimler açıldı (yerel).',
        ),
      ),
    );
  }

  void _reportRoom() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Odayı Bildir',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: const Text(
          'Bu özellik yerel prototipte simüle edilir. '
          'Gerçek uygulamada moderasyon ekibine iletilecektir.',
          style: TextStyle(height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bildiriminiz alındı (yerel simülasyon).'),
                ),
              );
            },
            child: const Text('Gönder'),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageCtrl.text.trim();
    if (!isJoined) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mesaj göndermek için önce odaya katılın.')),
      );
      return;
    }
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir mesaj yazın.')),
      );
      return;
    }

    setState(() {
      _messageSeq++;
      _messages.add(
        RoomMessage(
          id: 'local-$_messageSeq',
          roomId: widget.room.id,
          authorName: MockCommunityRoomsData.currentUserName,
          text: text,
          sentAt: DateTime.now(),
          isFromMe: true,
        ),
      );
    });
    _messageCtrl.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    final participants = MockCommunityRoomsData.participantsFor(room.id);
    final purpose = MockCommunityRoomsData.purposeFor(room.id);

    return Scaffold(
      backgroundColor: YanYanaColors.background,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollCtrl,
              slivers: [
                SliverToBoxAdapter(
                  child: RoomDetailHeader(
                    room: room,
                    memberCount: currentMemberCount,
                    joined: isJoined,
                    onBack: () => Navigator.pop(context),
                    onJoinToggle: _toggleJoin,
                  ),
                ),
                SliverToBoxAdapter(
                  child: RoomActivityBar(
                    memberCount: currentMemberCount,
                    chatActive: _messages.isNotEmpty,
                  ),
                ),
                SliverToBoxAdapter(
                  child: RoomPurposeSection(purposeText: purpose),
                ),
                const SliverToBoxAdapter(
                  child: RoomCommunityGuidelines(
                    rules: MockCommunityRoomsData.communityGuidelineRules,
                  ),
                ),
                SliverToBoxAdapter(
                  child: RoomMembersPreview(participants: participants),
                ),
                SliverToBoxAdapter(
                  child: RoomActionsBar(
                    joined: isJoined,
                    muted: _muted,
                    onJoin: _joinRoom,
                    onLeave: _leaveRoom,
                    onReport: _reportRoom,
                    onToggleMute: _toggleMute,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Row(
                      children: [
                        const Text(
                          'Sohbet',
                          style: TextStyle(
                            color: YanYanaColors.textDark,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_messages.length} mesaj',
                          style: const TextStyle(
                            color: YanYanaColors.textMuted,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: RoomChatPanel(
                    messages: _messages,
                    joined: isJoined,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
              ],
            ),
          ),
          RoomChatComposer(
            controller: _messageCtrl,
            onSend: _sendMessage,
            enabled: isJoined,
          ),
        ],
      ),
    );
  }
}
