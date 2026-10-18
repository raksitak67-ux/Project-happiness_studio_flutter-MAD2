class NailDesign {
  final String id;
  final String name;
  final String description;
  final double startingPrice;
  final int durationMinutes;
  final String style;
  final String imageUrl;

  const NailDesign({
    required this.id,
    required this.name,
    required this.description,
    required this.startingPrice,
    required this.durationMinutes,
    required this.style,
    required this.imageUrl,
  });

  static const samples = <NailDesign>[
    NailDesign(
      id: 'n1',
      name: 'Pink Blossom',
      description: 'โทนชมพูอ่อนพร้อมลายดอกไม้ เหมาะกับลุคหวานละมุน',
      startingPrice: 399,
      durationMinutes: 90,
      style: 'หวาน',
      imageUrl: 'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800',
    ),
    NailDesign(
      id: 'n2',
      name: 'Minimal Nude',
      description: 'สีนู้ดเรียบง่าย ใช้ได้ในทุกวัน',
      startingPrice: 299,
      durationMinutes: 60,
      style: 'มินิมอล',
      imageUrl: 'https://images.unsplash.com/photo-1610992015732-2449b76344bc?w=800',
    ),
    NailDesign(
      id: 'n3',
      name: 'Glitter Party',
      description: 'กลิตเตอร์ประกาย เหมาะกับงานพิเศษ',
      startingPrice: 499,
      durationMinutes: 120,
      style: 'กลิตเตอร์',
      imageUrl: 'https://images.unsplash.com/photo-1632345031435-8727f6897d53?w=800',
    ),
  ];
}
