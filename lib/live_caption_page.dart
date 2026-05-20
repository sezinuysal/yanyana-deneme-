import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:yanyana_p/core/theme/theme.dart';

class LiveCaptionPage extends StatefulWidget {
  const LiveCaptionPage({super.key});

  @override
  State<LiveCaptionPage> createState() => _LiveCaptionPageState();
}

class _LiveCaptionPageState extends State<LiveCaptionPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;
  String _captionText = "Henüz konuşma algılanmadı.";

  Future<void> _startCaptioning() async {
    final bool available = await _speech.initialize();

    if (available) {
      setState(() {
        _isListening = true;
        _captionText = "Dinleniyor...";
      });

      _speech.listen(
        localeId: "tr_TR",
        onResult: (result) {
          setState(() {
            _captionText = result.recognizedWords;
          });
        },
      );
    } else {
      setState(() {
        _captionText = "Mikrofon kullanılamıyor.";
      });
    }
  }

  Future<void> _stopCaptioning() async {
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
        title: const Text("Canlı Altyazı"),
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
                color: YanYanaColors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.closed_caption_rounded,
                size: 55,
                color: YanYanaColors.primary,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Canlı Altyazı Sistemi",
              style: TextStyle(
                color: YanYanaColors.textDark,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            const Text(
              "Konuşmaları gerçek zamanlı olarak altyazıya dönüştürür.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: YanYanaColors.textMuted,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: YanYanaColors.surface,
                borderRadius: BorderRadius.circular(22),
                boxShadow: YanYanaShadows.card,
              ),
              child: Text(
                _captionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: YanYanaColors.textDark,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
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
                  onPressed: _isListening ? _stopCaptioning : _startCaptioning,
                  icon: Icon(
                    _isListening
                        ? Icons.stop_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  label: Text(
                    _isListening
                        ? "Altyazıyı Durdur"
                        : "Canlı Altyazıyı Başlat",
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