import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import '../models/guide_model.dart';

class GuideDetailScreen extends StatefulWidget {
  final Guide guide;
  
  const GuideDetailScreen({super.key, required this.guide});

  @override
  State<GuideDetailScreen> createState() => _GuideDetailScreenState();
}

class _GuideDetailScreenState extends State<GuideDetailScreen> {
  void _toggleStepCompleted(GuideStep step) {
    setState(() {
      step.isCompleted = !step.isCompleted;
      widget.guide.completedStepsCount = widget.guide.steps.where((s) => s.isCompleted).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      appBar: AppBar(
        backgroundColor: YanYanaColors.surface,
        title: Text(widget.guide.title, style: const TextStyle(fontWeight: FontWeight.bold, color: YanYanaColors.textDark, fontSize: 18)),
        iconTheme: const IconThemeData(color: YanYanaColors.textDark),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, size: 24, color: YanYanaColors.primary),
            tooltip: "Paylaş",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Paylaşım menüsü açıldı (Mock)")));
            },
          ),
          IconButton(
            icon: Icon(
              widget.guide.isFavorite ? Icons.favorite : Icons.favorite_border, 
              color: widget.guide.isFavorite ? YanYanaColors.sos : YanYanaColors.primary,
              size: 28,
            ),
            tooltip: "Favorilere Ekle",
            onPressed: () {
              setState(() {
                widget.guide.isFavorite = !widget.guide.isFavorite;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.guide.coverImageUrl != null)
              Image.network(
                widget.guide.coverImageUrl!,
                height: 250,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 200,
                color: YanYanaColors.primaryLight,
                child: const Icon(Icons.menu_book, size: 80, color: YanYanaColors.primary),
              ),
              
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.guide.isApproved)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: YanYanaColors.warning.withValues(alpha: 0.1),
                        border: Border.all(color: YanYanaColors.warning, width: 1.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: YanYanaColors.warning, size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Moderasyon Bekliyor", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: YanYanaColors.warning)),
                                const SizedBox(height: 4),
                                const Text("Bu içerik henüz yayında değil. Doğrulayıcı onayı bekliyor.", style: TextStyle(fontSize: 13, color: YanYanaColors.textDark)),
                                const SizedBox(height: 12),
                                GradientButton(
                                  height: 48,
                                  label: "İçeriği Onayla (Yayınla)",
                                  icon: Icons.check,
                                  gradient: const LinearGradient(colors: [YanYanaColors.warning, Colors.orange]),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Rehber onaylandı ve yayına alındı!")));
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  
                  Text(widget.guide.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: YanYanaColors.textDark)),
                  const SizedBox(height: 12),
                  Text(widget.guide.description, style: const TextStyle(fontSize: 15, height: 1.5, color: YanYanaColors.textMuted)),
                  
                  const SizedBox(height: 24),
                  
                  LinearProgressIndicator(
                    value: widget.guide.progressPercentage,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                    backgroundColor: YanYanaColors.surfaceSoft,
                    color: YanYanaColors.success,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${widget.guide.completedStepsCount} / ${widget.guide.steps.length} Adım Tamamlandı",
                    style: const TextStyle(fontWeight: FontWeight.w800, color: YanYanaColors.success, fontSize: 14),
                  ),

                  const SizedBox(height: 32),
                  const Text("Adımlar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: YanYanaColors.textDark)),
                  const SizedBox(height: 16),

                  ...widget.guide.steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return _buildStepCard(step, index + 1);
                  }),
                  
                  const SizedBox(height: 32),
                  
                  Center(
                    child: Column(
                      children: [
                        const Text("Bu rehber sana yardımcı oldu mu?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: YanYanaColors.textDark)),
                        const SizedBox(height: 16),
                        GradientButton(
                          label: "Evet, faydalı (${widget.guide.likes})",
                          icon: Icons.thumb_up_alt_rounded,
                          gradient: supportGradient,
                          onPressed: () {
                            setState(() {
                              widget.guide.likes++;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Geri bildiriminiz için teşekkürler!")));
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(GuideStep step, int stepNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: step.isCompleted ? YanYanaColors.surfaceSoft : YanYanaColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: step.isCompleted ? Border.all(color: YanYanaColors.success.withValues(alpha: 0.5), width: 2) : Border.all(color: Colors.transparent, width: 2),
        boxShadow: step.isCompleted ? [] : YanYanaShadows.soft,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: step.isCompleted ? YanYanaColors.success : YanYanaColors.primaryLight,
                  child: Text(
                    stepNumber.toString(), 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: step.isCompleted ? Colors.white : YanYanaColors.primary)
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w900,
                      decoration: step.isCompleted ? TextDecoration.lineThrough : null,
                      color: step.isCompleted ? YanYanaColors.textLight : YanYanaColors.textDark,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, size: 28),
                  color: YanYanaColors.accentBlue,
                  tooltip: "Sesli Oku",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("'${step.title}' sesli okunuyor...")));
                  },
                )
              ],
            ),
            const SizedBox(height: 12),
            if (step.imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(step.imageUrl!, height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
              ),
            Text(
              step.description,
              style: TextStyle(
                fontSize: 15, 
                height: 1.5,
                color: step.isCompleted ? YanYanaColors.textLight : YanYanaColors.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(
              height: 50,
              label: step.isCompleted ? "Adımı Tamamladım" : "Bu Adımı Yaptım",
              icon: step.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              gradient: step.isCompleted 
                ? const LinearGradient(colors: [YanYanaColors.success, Color(0xFF16A34A)]) 
                : primaryGradient,
              onPressed: () => _toggleStepCompleted(step),
            )
          ],
        ),
      ),
    );
  }
}

