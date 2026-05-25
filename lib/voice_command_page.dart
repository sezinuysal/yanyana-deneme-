import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:yanyana_p/core/theme/theme.dart';
import 'package:yanyana_p/live_caption_page.dart';
import 'package:yanyana_p/push_notification_page.dart';
import 'package:yanyana_p/safe_call_page.dart';

class VoiceCommandPage extends StatefulWidget {
  const VoiceCommandPage({super.key});

  @override
  State<VoiceCommandPage> createState() => _VoiceCommandPageState();
}

class _VoiceCommandPageState extends State<VoiceCommandPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;

  String _recognizedText = "Henüz bir komut algılanmadı.";
  String _commandResult = "Komut sonucu burada görünecek.";

  Future<void> _startListening() async {
    final bool available = await _speech.initialize();

    if (available) {
      setState(() {
        _isListening = true;
        _recognizedText = "Dinleniyor...";
        _commandResult = "Komut bekleniyor.";
      });

      _speech.listen(
        localeId: "tr_TR",
        onResult: (result) {
          if (!mounted) return;

          final command = result.recognizedWords.toLowerCase();

          setState(() {
            _recognizedText = result.recognizedWords;
          });

          _handleVoiceCommand(command);
        },
      );
    } else {
      setState(() {
        _recognizedText = "Mikrofon kullanılamıyor.";
        _commandResult = "Sesli komut başlatılamadı.";
      });
    }
  }

  void _handleVoiceCommand(String command) {
    if (command.trim().isEmpty) {
      setState(() {
        _commandResult = "Komut bekleniyor.";
      });
      return;
    }

    // SOS / Yardım
    if (command.contains("yardım") || command.contains("sos")) {
      setState(() {
        _commandResult = "Acil yardım komutu çalıştırıldı.";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Acil yardım bildirimi gönderildi."),
        ),
      );
    }

    // Güvenli Arama
    else if (command.contains("safe call") ||
        command.contains("güvenli arama") ||
        command.contains("arama")) {
      setState(() {
        _commandResult = "Safe Call ekranı açılıyor.";
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SafeCallPage(),
        ),
      );
    }

    // Canlı Altyazı
    else if (command.contains("altyazı")) {
      setState(() {
        _commandResult = "Canlı altyazı ekranı açılıyor.";
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LiveCaptionPage(),
        ),
      );
    }

    // Push Notification
    else if (command.contains("bildirim") ||
        command.contains("notification")) {
      setState(() {
        _commandResult = "Push notification ekranı açılıyor.";
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PushNotificationPage(),
        ),
      );
    }

    // Geri dön
    else if (command.contains("geri dön") ||
        command.contains("kapat")) {
      setState(() {
        _commandResult = "Sayfa kapatılıyor.";
      });

      Navigator.pop(context);
    }

    // Bilinmeyen komut
    else {
      setState(() {
        _commandResult =
            "Komut algılandı ancak eşleşen işlem bulunamadı.";
      });
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();

    if (!mounted) return;

    setState(() {
      _isListening = false;

      if (_recognizedText == "Dinleniyor...") {
        _recognizedText = "Herhangi bir komut algılanmadı.";
        _commandResult = "Komut tamamlanamadı.";
      }
    });
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      appBar: AppBar(
        backgroundColor: YanYanaColors.background,
        elevation: 0,
        title: const Text(
          "Sesli Komut",
          style: TextStyle(
            color: YanYanaColors.textDark,
            fontWeight: FontWeight.w900,
          ),
        ),
        iconTheme: const IconThemeData(
          color: YanYanaColors.textDark,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 120,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: _isListening ? 125 : 110,
                height: _isListening ? 125 : 110,
                decoration: BoxDecoration(
                  color: _isListening
                      ? YanYanaColors.sos.withOpacity(0.14)
                      : YanYanaColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isListening
                      ? Icons.hearing_rounded
                      : Icons.mic_rounded,
                  size: _isListening ? 60 : 55,
                  color: _isListening
                      ? YanYanaColors.sos
                      : YanYanaColors.primary,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Sesli Komut Sistemi",
                style: TextStyle(
                  color: YanYanaColors.textDark,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              const Text(
                "Kullanıcının uygulamayı sesli komutlarla daha kolay kullanmasını sağlar.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: YanYanaColors.textMuted,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: YanYanaColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: YanYanaShadows.card,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Algılanan Ses",
                      style: TextStyle(
                        color: YanYanaColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _recognizedText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: YanYanaColors.textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: YanYanaColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: YanYanaColors.primary.withOpacity(0.15),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Algılanan İşlem",
                      style: TextStyle(
                        color: YanYanaColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _commandResult,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: YanYanaColors.textDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient:
                        _isListening ? sosGradient : primaryGradient,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ElevatedButton.icon(
                    onPressed:
                        _isListening ? _stopListening : _startListening,
                    icon: Icon(
                      _isListening
                          ? Icons.stop_rounded
                          : Icons.keyboard_voice_rounded,
                    ),
                    label: Text(
                      _isListening
                          ? "Dinlemeyi Durdur"
                          : "Dinlemeyi Başlat",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}