import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import '../models/donation_model.dart';
import 'sponsor_list_screen.dart';
import 'donation_payment_screen.dart';
import 'donation_create_screen.dart';

class DonationHomeScreen extends StatefulWidget {
  const DonationHomeScreen({super.key});

  @override
  State<DonationHomeScreen> createState() => _DonationHomeScreenState();
}

class _DonationHomeScreenState extends State<DonationHomeScreen> {
  bool _isVolunteerMode = false; // Test amaçlı rol değiştirici

  List<DonationCampaign> get _filteredCampaigns {
    return mockCampaigns.where((campaign) {
      if (_isVolunteerMode) return true; // Gönüllü/Admin hepsini görür
      return campaign.status == CampaignStatus.active || campaign.status == CampaignStatus.completed;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // TabBar içinde düzgün durması için
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(_isVolunteerMode ? "Moderatör Modu (Gönüllü)" : "Normal Mod (Destekçi)", 
                  style: const TextStyle(fontSize: 12, color: YanYanaColors.textMuted, fontWeight: FontWeight.bold)),
                Switch(
                  value: _isVolunteerMode,
                  activeColor: YanYanaColors.primary,
                  onChanged: (val) => setState(() => _isVolunteerMode = val),
                ),
              ],
            ),
          ),
          // Sponsorlar Butonu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SponsorListScreen()));
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: supportGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: YanYanaShadows.soft,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.diversity_1, color: Colors.white, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Destekçilerimiz", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          Text("Bize güç katan sponsorlarımızı görün", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Güncel Kampanyalar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: YanYanaColors.textDark)),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filteredCampaigns.length,
              itemBuilder: (context, index) {
                return _buildCampaignCard(_filteredCampaigns[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _isVolunteerMode
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DonationCreateScreen()));
              },
              backgroundColor: YanYanaColors.secondary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Yeni Kampanya", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildCampaignCard(DonationCampaign campaign) {
    final bool isPending = campaign.status == CampaignStatus.pending;
    final bool isCompleted = campaign.status == CampaignStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: YanYanaColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: YanYanaShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kapak
          if (campaign.coverImageUrl != null)
            Image.network(
              campaign.coverImageUrl!,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          else
            Container(height: 140, color: YanYanaColors.secondaryLight),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPending)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(color: YanYanaColors.warning, borderRadius: BorderRadius.circular(12)),
                    child: const Text("Moderatör Onayı Bekliyor", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  )
                else if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(color: YanYanaColors.success, borderRadius: BorderRadius.circular(12)),
                    child: const Text("Hedefe Ulaşıldı! 🎉", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),

                Text(campaign.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: YanYanaColors.textDark)),
                const SizedBox(height: 6),
                Text(campaign.description, style: const TextStyle(fontSize: 14, color: YanYanaColors.textMuted, height: 1.4)),
                const SizedBox(height: 16),
                
                // İlerleme Barı
                LinearProgressIndicator(
                  value: campaign.progressPercentage,
                  minHeight: 8,
                  backgroundColor: YanYanaColors.surfaceSoft,
                  color: isCompleted ? YanYanaColors.success : YanYanaColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${campaign.collectedAmount.toInt()} ₺ toplandı", style: const TextStyle(fontWeight: FontWeight.bold, color: YanYanaColors.textDark, fontSize: 13)),
                    Text("Hedef: ${campaign.targetAmount.toInt()} ₺", style: const TextStyle(color: YanYanaColors.textMuted, fontSize: 13)),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                if (isPending && _isVolunteerMode)
                  GradientButton(
                    label: "Kampanyayı Onayla",
                    icon: Icons.check,
                    gradient: const LinearGradient(colors: [YanYanaColors.warning, Colors.orange]),
                    onPressed: () {
                      setState(() => campaign.status = CampaignStatus.active);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kampanya onaylandı ve yayına alındı!")));
                    },
                  )
                else if (!isCompleted)
                  GradientButton(
                    label: "Şimdi Bağış Yap",
                    icon: Icons.favorite,
                    gradient: primaryGradient,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DonationPaymentScreen(campaign: campaign)));
                    },
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
