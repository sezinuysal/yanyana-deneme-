class GuideStep {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  bool isCompleted;

  GuideStep({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.isCompleted = false,
  });
}

enum GuideCategory { dailyTasks, recipes, socialSkills, other }

class Guide {
  final String id;
  final String title;
  final String description;
  final String? coverImageUrl;
  final GuideCategory category;
  final List<GuideStep> steps;
  
  // Moderasyon
  final bool isApproved;
  final String authorName;
  final String authorRole; // e.g. "Gönüllü"

  // Etkileşim
  int likes;
  bool isFavorite;
  
  // İlerleme
  int completedStepsCount;

  Guide({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.steps,
    this.coverImageUrl,
    this.isApproved = true,
    required this.authorName,
    required this.authorRole,
    this.likes = 0,
    this.isFavorite = false,
    this.completedStepsCount = 0,
  });

  double get progressPercentage {
    if (steps.isEmpty) return 0.0;
    return completedStepsCount / steps.length;
  }
}

// MOCK VERİLER
final List<Guide> mockGuides = [
  Guide(
    id: "g1",
    title: "Çay Nasıl Demlenir?",
    description: "Kendi başına güvenle çay demlemenin adım adım rehberi.",
    category: GuideCategory.dailyTasks,
    coverImageUrl: "https://images.unsplash.com/photo-1576092762791-dd9e2220abd4?w=500",
    authorName: "Ayşe Yılmaz",
    authorRole: "Gönüllü",
    likes: 124,
    isFavorite: true,
    steps: [
      GuideStep(id: "s1", title: "Suyu Hazırla", description: "Çaydanlığın alt kısmına soğuk su doldur ve ocağa koy."),
      GuideStep(id: "s2", title: "Suyu Kaynat", description: "Ocağı yak ve suyun kaynamasını bekle. Su fokurdadığında kaynamış demektir."),
      GuideStep(id: "s3", title: "Çayı Ekle", description: "Üst demliğe 3 yemek kaşığı kuru çay koy."),
      GuideStep(id: "s4", title: "Demleme", description: "Kaynayan suyu üst demliğe dök ve 15 dakika bekle."),
    ],
  ),
  Guide(
    id: "g2",
    title: "Basit Makarna Tarifi",
    description: "Sadece 15 dakikada hazırlayabileceğin kolay domates soslu makarna.",
    category: GuideCategory.recipes,
    coverImageUrl: "https://images.unsplash.com/photo-1612874742237-6526221588e3?w=500",
    authorName: "Mehmet Demir",
    authorRole: "Doğrulayıcı",
    likes: 342,
    isApproved: true,
    steps: [
      GuideStep(id: "m1", title: "Suyu Kaynat", description: "Tencereye su koy, içine biraz tuz at ve kaynat."),
      GuideStep(id: "m2", title: "Makarnayı Haşla", description: "Makarnayı suya dök ve 10 dakika kaynat."),
      GuideStep(id: "m3", title: "Sos", description: "Ayrı bir tavada hazır domates sosunu ısıt."),
      GuideStep(id: "m4", title: "Birleştir", description: "Suyunu süzdüğün makarnayı sosla karıştır. Afiyet olsun!"),
    ],
  ),
  Guide(
    id: "g3",
    title: "Otobüs Kartı Nasıl Basılır?",
    description: "Toplu taşımaya binerken yapılması gerekenler.",
    category: GuideCategory.socialSkills,
    authorName: "Ali Can",
    authorRole: "Gönüllü",
    isApproved: false, // Beklemede statüsü (Moderasyon)
    steps: [
      GuideStep(id: "o1", title: "Kartı Hazırla", description: "Otobüse binmeden önce kartını eline al."),
      GuideStep(id: "o2", title: "Cihaza Yaklaştır", description: "Otobüse bindiğinde sağdaki yeşil cihaza kartını yaklaştır ve 'dıt' sesini duy."),
    ],
  ),
];
