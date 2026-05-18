import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import '../models/guide_model.dart';

class GuideCreateScreen extends StatefulWidget {
  const GuideCreateScreen({super.key});

  @override
  State<GuideCreateScreen> createState() => _GuideCreateScreenState();
}

class _GuideCreateScreenState extends State<GuideCreateScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  GuideCategory _category = GuideCategory.dailyTasks;
  final List<TextEditingController> _stepCtrls = [TextEditingController()];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    for (var ctrl in _stepCtrls) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _addStep() {
    setState(() {
      _stepCtrls.add(TextEditingController());
    });
  }

  void _removeStep(int index) {
    if (_stepCtrls.length > 1) {
      setState(() {
        _stepCtrls[index].dispose();
        _stepCtrls.removeAt(index);
      });
    }
  }

  void _submit() {
    if (_titleCtrl.text.isEmpty || _descCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Başlık ve açıklama zorunludur.")),
      );
      return;
    }
    
    // Gönüllü oluşturduğunda otomatik onaya düşmesi (isApproved = false)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Rehber başarıyla oluşturuldu! Moderatör onayından sonra yayına alınacaktır."),
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
        title: const Text('Yeni Rehber Oluştur', style: TextStyle(fontWeight: FontWeight.bold, color: YanYanaColors.textDark, fontSize: 18)),
        iconTheme: const IconThemeData(color: YanYanaColors.textDark),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rehber Bilgileri",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: YanYanaColors.textDark),
            ),
            const SizedBox(height: 16),
            YanYanaTextField(
              controller: _titleCtrl,
              label: "Rehber Başlığı",
              hint: "Örn: Otobüse Nasıl Binilir?",
              icon: Icons.title,
            ),
            const SizedBox(height: 16),
            YanYanaTextField(
              controller: _descCtrl,
              label: "Kısa Açıklama",
              hint: "Rehberin amacını anlatın",
              icon: Icons.description,
            ),
            const SizedBox(height: 16),
            
            // Kategori Seçimi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: YanYanaColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: YanYanaColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<GuideCategory>(
                  value: _category,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: YanYanaColors.primary),
                  style: const TextStyle(color: YanYanaColors.textDark, fontSize: 15, fontWeight: FontWeight.w600),
                  items: const [
                    DropdownMenuItem(value: GuideCategory.dailyTasks, child: Text("Günlük İşler")),
                    DropdownMenuItem(value: GuideCategory.recipes, child: Text("Yemek Tarifleri")),
                    DropdownMenuItem(value: GuideCategory.socialSkills, child: Text("Sosyal Beceriler")),
                    DropdownMenuItem(value: GuideCategory.other, child: Text("Diğer")),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _category = val);
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            const Text(
              "Adımlar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: YanYanaColors.textDark),
            ),
            const SizedBox(height: 8),
            const Text(
              "Rehberi uygulamak için gereken işlemleri adım adım yazın.",
              style: TextStyle(fontSize: 13, color: YanYanaColors.textMuted),
            ),
            const SizedBox(height: 16),
            
            ..._stepCtrls.asMap().entries.map((entry) {
              int idx = entry.key;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: YanYanaColors.primaryLight,
                      child: Text("${idx + 1}", style: const TextStyle(color: YanYanaColors.primary, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: YanYanaTextField(
                        controller: entry.value,
                        label: "Adım ${idx + 1}",
                        hint: "Adım açıklamasını yazın...",
                        icon: Icons.list,
                      ),
                    ),
                    if (_stepCtrls.length > 1)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: YanYanaColors.sos),
                        onPressed: () => _removeStep(idx),
                      )
                  ],
                ),
              );
            }),
            
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _addStep,
              icon: const Icon(Icons.add_circle, color: YanYanaColors.secondary),
              label: const Text("Yeni Adım Ekle", style: TextStyle(color: YanYanaColors.secondary, fontWeight: FontWeight.bold)),
            ),
            
            const SizedBox(height: 40),
            GradientButton(
              label: "Rehberi Onaya Gönder",
              icon: Icons.send_rounded,
              onPressed: _submit,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
