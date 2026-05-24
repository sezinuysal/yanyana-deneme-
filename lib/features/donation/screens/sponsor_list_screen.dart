import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import '../models/donation_model.dart';

class SponsorListScreen extends StatelessWidget {
  const SponsorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      appBar: AppBar(
        backgroundColor: YanYanaColors.surface,
        title: const Text('Destekçilerimiz', style: TextStyle(fontWeight: FontWeight.bold, color: YanYanaColors.textDark, fontSize: 18)),
        iconTheme: const IconThemeData(color: YanYanaColors.textDark),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: mockSponsors.length,
        itemBuilder: (context, index) {
          final sponsor = mockSponsors[index];
          return _buildSponsorCard(sponsor);
        },
      ),
    );
  }

  Widget _buildSponsorCard(Sponsor sponsor) {
    Color tierColor;
    if (sponsor.tier.contains("Altın")) {
      tierColor = YanYanaColors.warning;
    } else if (sponsor.tier.contains("Gümüş")) {
      tierColor = YanYanaColors.textLight;
    } else {
      tierColor = YanYanaColors.success;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: YanYanaColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: YanYanaShadows.soft,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(sponsor.logoUrl),
            backgroundColor: YanYanaColors.surfaceSoft,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sponsor.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: YanYanaColors.textDark)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: tierColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(sponsor.tier, style: TextStyle(color: tierColor, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              ],
            ),
          ),
          Icon(Icons.favorite, color: YanYanaColors.sosLight, size: 28),
        ],
      ),
    );
  }
}
