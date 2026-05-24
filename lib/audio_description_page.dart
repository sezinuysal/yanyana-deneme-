import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:yanyana_p/core/theme/theme.dart';

class AudioDescriptionPage extends StatefulWidget {
  const AudioDescriptionPage({super.key});

  @override
  State<AudioDescriptionPage> createState() => _AudioDescriptionPageState();
}

class _AudioDescriptionPageState extends State<AudioDescriptionPage> {
  final FlutterTts flutterTts = FlutterTts();

  final String demoText =
      "YanYana uygulamasına hoş geldiniz. "
      "Bu özellik ekran içeriklerini sesli şekilde kullanıcıya aktarır.";

  bool isSpeaking = false;

  Future<void> speakText() async {
    await flutterTts.setLanguage("tr-TR");
    await flutterTts.setSpeechRate(0.45);

    setState(() {
      isSpeaking = true;
    });

    await flutterTts.speak(demoText);
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();

    setState(() {
      isSpeaking = false;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      appBar: AppBar(
        backgroundColor: YanYanaColors.background,
        elevation: 0,
        title: const Text("Sesli Betimleme"),
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
              child: const Icon(
                Icons.record_voice_over_rounded,
                size: 55,
                color: YanYanaColors.primary,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Sesli Betimleme",
              style: TextStyle(
                color: YanYanaColors.textDark,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            const Text(
              "Ekran içeriklerini kullanıcıya sesli olarak aktarır.",
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
                demoText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: YanYanaColors.textDark,
                  fontSize: 15.5,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: isSpeaking ? sosGradient : primaryGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ElevatedButton.icon(
                  onPressed: isSpeaking ? stopSpeaking : speakText,
                  icon: Icon(
                    isSpeaking
                        ? Icons.stop_rounded
                        : Icons.volume_up_rounded,
                  ),
                  label: Text(
                    isSpeaking
                        ? "Seslendirmeyi Durdur"
                        : "Metni Seslendir",
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