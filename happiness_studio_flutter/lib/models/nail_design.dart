class NailDesign {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final String style;
  final String imageUrl;

  const NailDesign({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.style,
    required this.imageUrl,
  });

  static const samples = <NailDesign>[
    // 1. แนวหวาน
    NailDesign(
      id: 'n1',
      name: 'Pink Blossom',
      description: 'โทนชมพูอ่อนพร้อมลายดอกไม้ เหมาะกับลุคหวานละมุน',
      price: 399,
      durationMinutes: 90,
      style: 'หวาน',
      imageUrl:
          'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800',
    ),

    // 2. แนวมินิมอล
    NailDesign(
      id: 'n2',
      name: 'Minimal Nude',
      description: 'สีนู้ดเรียบง่าย ดูสะอาดตา เหมาะกับการใช้งานทุกวัน',
      price: 299,
      durationMinutes: 60,
      style: 'มินิมอล',
      imageUrl:
          'https://images.unsplash.com/photo-1610992015732-2449b76344bc?w=800',
    ),

    // 3. แนวกลิตเตอร์
    NailDesign(
      id: 'n3',
      name: 'Glitter Party',
      description: 'เล็บประกายกลิตเตอร์ เพิ่มความโดดเด่นสำหรับวันพิเศษ',
      price: 499,
      durationMinutes: 120,
      style: 'กลิตเตอร์',
      imageUrl:
          'https://images.unsplash.com/photo-1632345031435-8727f6897d53?w=800',
    ),

    // 4. แนวเกาหลี
    NailDesign(
      id: 'n4',
      name: 'Korean Jelly',
      description: 'สีเจลใสฉ่ำวาว โทนชมพูและพีชสไตล์เกาหลี',
      price: 399,
      durationMinutes: 90,
      style: 'เกาหลี',
      imageUrl:
          'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800',
    ),

    // 5. แนวหรูหรา
    NailDesign(
      id: 'n5',
      name: 'Luxury Pearl',
      description: 'โทนสีสุภาพตกแต่งด้วยมุก เพิ่มความหรูหราให้ปลายนิ้ว',
      price: 599,
      durationMinutes: 120,
      style: 'หรูหรา',
      imageUrl:
          'https://images.unsplash.com/photo-1632345031435-8727f6897d53?w=800',
    ),

    // 6. แนว French Nails
    NailDesign(
      id: 'n6',
      name: 'Classic French',
      description: 'ปลายเล็บสีขาวคลาสสิก เรียบหรูและเข้าได้กับทุกชุด',
      price: 399,
      durationMinutes: 90,
      style: 'คลาสสิก',
      imageUrl:
          'https://images.unsplash.com/photo-1610992015732-2449b76344bc?w=800',
    ),

    // 7. แนวดอกไม้
    NailDesign(
      id: 'n7',
      name: 'Flower Garden',
      description: 'ลายดอกไม้เล็ก ๆ โทนพาสเทล ให้ความรู้สึกสดใส',
      price: 449,
      durationMinutes: 100,
      style: 'ดอกไม้',
      imageUrl:
          'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800',
    ),

    // 8. แนวไล่สี
    NailDesign(
      id: 'n8',
      name: 'Ombre Dream',
      description: 'ไล่เฉดสีอย่างนุ่มนวล เพิ่มมิติให้เล็บดูสวยละมุน',
      price: 449,
      durationMinutes: 100,
      style: 'ไล่สี',
      imageUrl:
          'https://images.unsplash.com/photo-1632345031435-8727f6897d53?w=800',
    ),

    // 9. แนวโครม
    NailDesign(
      id: 'n9',
      name: 'Chrome Shine',
      description: 'ผิวเล็บประกายเมทัลลิก สะท้อนแสงโดดเด่นไม่เหมือนใคร',
      price: 499,
      durationMinutes: 100,
      style: 'โครม',
      imageUrl:
          'https://images.unsplash.com/photo-1632345031435-8727f6897d53?w=800',
    ),

    // 10. แนวแฟชั่น
    NailDesign(
      id: 'n10',
      name: 'Color Pop',
      description: 'ผสมสีสันสดใส เหมาะกับคนที่ชอบลุคสนุกและมีสไตล์',
      price: 449,
      durationMinutes: 90,
      style: 'แฟชั่น',
      imageUrl:
          'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800',
    ),

    // 11. แนวหัวใจ
    NailDesign(
      id: 'n11',
      name: 'Sweetheart',
      description: 'โทนชมพูและลายหัวใจ เพิ่มความน่ารักให้กับทุกวัน',
      price: 399,
      durationMinutes: 90,
      style: 'น่ารัก',
      imageUrl:
          'https://images.unsplash.com/photo-1610992015732-2449b76344bc?w=800',
    ),

    // 12. แนวสีพื้น
    NailDesign(
      id: 'n12',
      name: 'Simple Color',
      description: 'ทาสีเจลพื้นสีเดียว เลือกโทนสีได้ตามความชอบ',
      price: 249,
      durationMinutes: 45,
      style: 'สีพื้น',
      imageUrl:
          'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800',
    ),
  ];
}
