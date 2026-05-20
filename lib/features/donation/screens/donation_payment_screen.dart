import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import '../models/donation_model.dart';

class DonationPaymentScreen extends StatefulWidget {
  final DonationCampaign campaign;
  const DonationPaymentScreen({super.key, required this.campaign});

  @override
  State<DonationPaymentScreen> createState() => _DonationPaymentScreenState();
}

class _DonationPaymentScreenState extends State<DonationPaymentScreen> {
  final _amountCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      appBar: AppBar(
        backgroundColor: YanYanaColors.surface,
        title: const Text('Bağış Yap', style: TextStyle(fontWeight: FontWeight.bold, color: YanYanaColors.textDark, fontSize: 18)),
        iconTheme: const IconThemeData(color: YanYanaColors.textDark),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: YanYanaColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: YanYanaShadows.soft,
              ),
              child: Column(
                children: [
                  const Icon(Icons.favorite, color: YanYanaColors.sos, size: 48),
                  const SizedBox(height: 12),
                  Text(widget.campaign.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: YanYanaColors.textDark), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text("Desteğinizle birilerinin hayatına dokunuyorsunuz.", style: TextStyle(color: YanYanaColors.textMuted, fontSize: 14), textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("Bağış Miktarı (₺)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: YanYanaColors.textDark)),
            const SizedBox(height: 12),
            YanYanaTextField(
              controller: _amountCtrl,
              label: "Miktar",
              hint: "Örn: 100",
              icon: Icons.payments,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildAmountChip("50"),
                _buildAmountChip("100"),
                _buildAmountChip("200"),
                _buildAmountChip("500"),
              ],
            ),
            const SizedBox(height: 40),
            GradientButton(
              label: "Bağışı Tamamla",
              icon: Icons.check_circle_outline,
              onPressed: () {
                if (_amountCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen bir miktar girin.")));
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Teşekkürler! ${widget.campaign.title} için bağışınız (Mock) alındı.")),
                );
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAmountChip(String amount) {
    return ActionChip(
      label: Text("$amount ₺", style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: YanYanaColors.primaryLight,
      onPressed: () {
        setState(() {
          _amountCtrl.text = amount;
        });
      },
    );
  }
}
