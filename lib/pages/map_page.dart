import 'package:flutter/material.dart';
import '../models/accessibility_review.dart';
import '../models/accessible_place.dart';
import '../services/database_bridge.dart';
import '../theme.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const double _demoLat = 39.9208; // Ankara (demo coordinate)
  static const double _demoLon = 32.8541;

  final _db = const DatabaseBridge();

  String _selectedFilter = 'Tümü';

  final List<String> _filters = [
    'Tümü',
    'Kafe',
    'Restoran',
    'Park',
    'Hastane',
  ];

  bool _loading = true;
  List<AccessiblePlace> _places = const [];

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    setState(() => _loading = true);
    final list = await _db.getNearbyPlaces(
      latitude: _demoLat,
      longitude: _demoLon,
      radiusMeters: 1500,
    );
    if (!mounted) return;
    setState(() {
      _places = list;
      _loading = false;
    });
  }

  List<AccessiblePlace> get _filteredPlaces {
    if (_selectedFilter == 'Tümü') return _places;
    return _places.where((p) => p.category == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YanYanaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildMapPreview(),
            _buildFilterChips(),
            Expanded(child: _buildPlaceList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: YanYanaColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt_rounded),
        label: const Text(
          'Mekan Ekle',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Erişilebilir Mekanlar',
            style: TextStyle(
              color: YanYanaColors.textDark,
              fontSize: 23,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Yakınındaki erişilebilir alanları keşfet ve puanla.',
            style: TextStyle(
              color: YanYanaColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: YanYanaColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: YanYanaColors.border),
              boxShadow: YanYanaShadows.soft,
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Mekan ara...',
                hintStyle: TextStyle(
                  color: YanYanaColors.textLight,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: YanYanaColors.primary,
                  size: 22,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 145,
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: calmGradient,
        borderRadius: BorderRadius.circular(26),
        boxShadow: YanYanaShadows.card,
      ),
      child: Stack(
        children: [
          Positioned(
            right: 8,
            top: 8,
            child: Icon(
              Icons.map_rounded,
              size: 90,
              color: YanYanaColors.primary.withOpacity(0.18),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_searching_rounded,
                color: YanYanaColors.primary,
                size: 28,
              ),
              const SizedBox(height: 14),
              const Text(
                'Harita Önizlemesi',
                style: TextStyle(
                  color: YanYanaColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Gerçek harita entegrasyonu için Google Maps veya OpenStreetMap eklenebilir.',
                style: TextStyle(
                  color: YanYanaColors.textMuted,
                  fontSize: 12.5,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Mekan verileri OpenStreetMap / Overpass API entegrasyonuna hazır yapıdadır. Bu prototipte veriler yerel mock servis üzerinden gösterilmektedir.',
                style: TextStyle(
                  color: YanYanaColors.textMuted.withOpacity(0.9),
                  fontSize: 11.5,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final selected = _selectedFilter == filter;

          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(right: 9),
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
              decoration: BoxDecoration(
                color: selected ? YanYanaColors.primary : YanYanaColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selected
                      ? YanYanaColors.primary
                      : YanYanaColors.border,
                ),
                boxShadow: selected ? YanYanaShadows.soft : null,
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: selected ? Colors.white : YanYanaColors.textMuted,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceList() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: YanYanaColors.primary),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 95),
      itemCount: _filteredPlaces.length,
      itemBuilder: (context, index) {
        final place = _filteredPlaces[index];
        return _PlaceCard(
          place: place,
          onTap: () => _showPlaceDetail(place),
        );
      },
    );
  }

  void _showPlaceDetail(AccessiblePlace place) {
    final commentCtrl = TextEditingController();

    bool wheelchairAccessible = place.wheelchairAccessible;
    bool hasRamp = place.hasRamp;
    bool hasElevator = place.hasElevator;
    bool hasAccessibleToilet = place.hasAccessibleToilet;
    bool hasQuietArea = place.hasQuietArea;
    bool corridorWide = place.corridorWide;
    double rating = place.rating > 0 ? place.rating : 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: YanYanaColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: YanYanaShadows.card,
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: place.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.place_rounded,
                              color: place.color,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place.name,
                                  style: const TextStyle(
                                    color: YanYanaColors.textDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${place.category} · ${place.distance} · ${place.userCommentCount} yorum',
                                  style: const TextStyle(
                                    color: YanYanaColors.textMuted,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: place.tags
                            .map(
                              (t) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: YanYanaColors.surfaceSoft,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  t,
                                  style: const TextStyle(
                                    color: YanYanaColors.textMuted,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1, color: YanYanaColors.divider),
                      const SizedBox(height: 12),
                      const Text(
                        'Erişilebilirlik Kontrol Listesi (Prototip)',
                        style: TextStyle(
                          color: YanYanaColors.textDark,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _checkRow(
                        label: 'Tekerlekli sandalye uygun',
                        value: wheelchairAccessible,
                        onChanged: (v) =>
                            setModalState(() => wheelchairAccessible = v),
                      ),
                      _checkRow(
                        label: 'Rampa',
                        value: hasRamp,
                        onChanged: (v) => setModalState(() => hasRamp = v),
                      ),
                      _checkRow(
                        label: 'Asansör',
                        value: hasElevator,
                        onChanged: (v) => setModalState(() => hasElevator = v),
                      ),
                      _checkRow(
                        label: 'Engelli tuvaleti',
                        value: hasAccessibleToilet,
                        onChanged: (v) =>
                            setModalState(() => hasAccessibleToilet = v),
                      ),
                      _checkRow(
                        label: 'Sessiz alan',
                        value: hasQuietArea,
                        onChanged: (v) => setModalState(() => hasQuietArea = v),
                      ),
                      _checkRow(
                        label: 'Geniş koridor',
                        value: corridorWide,
                        onChanged: (v) => setModalState(() => corridorWide = v),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Puan:',
                            style: TextStyle(
                              color: YanYanaColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ...List.generate(
                            5,
                            (i) => GestureDetector(
                              onTap: () => setModalState(() => rating = i + 1.0),
                              child: Icon(
                                i < rating
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: YanYanaColors.accentYellow,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: commentCtrl,
                        minLines: 2,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Yorum',
                          hintText: 'Deneyimini kısaca paylaş',
                          filled: true,
                          fillColor: YanYanaColors.surfaceSoft,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide:
                                const BorderSide(color: YanYanaColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide:
                                const BorderSide(color: YanYanaColors.border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: GradientButton(
                          label: 'Değerlendirmeyi Gönder',
                          icon: Icons.check_circle_rounded,
                          gradient: supportGradient,
                          onPressed: () async {
                            final user = _db.getCurrentUser();
                            final review = AccessibilityReview(
                              id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
                              placeId: place.id,
                              userId: user.id,
                              wheelchairAccessible: wheelchairAccessible,
                              hasRamp: hasRamp,
                              hasElevator: hasElevator,
                              hasAccessibleToilet: hasAccessibleToilet,
                              hasQuietArea: hasQuietArea,
                              corridorWide: corridorWide,
                              rating: rating <= 0 ? 4.0 : rating,
                              comment: commentCtrl.text.trim(),
                              createdAt: DateTime.now(),
                            );

                            await _db.saveAccessibilityReview(review);
                            if (!mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Erişilebilirlik değerlendirmesi prototip olarak kaydedildi.',
                                ),
                              ),
                            );
                            await _loadPlaces();
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Veri Kaynağı: ${place.source} (future: Overpass API) · YanYana değerlendirmeleri: yerel mock',
                        style: const TextStyle(
                          color: YanYanaColors.textLight,
                          fontSize: 11.5,
                          height: 1.25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    ).whenComplete(commentCtrl.dispose);
  }

  static Widget _checkRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: YanYanaColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: YanYanaColors.primary,
          ),
        ],
      ),
    );
  }
}

class _PlaceCard extends StatefulWidget {
  final AccessiblePlace place;
  final VoidCallback onTap;

  const _PlaceCard({required this.place, required this.onTap});

  @override
  State<_PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<_PlaceCard> {
  double _userRating = 0;

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final tags = place.tags;
    final color = place.color;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: YanYanaColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: YanYanaShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    color: color,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: const TextStyle(
                          color: YanYanaColors.textDark,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: YanYanaColors.accentYellow,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            place.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: YanYanaColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '· ${place.distance}',
                            style: const TextStyle(
                              color: YanYanaColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '· ${place.userCommentCount} yorum',
                            style: const TextStyle(
                              color: YanYanaColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    place.category,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: tags
                  .take(6)
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: YanYanaColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: YanYanaColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 13),
            const Divider(height: 1, color: YanYanaColors.divider),
            const SizedBox(height: 11),
            Row(
              children: [
                const Text(
                  'Hızlı Puan:',
                  style: TextStyle(
                    color: YanYanaColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                ...List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() => _userRating = index + 1.0);
                    },
                    child: Icon(
                      index < _userRating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: YanYanaColors.accentYellow,
                      size: 23,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: YanYanaColors.textLight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}