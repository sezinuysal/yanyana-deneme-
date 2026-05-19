import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:yanyana_p/core/theme/theme.dart';

class ShakeHelpPage extends StatefulWidget {
  const ShakeHelpPage({super.key});

  @override
  State<ShakeHelpPage> createState() => _ShakeHelpPageState();
}

class _ShakeHelpPageState extends State<ShakeHelpPage> {
  ShakeDetector? detector;
  bool isActivated = false;

  @override
  void initState() {
    super.initState();

    detector = ShakeDetector.autoStart(
      onPhoneShake: (ShakeEvent event) {
        if (!isActivated) return;
        sendHelpAlert();
      },
    );

    detector?.stopListening();
  }

  void sendHelpAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Yardım bildirimi gönderildi."),
      ),
    );
  }

  @override
  void dispose() {
    detector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      appBar: AppBar(
        backgroundColor: YanYanaColors.background,
        elevation: 0,
        title: const Text("Shake for Help"),
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
                Icons.vibration_rounded,
                size: 55,
                color: YanYanaColors.primary,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Shake for Help",
              style: TextStyle(
                color: YanYanaColors.textDark,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Telefon sallandığında hızlı yardım bildirimi gönderilir.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: YanYanaColors.textMuted,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                color: YanYanaColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: YanYanaShadows.card,
              ),
              child: SwitchListTile(
                value: isActivated,
                activeColor: YanYanaColors.primary,
                title: const Text(
                  "Shake Detection",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: const Text(
                  "Telefon sallanınca yardım bildirimi gönder",
                ),
                secondary: const Icon(Icons.phone_android_rounded),
                onChanged: (value) {
                  setState(() {
                    isActivated = value;
                  });

                  if (value) {
                    detector?.startListening();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Shake Detection aktif edildi."),
                      ),
                    );
                  } else {
                    detector?.stopListening();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Shake Detection kapatıldı."),
                      ),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ElevatedButton.icon(
                  onPressed: sendHelpAlert,
                  icon: const Icon(Icons.notification_important_rounded),
                  label: const Text("Test Yardım Bildirimi Gönder"),
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

            const SizedBox(height: 24),

            const Text(
              "Gerçek sallama algılama fiziksel telefon cihazlarında test edilmelidir.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: YanYanaColors.textMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}