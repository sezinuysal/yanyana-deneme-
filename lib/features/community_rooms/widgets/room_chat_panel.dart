import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/features/community_rooms/widgets/room_message_bubble.dart';
import 'package:yanyana_p/shared/models/room_message.dart';

/// Bordered chat message list for room detail demo.
class RoomChatPanel extends StatelessWidget {
  final List<RoomMessage> messages;
  final bool joined;

  const RoomChatPanel({
    super.key,
    required this.messages,
    required this.joined,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 160),
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        decoration: BoxDecoration(
          color: YanYanaColors.surfaceSoft,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: YanYanaColors.border),
        ),
        child: messages.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    joined
                        ? 'Henüz mesaj yok. İlk destekleyici mesajı sen yaz.'
                        : 'Sohbeti görmek ve yazmak için önce odaya katılın.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: YanYanaColors.textMuted,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                  ),
                ),
              )
            : Column(
                children: messages
                    .map(
                      (m) => RoomMessageBubble(
                        message: m,
                        showAuthor: !m.isFromMe,
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
