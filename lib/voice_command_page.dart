import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:yanyana_p/core/theme/theme.dart';

class VoiceCommandPage extends StatefulWidget {
  const VoiceCommandPage({super.key});

  @override
  State<VoiceCommandPage> createState() => _VoiceCommandPageState();
}

class _VoiceCommandPageState extends State<VoiceCommandPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;
  String _recognizedText = "Henüz bir komut algılanmadı.";

  Future<void> _startListening() async {
    final bool available = await _speech.initialize();

    if (available) {
      setState(() {
        _isListening = true;
        _recognizedText = "Dinleniyor...";
      });

      _speech.listen(
        localeId: "tr_TR",
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
          });
        },
      );
    } else {
      setState(() {
        _recognizedText = "Mikrofon kullanılamıyor.";
      });
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();

    setState(() {
      _isListening = false;
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
        title: const Text("Sesli Komut"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: YanYanaColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isListening ? Icons.hearing_rounded : Icons.mic_rounded,
                size: 55,
                color: YanYanaColors.primary,
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
              child: Text(
                _recognizedText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: YanYanaColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: _isListening ? sosGradient : primaryGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ElevatedButton.icon(
                  onPressed: _isListening ? _stopListening : _startListening,
                  icon: Icon(
                    _isListening
                        ? Icons.stop_rounded
                        : Icons.keyboard_voice_rounded,
                  ),
                  label: Text(
                    _isListening ? "Dinlemeyi Durdur" : "Dinlemeyi Başlat",
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
    );
  }
}