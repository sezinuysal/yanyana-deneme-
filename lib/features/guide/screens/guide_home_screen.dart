import 'package:flutter/material.dart';
import 'package:yanyana_p/core/theme/theme.dart';
import '../models/guide_model.dart';
import 'guide_detail_screen.dart';
import 'guide_create_screen.dart';

class GuideHomeScreen extends StatefulWidget {
  const GuideHomeScreen({super.key});

  @override
  State<GuideHomeScreen> createState() => _GuideHomeScreenState();
}

class _GuideHomeScreenState extends State<GuideHomeScreen> {
  String _searchQuery = "";
  GuideCategory? _selectedCategory;
  bool _isVolunteerMode = false; // Test amaçlı rol değiştirici

  List<Guide> get _filteredGuides {
    return mockGuides.where((guide) {
      final matchesSearch = guide.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            guide.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || guide.category == _selectedCategory;
      final matchesApproval = _isVolunteerMode ? true : guide.isApproved;
      return matchesSearch && matchesCategory && matchesApproval;
    }).toList();
  }

  String _getCategoryName(GuideCategory cat) {
    switch (cat) {
      case GuideCategory.dailyTasks: return "Günlük İşler";
      case GuideCategory.recipes: return "Yemek Tarifleri";
      case GuideCategory.socialSkills: return "Sosyal Beceriler";
      case GuideCategory.other: return "Diğer";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // TabBar içinde düzgün durması için
      body: Column(
        children: [
          // Rol Anahtarı
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
          
          // Arama Çubuğu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rehber veya tarif ara...',
                hintStyle: const TextStyle(color: YanYanaColors.textLight),
                prefixIcon: const Icon(Icons.search, size: 24, color: YanYanaColors.primary),
                filled: true,
                fillColor: YanYanaColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              style: const TextStyle(fontSize: 16, color: YanYanaColors.textDark),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Kategori Filtreleri
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip("Tümü", null),
                const SizedBox(width: 8),
                _buildFilterChip("Günlük İşler", GuideCategory.dailyTasks),
                const SizedBox(width: 8),
                _buildFilterChip("Yemek Tarifleri", GuideCategory.recipes),
                const SizedBox(width: 8),
                _buildFilterChip("Sosyal Beceriler", GuideCategory.socialSkills),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Liste
          Expanded(
            child: _filteredGuides.isEmpty
              ? const Center(child: Text("Sonuç bulunamadı.", style: TextStyle(color: YanYanaColors.textMuted)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _filteredGuides.length,
                  itemBuilder: (context, index) {
                    final guide = _filteredGuides[index];
                    return _buildGuideCard(guide);
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: _isVolunteerMode
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GuideCreateScreen()),
                );
              },
              backgroundColor: YanYanaColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Yeni Rehber", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildFilterChip(String label, GuideCategory? category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? YanYanaColors.primary : YanYanaColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: YanYanaColors.border),
        ),
        child: Center(
          child: Text(
            label, 
            style: TextStyle(
              fontSize: 14, 
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Colors.white : YanYanaColors.textDark,
            )
          ),
        ),
      ),
    );
  }

  Widget _buildGuideCard(Guide guide) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: YanYanaColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: YanYanaShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GuideDetailScreen(guide: guide),
            ),
          ).then((_) => setState((){})); 
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kapak Görseli
            if (guide.coverImageUrl != null)
              Image.network(
                guide.coverImageUrl!,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 140,
                width: double.infinity,
                color: YanYanaColors.primaryLight,
                child: const Icon(Icons.menu_book, size: 50, color: YanYanaColors.primary),
              ),
              
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: YanYanaColors.secondaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(_getCategoryName(guide.category), style: const TextStyle(fontWeight: FontWeight.bold, color: YanYanaColors.secondary, fontSize: 12)),
                      ),
                      Row(
                        children: [
                          if (!guide.isApproved)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: YanYanaColors.warning, borderRadius: BorderRadius.circular(8)),
                              child: const Text("Beklemede", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                          const SizedBox(width: 8),
                          if (guide.isFavorite)
                            const Icon(Icons.favorite, color: YanYanaColors.sos, size: 22),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    guide.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: YanYanaColors.textDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    guide.description,
                    style: const TextStyle(fontSize: 14, color: YanYanaColors.textMuted, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.thumb_up_alt_rounded, size: 16, color: YanYanaColors.accentBlue),
                          const SizedBox(width: 4),
                          Text("${guide.likes} Beğeni", style: const TextStyle(color: YanYanaColors.textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      if (guide.progressPercentage > 0)
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 16, color: YanYanaColors.success),
                            const SizedBox(width: 4),
                            Text(
                              "%${(guide.progressPercentage * 100).toInt()} Tamamlandı",
                              style: const TextStyle(color: YanYanaColors.success, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

