import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';

/// Message input bar with validation feedback.
class RoomChatComposer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;

  const RoomChatComposer({
    super.key,
    required this.controller,
    required this.onSend,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: YanYanaColors.surface,
      elevation: 8,
      shadowColor: Colors.black26,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          12 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Semantics(
                label: 'Mesaj yaz',
                textField: true,
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  minLines: 1,
                  maxLines: 4,
                  style: const TextStyle(
                    color: YanYanaColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: enabled
                        ? 'Destekleyici bir mesaj yazın…'
                        : 'Sohbet için önce odaya katılın',
                    hintStyle: const TextStyle(
                      color: YanYanaColors.textLight,
                      fontSize: 15,
                    ),
                    filled: true,
                    fillColor: YanYanaColors.surfaceSoft,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
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
                      borderSide: const BorderSide(
                        color: YanYanaColors.primary,
                        width: 2,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: YanYanaColors.border.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: enabled ? (_) => onSend() : null,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Semantics(
              label: 'Mesajı gönder',
              button: true,
              child: SizedBox(
                width: 52,
                height: 52,
                child: FilledButton(
                  onPressed: enabled ? onSend : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: YanYanaColors.primary,
                    disabledBackgroundColor:
                        YanYanaColors.primary.withValues(alpha: 0.35),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    size: 24,
                    semanticLabel: 'Gönder',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
