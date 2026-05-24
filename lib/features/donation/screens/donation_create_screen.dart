import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';

class DonationCreateScreen extends StatefulWidget {
  const DonationCreateScreen({super.key});

  @override
  State<DonationCreateScreen> createState() => _DonationCreateScreenState();
}

class _DonationCreateScreenState extends State<DonationCreateScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _targetAmountCtrl = TextEditingController();
  
  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _targetAmountCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleCtrl.text.isEmpty || _descCtrl.text.isEmpty || _targetAmountCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun.")),
      );
      return;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Kampanya başarıyla oluşturuldu! Moderatör onayından sonra yayına alınacaktır."),
        duration: Duration(seconds: 4),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      appBar: AppBar(
        backgroundColor: YanYanaColors.surface,
        title: const Text('Yeni Kampanya Oluştur', style: TextStyle(fontWeight: FontWeight.bold, color: YanYanaColors.textDark, fontSize: 18)),
        iconTheme: const IconThemeData(color: YanYanaColors.textDark),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kampanya Bilgileri",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: YanYanaColors.textDark),
            ),
            const SizedBox(height: 16),
            YanYanaTextField(
              controller: _titleCtrl,
              label: "Kampanya Başlığı",
              hint: "Örn: Akülü Tekerlekli Sandalye Desteği",
              icon: Icons.title,
            ),
            const SizedBox(height: 16),
            YanYanaTextField(
              controller: _descCtrl,
              label: "Kampanya Açıklaması",
              hint: "Kampanyanın amacını ve kime ulaşacağını anlatın",
              icon: Icons.description,
            ),
            const SizedBox(height: 16),
            YanYanaTextField(
              controller: _targetAmountCtrl,
              label: "Hedeflenen Tutar (₺)",
              hint: "Örn: 15000",
              icon: Icons.track_changes_rounded,
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: YanYanaColors.primaryLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: YanYanaColors.primaryLight),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: YanYanaColors.primary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Oluşturduğunuz kampanyalar sistem güvenliği gereği yetkili adminler tarafından incelendikten sonra yayına alınır.",
                      style: TextStyle(color: YanYanaColors.primaryDark, fontSize: 13, height: 1.4),
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            GradientButton(
              label: "Kampanyayı Onaya Gönder",
              icon: Icons.send_rounded,
              gradient: const LinearGradient(colors: [YanYanaColors.secondary, YanYanaColors.accentBlue]),
              onPressed: _submit,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
