import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Fizik tedavi hatırlatıcı bildirimleri için servis.
class PhysioNotificationService {
  PhysioNotificationService._();

  static final PhysioNotificationService instance =
      PhysioNotificationService._();

  static const _prefKeyHour = 'physio_reminder_hour';
  static const _prefKeyMinute = 'physio_reminder_minute';
  static const _prefKeyEnabled = 'physio_reminder_enabled';
  static const _notifId = 42;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // ── Başlatma ─────────────────────────────────────────────
  Future<void> ensureInitialized() async {
    if (_initialized) return;
    try {
      tz_data.initializeTimeZones();

      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwin = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const settings =
          InitializationSettings(android: android, iOS: darwin, macOS: darwin);

      await _plugin.initialize(settings);
      _initialized = true;
    } catch (e) {
      debugPrint('PhysioNotif init hata: $e');
    }
  }

  // ── Kaydedilmiş ayarları oku ─────────────────────────────
  Future<({int hour, int minute, bool enabled})> getSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      hour: prefs.getInt(_prefKeyHour) ?? 9,
      minute: prefs.getInt(_prefKeyMinute) ?? 0,
      enabled: prefs.getBool(_prefKeyEnabled) ?? false,
    );
  }

  // ── Günlük tekrarlayan hatırlatıcı planla ────────────────
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
  }) async {
    await ensureInitialized();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefKeyHour, hour);
      await prefs.setInt(_prefKeyMinute, minute);
      await prefs.setBool(_prefKeyEnabled, true);

      await _plugin.cancel(_notifId);

      // Android/iOS için izin iste
      if (!kIsWeb && Platform.isAndroid) {
        await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }

      final now = tz.TZDateTime.now(tz.local);
      var scheduled = tz.TZDateTime(
          tz.local, now.year, now.month, now.day, hour, minute);
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      const androidDetails = AndroidNotificationDetails(
        'physio_reminder',
        'Fizik Tedavi Hatırlatıcı',
        channelDescription: 'Günlük egzersiz hatırlatıcı',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      const details = NotificationDetails(
          android: androidDetails, iOS: darwinDetails, macOS: darwinDetails);

      await _plugin.zonedSchedule(
        _notifId,
        '💪 Egzersiz Zamanı!',
        'Bugünkü fizik tedavi egzersizini yapmayı unutma.',
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('Hatırlatıcı planlama hatası: $e');
    }
  }

  // ── İptal et ─────────────────────────────────────────────
  Future<void> cancel() async {
    await ensureInitialized();
    try {
      await _plugin.cancel(_notifId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKeyEnabled, false);
    } catch (e) {
      debugPrint('Hatırlatıcı iptal hatası: $e');
    }
  }
}
