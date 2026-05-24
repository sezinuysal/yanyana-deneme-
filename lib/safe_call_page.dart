import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';

class SafeCallPage extends StatefulWidget {
  const SafeCallPage({super.key});

  @override
  State<SafeCallPage> createState() => _SafeCallPageState();
}

class _SafeCallPageState extends State<SafeCallPage> {
  String selectedContact = "Anne";
  String selectedNumber = "0555 111 22 33";

  final List<Map<String, String>> emergencyContacts = [
    {"name": "Anne", "number": "0555 111 22 33"},
    {"name": "Baba", "number": "0555 444 55 66"},
    {"name": "Yakın Arkadaş", "number": "0555 777 88 99"},
  ];

  void selectContact(String name, String number) {
    setState(() {
      selectedContact = name;
      selectedNumber = number;
    });
  }

  void startSafeCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$selectedContact aranıyor: $selectedNumber"),
      ),
    );
  }

  void sendEmergencyAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$selectedContact kişisine acil destek bildirimi gönderildi."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      appBar: AppBar(
        backgroundColor: YanYanaColors.background,
        elevation: 0,
        title: const Text("Safe Call"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: YanYanaColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.call_rounded,
                size: 55,
                color: YanYanaColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Safe Call",
            style: TextStyle(
              color: YanYanaColors.textDark,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          const Text(
            "Güvenli arama için acil durumda ulaşılacak kişiyi seçebilirsiniz.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: YanYanaColors.textMuted,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Acil Kişiler",
            style: TextStyle(
              color: YanYanaColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          ...emergencyContacts.map((contact) {
            final bool isSelected = contact["name"] == selectedContact;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: YanYanaColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: YanYanaShadows.card,
                border: Border.all(
                  color: isSelected
                      ? YanYanaColors.primary.withValues(alpha: 0.45)
                      : Colors.transparent,
                ),
              ),
              child: ListTile(
                leading: Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.person_outline_rounded,
                  color: isSelected
                      ? YanYanaColors.primary
                      : YanYanaColors.textMuted,
                ),
                title: Text(
                  contact["name"]!,
                  style: const TextStyle(
                    color: YanYanaColors.textDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: Text(
                  contact["number"]!,
                  style: const TextStyle(
                    color: YanYanaColors.textMuted,
                  ),
                ),
                onTap: () {
                  selectContact(
                    contact["name"]!,
                    contact["number"]!,
                  );
                },
              ),
            );
          }),

          const SizedBox(height: 15),

          Container(
            decoration: BoxDecoration(
              color: YanYanaColors.surface,
              borderRadius: BorderRadius.circular(22),
              boxShadow: YanYanaShadows.card,
            ),
            child: ListTile(
              leading: const Icon(
                Icons.verified_user_rounded,
                color: YanYanaColors.primary,
              ),
              title: const Text(
                "Seçilen Acil Kişi",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: YanYanaColors.textDark,
                ),
              ),
              subtitle: Text(
                "$selectedContact - $selectedNumber",
                style: const TextStyle(
                  color: YanYanaColors.textMuted,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: primaryGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ElevatedButton.icon(
                onPressed: startSafeCall,
                icon: const Icon(Icons.phone_rounded),
                label: const Text("Güvenli Aramayı Başlat"),
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

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: sosGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ElevatedButton.icon(
                onPressed: sendEmergencyAlert,
                icon: const Icon(Icons.warning_rounded),
                label: const Text("Acil Destek Bildir"),
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
    );
  }
}