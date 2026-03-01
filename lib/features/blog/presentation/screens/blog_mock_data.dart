import '../../domain/entities/blog_article.dart';

final List<BlogArticle> mockBlogArticles = [
  BlogArticle(
    id: '1',
    title: 'Understanding Veterinary Vaccine Protocols',
    titleAr: 'فهم بروتوكولات اللقاحات البيطرية',
    publishedAt: DateTime(2025, 5, 12),
    summary: 'Key insights into designing vaccination programs for livestock.',
    summaryAr: 'نظرة شاملة على تصميم برامج التحصين للثروة الحيوانية.',
    content:
        'Vaccination programs are essential to maintain herd health. This article covers scheduling, booster requirements, and best practices for farm management teams.',
    contentAr:
        'تُعد برامج التحصين ضرورية للحفاظ على صحة القطيع. يستعرض هذا المقال جداول التحصين، ومتطلبات الجرعات المعززة، وأفضل الممارسات لفرق إدارة المزارع.',
    imageUrls: [
      'https://images.unsplash.com/photo-1453279673840-ccc4f7ad9a90?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
    ],
  ),
  BlogArticle(
    id: '2',
    title: 'Nutrition Strategies for High-Yield Dairy Cows',
    titleAr: 'استراتيجيات التغذية للأبقار الحلوب عالية الإنتاج',
    publishedAt: DateTime(2025, 4, 3),
    summary: 'Optimizing feed formulations to improve milk production.',
    summaryAr: 'تحسين تركيبات الأعلاف لرفع إنتاجية الحليب.',
    content:
        'Balancing energy, protein, and micronutrients is vital. We highlight ration planning, rumen health monitoring, and seasonal adjustments for dairy operations.',
    contentAr:
        'يُعد موازنة الطاقة والبروتين والعناصر الدقيقة أمرًا حيويًا. نسلط الضوء على تخطيط العلائق، ومراقبة صحة الكرش، والتعديلات الموسمية لمزارع الألبان.',
    imageUrls: [
      'https://images.unsplash.com/photo-1464226184884-fa280b87c399?auto=format&fit=crop&w=1200&q=80',
    ],
  ),
  BlogArticle(
    id: '3',
    title: 'Biosecurity Checklist for Poultry Farms',
    titleAr: 'قائمة مراجعة الأمن الحيوي لمزارع الدواجن',
    publishedAt: DateTime(2025, 2, 21),
    summary:
        'Practical steps to prevent disease outbreaks in poultry operations.',
    summaryAr: 'خطوات عملية لمنع تفشي الأمراض في مزارع الدواجن.',
    content:
        'From perimeter control to sanitation protocols, discover the essential safeguards that protect flocks from common pathogens and emerging threats.',
    contentAr:
        'من التحكم في محيط المزرعة إلى بروتوكولات التعقيم، تعرّف على إجراءات الوقاية الأساسية لحماية القطعان من المسببات المرضية الشائعة والناشئة.',
    imageUrls: [
      'https://images.unsplash.com/photo-1516382745379-0e1d0a7634db?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1521401830884-6c03c1c87ebb?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=1200&q=80',
    ],
  ),
];
