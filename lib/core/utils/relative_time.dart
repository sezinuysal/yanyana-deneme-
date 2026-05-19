/// Short relative time labels for feeds (Turkish).
String formatRelativeTime(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inMinutes < 1) return 'Az önce';
  if (diff.inMinutes < 60) return '${diff.inMinutes.clamp(1, 999)} dk önce';
  if (diff.inHours < 24) return '${diff.inHours} sa önce';
  if (diff.inDays == 1) return 'Dün';
  if (diff.inDays < 7) return '${diff.inDays} gün önce';
  final d = dateTime.day.toString().padLeft(2, '0');
  final m = dateTime.month.toString().padLeft(2, '0');
  return '$d.$m.${dateTime.year}';
}
