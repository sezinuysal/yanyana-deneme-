enum CampaignStatus { pending, active, completed, rejected }

class DonationCampaign {
  final String id;
  final String title;
  final String description;
  final String? coverImageUrl;
  final double targetAmount;
  double collectedAmount;
  final DateTime endDate;
  
  // Moderasyon
  CampaignStatus status;
  final String creatorName;

  DonationCampaign({
    required this.id,
    required this.title,
    required this.description,
    this.coverImageUrl,
    required this.targetAmount,
    this.collectedAmount = 0.0,
    required this.endDate,
    this.status = CampaignStatus.pending,
    required this.creatorName,
  });

  double get progressPercentage {
    if (targetAmount <= 0) return 0.0;
    final progress = collectedAmount / targetAmount;
    return progress > 1.0 ? 1.0 : progress;
  }
}

class Sponsor {
  final String id;
  final String name;
  final String logoUrl;
  final String tier; // e.g., "Altın", "Gümüş", "Gönülden Destekleyen"

  Sponsor({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.tier,
  });
}

// MOCK VERİLER
final List<DonationCampaign> mockCampaigns = [
  DonationCampaign(
    id: "c1",
    title: "Tekerlekli Sandalye Desteği",
    description: "İhtiyaç sahibi 10 engelli bireyimiz için akülü tekerlekli sandalye alımı kampanyası.",
    coverImageUrl: "https://images.unsplash.com/photo-1579208575657-c595a05383b7?w=500",
    targetAmount: 50000.0,
    collectedAmount: 35000.0,
    endDate: DateTime.now().add(const Duration(days: 15)),
    status: CampaignStatus.active,
    creatorName: "Dernek Yönetimi",
  ),
  DonationCampaign(
    id: "c2",
    title: "Görsel Materyal Atölyesi",
    description: "Otizmli çocuklarımız için resim ve sanat atölyesi malzemeleri.",
    targetAmount: 15000.0,
    collectedAmount: 15000.0,
    endDate: DateTime.now().subtract(const Duration(days: 2)),
    status: CampaignStatus.completed,
    creatorName: "Gönüllü Ekibi",
  ),
  DonationCampaign(
    id: "c3",
    title: "Yeni Eğitim Sınıfı Kütüphanesi",
    description: "Sesli kitap ve kabartma baskı kitaplardan oluşan yeni kütüphane projesi.",
    targetAmount: 30000.0,
    collectedAmount: 0.0,
    endDate: DateTime.now().add(const Duration(days: 30)),
    status: CampaignStatus.pending, // Moderasyon bekliyor
    creatorName: "Ayşe Öğretmen",
  ),
];

final List<Sponsor> mockSponsors = [
  Sponsor(id: "s1", name: "TechCorp A.Ş.", logoUrl: "https://ui-avatars.com/api/?name=TC&background=0D8ABC&color=fff", tier: "Altın Destekçi"),
  Sponsor(id: "s2", name: "Umut Vakfı", logoUrl: "https://ui-avatars.com/api/?name=UV&background=F59E0B&color=fff", tier: "Gümüş Destekçi"),
  Sponsor(id: "s3", name: "Ahmet Yılmaz", logoUrl: "https://ui-avatars.com/api/?name=AY&background=10B981&color=fff", tier: "Gönülden Destekleyen"),
];
