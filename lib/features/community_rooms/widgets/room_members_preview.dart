import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/shared/models/room_participant.dart';

/// Horizontal list of mock room participants.
class RoomMembersPreview extends StatelessWidget {
  final List<RoomParticipant> participants;

  const RoomMembersPreview({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 18, 20, 10),
          child: Text(
            'Odadaki üyeler',
            style: TextStyle(
              color: YanYanaColors.textDark,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          height: 108,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: participants.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              return _MemberChip(participant: participants[i]);
            },
          ),
        ),
      ],
    );
  }
}

class _MemberChip extends StatelessWidget {
  final RoomParticipant participant;

  const _MemberChip({required this.participant});

  Color get _avatarColor => Color(participant.avatarColorValue);

  Color get _statusColor {
    final s = participant.statusLabel.toLowerCase();
    if (s.contains('mentor')) return YanYanaColors.primary;
    if (s.contains('destek')) return YanYanaColors.warning;
    if (s.contains('dinliyor')) return YanYanaColors.secondary;
    return YanYanaColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${participant.name}, ${participant.statusLabel}',
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: YanYanaColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: YanYanaColors.border),
          boxShadow: YanYanaShadows.soft,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: _avatarColor.withValues(alpha: 0.18),
              child: Text(
                participant.initials,
                style: TextStyle(
                  color: _avatarColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              participant.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: YanYanaColors.textDark,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              participant.statusLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _statusColor,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
