
class NailDesign {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final String style;
  final String imagePath;

  const NailDesign({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.style,
    required this.imagePath,
  });

  // รูปภาพทั้งหมด 29 รูป
  static const List<NailDesign> samples = [
    // =========================
    // MINIMAL (7 รูป)
    // =========================
    NailDesign(
      id: 'n1',
      name: 'Minimal 1',
      description: 'ลายเล็บสไตล์มินิมอลแบบที่ 1 สีพื้นสีเนื้อและสีแฟลช',
      price: 299,
      durationMinutes: 60,
      style: 'มินิมอล',
      imagePath: 'assets/images/nail_minimal1.jpg',
    ),
    NailDesign(
      id: 'n2',
      name: 'Minimal 2',
      description: 'ลายเล็บสไตล์มินิมอลแบบที่ 2 สีไซรัปสดใส',
      price: 299,
      durationMinutes: 60,
      style: 'มินิมอล',
      imagePath: 'assets/images/nail_minimal2.jpg',
    ),
    NailDesign(
      id: 'n3',
      name: 'Minimal 3',
      description: 'ลายเล็บสไตล์มินิมอลแบบที่ 3 สีลูกแก้ว',
      price: 299,
      durationMinutes: 60,
      style: 'มินิมอล',
      imagePath: 'assets/images/nail_minimal3.jpg',
    ),
    NailDesign(
      id: 'n4',
      name: 'Minimal 4',
      description: 'ลายเล็บสไตล์มินิมอลแบบที่ 4 สีพื้นพร้อมเฟรนปลายสีขาวและปั้นนูนดอกไม้',
      price: 299,
      durationMinutes: 60,
      style: 'มินิมอล',
      imagePath: 'assets/images/nail_minimal4.jpg',
    ),
    NailDesign(
      id: 'n5',
      name: 'Minimal 5',
      description: 'ลายเล็บสไตล์มินิมอลแบบที่ 5 สีลุกแก้วและติดอะไหล่',
      price: 299,
      durationMinutes: 60,
      style: 'มินิมอล',
      imagePath: 'assets/images/nail_minimal5.jpg',
    ),
    NailDesign(
      id: 'n6',
      name: 'Minimal 6',
      description: 'ลายเล็บสไตล์มินิมอลแบบที่ 6 สีลุกแก้วพร้อมปั้นนูนดอกไม้และติดอะไหล่',
      price: 299,
      durationMinutes: 60,
      style: 'มินิมอล',
      imagePath: 'assets/images/nail_minimal6.jpg',
    ),
    NailDesign(
      id: 'n7',
      name: 'Minimal 7',
      description: 'ลายเล็บสไตล์มินิมอลแบบที่ 7 สีลูกแก้วพร้อมเพ้นท์ลายเล็บและติดอะไหล่',
      price: 299,
      durationMinutes: 60,
      style: 'มินิมอล',
      imagePath: 'assets/images/nail_minimal7.jpg',
    ),

    // =========================
    // LUXURIOUS (6 รูป)
    // =========================
    NailDesign(
      id: 'n8',
      name: 'Luxurious 1',
      description: 'ลายเล็บสไตล์หรูหราแบบที่ 1 สีลูกแก้วสีแฟลชและเพ้นท์ลายเล็บ',
      price: 599,
      durationMinutes: 120,
      style: 'หรูหรา',
      imagePath: 'assets/images/nail_luxurious1.jpg',
    ),
    NailDesign(
      id: 'n9',
      name: 'Luxurious 2',
      description: 'ลายเล็บสไตล์หรูหราแบบที่ 2 สีแฟลช สีลุกแก้วพร้อมติดสติ๊กเกอร์เล็บ',
      price: 599,
      durationMinutes: 120,
      style: 'หรูหรา',
      imagePath: 'assets/images/nail_luxurious2.jpg',
    ),
    NailDesign(
      id: 'n10',
      name: 'Luxurious 3',
      description: 'ลายเล็บสไตล์หรูหราแบบที่ 3 สีลูกแก้วพร้อมปั้นนูนทุกนิ้วและติดอะไหล่',
      price: 599,
      durationMinutes: 120,
      style: 'หรูหรา',
      imagePath: 'assets/images/nail_luxurious3.jpg',
    ),
    NailDesign(
      id: 'n11',
      name: 'Luxurious 4',
      description: 'ลายเล็บสไตล์หรูหราแบบที่ 4 สีพื้น การทาออมเบร(ไล่สี) ขัดผง พร้อมปั้นนูนและติดอะไหล่',
      price: 599,
      durationMinutes: 120,
      style: 'หรูหรา',
      imagePath: 'assets/images/nail_luxurious4.jpg',
    ),
    NailDesign(
      id: 'n12',
      name: 'Luxurious 5',
      description: 'ลายเล็บสไตล์หรูหราแบบที่ 5 สีลูกแก้วพร้อมปั้นนูนและติดอะไหล่',
      price: 599,
      durationMinutes: 120,
      style: 'หรูหรา',
      imagePath: 'assets/images/nail_luxurious5.jpg',
    ),
    NailDesign(
      id: 'n13',
      name: 'Luxurious 6',
      description: 'ลายเล็บสไตล์หรูหราแบบที่ 6 สีแฟลชและสีลูกแก้ว',
      price: 599,
      durationMinutes: 120,
      style: 'หรูหรา',
      imagePath: 'assets/images/nail_luxurious6.jpg',
    ),

    // =========================
    // CUTE (11 รูป)
    // =========================
    NailDesign(
      id: 'n14',
      name: 'Cute 1',
      description: 'ลายเล็บสไตล์น่ารักแบบที่ 1 สีพื้นเพ้นท์ลายเล็บและปั้นนูน',
      price: 399,
      durationMinutes: 90,
      style: 'น่ารัก',
      imagePath: 'assets/images/nail_cute1.jpg',
    ),
    NailDesign(
      id: 'n15',
      name: 'Cute 2',
      description: 'ลายเล็บสไตล์น่ารักแบบที่ 2 สีลูกแก้ว การทำออมเบร(ไล่สี) พร้อมเพ้นท์ลายเล็บและติดอะไหล่',
      price: 399,
      durationMinutes: 90,
      style: 'น่ารัก',
      imagePath: 'assets/images/nail_cute2.jpg',
    ),
    NailDesign(
      id: 'n16',
      name: 'Cute 3',
      description: 'ลายเล็บสไตล์น่ารักแบบที่ 3 สีพื้นเพ้นท์ลายเล็บพร้อมปั้นนูน ติดอะไหล่ และติดสติ๊กเกอร์เล็บ',
      price: 399,
      durationMinutes: 90,
      style: 'น่ารัก',
      imagePath: 'assets/images/nail_cute3.jpg',
    ),
    NailDesign(
      id: 'n17',
      name: 'Cute 4',
      description: 'ลายเล็บสไตล์น่ารักแบบที่ 4 สีพื้นเพ้นท์ลายเล็บพร้อมปั้นนูน ติดอะไหล่ และติดสติ๊กเกอร์เล็บ',
      price: 399,
      durationMinutes: 90,
      style: 'น่ารัก',
      imagePath: 'assets/images/nail_cute4.jpg',
    ),
    NailDesign(
      id: 'n18',
      name: 'Cute 5',
      description: 'ลายเล็บสไตล์น่ารักแบบที่ 5 สีลูกแก้วและติดสติ๊เกอร์ลายเล็บ',
      price: 399,
      durationMinutes: 90,
      style: 'น่ารัก',
      imagePath: 'assets/images/nail_cute5.jpg',
    ),
    NailDesign(
      id: 'n19',
      name: 'Cute 6',
      description: 'ลายเล็บสไตล์น่ารักแบบที่ 6 สีลูกแก้ว เฟรนปรายเล็บ พร้อมเพ้นท์ลายเล็บ และติดอะไหล่',
      price: 399,
      durationMinutes: 90,
      style: 'น่ารัก',
      imagePath: 'assets/images/nail_cute6.jpg',
    ),
    NailDesign(
      id: 'n20',
      name: 'Cute 7',
      description: 'ลายเล็บสไตล์น่ารักแบบที่ 7 สีพื้น เฟรนปรายเล็บ พร้อมเพ้นท์ลายเล็บ และติดอะไหล่',
      price: 399,
      durationMinutes: 90,
      style: 'น่ารัก',
      imagePath: 'assets/images/nail_cute7.jpg',
    ),
    NailDesign(
      id: 'n21',
      name: 'Cute 8',
      description: 'ลายเล็บสไตล์น่ารักแบบที่ 8 สีแฟลช เฟรนปรายเล็บ พร้อมเพ้นท์ลายเล็บ และติดอะไหล่',
      price: 399,
      durationMinutes: 90,
      style: 'น่ารัก',
      imagePath: 'assets/images/nail_cute8.jpg',
    ),
    NailDesign(
      id: 'n22',
      name: 'Cute 9',
      description: 'ลายเล็บสไตล์น่ารักแบบที่ 9 สีพื้นพร้อมเพ้นท์ลายเล็บ',
      price: 399,
      durationMinutes: 90,
      style: 'น่ารัก',
      imagePath: 'assets/images/nail_cute9.jpg',
    ),
    NailDesign(
      id: 'n23',
      name: 'Cute 10',
      description: 'ลายเล็บสไตล์น่ารักแบบที่ 10 สีพื้นพร้อมเพ้นท์ลายเล็บและติดอะไหล่',
      price: 399,
      durationMinutes: 90,
      style: 'น่ารัก',
      imagePath: 'assets/images/nail_cute10.jpg',
    ),
    NailDesign(
      id: 'n24',
      name: 'Cute 11',
      description: 'ลายเล็บสไตล์น่ารักแบบที่ 11 สีพื้นและติดอะไหล่',
      price: 399,
      durationMinutes: 90,
      style: 'น่ารัก',
      imagePath: 'assets/images/nail_cute11.jpg',
    ),

    // =========================
    // FANTASY (5 รูป)
    // =========================
    NailDesign(
      id: 'n25',
      name: 'Fantasy 1',
      description: 'ลายเล็บสไตล์แฟนตาซีแบบที่ 1 สีแฟลช เฟรนปรายเล็บ ปั้นนูนพร้อมขัดผง และติดอะไหล่',
      price: 499,
      durationMinutes: 120,
      style: 'แฟนตาซี',
      imagePath: 'assets/images/nail_Fantasy1.jpg',
    ),
    NailDesign(
      id: 'n26',
      name: 'Fantasy 2',
      description: 'ลายเล็บสไตล์แฟนตาซีแบบที่ 2 สีแฟลช เฟรนปรายเล็บ ปั้นนูนพร้อมขัดผง และติดอะไหล่',
      price: 499,
      durationMinutes: 120,
      style: 'แฟนตาซี',
      imagePath: 'assets/images/nail_Fantasy2.jpg',
    ),
    NailDesign(
      id: 'n27',
      name: 'Fantasy 3',
      description: 'ลายเล็บสไตล์แฟนตาซีแบบที่ 3 สีพื้น สีแฟลช การทำออมเบร(ไล่สี) เพ้นท์ลายเล็บและปั้นนูน',
      price: 499,
      durationMinutes: 120,
      style: 'แฟนตาซี',
      imagePath: 'assets/images/nail_Fantasy3.jpg',
    ),
    NailDesign(
      id: 'n28',
      name: 'Fantasy 4',
      description: 'ลายเล็บสไตล์แฟนตาซีแบบที่ 4 สีไซรัป เพ้นท์ลายเล็บพร้อมปั้นนูน',
      price: 499,
      durationMinutes: 120,
      style: 'แฟนตาซี',
      imagePath: 'assets/images/nail_Fantasy4.jpg',
    ),
    NailDesign(
      id: 'n29',
      name: 'Fantasy 5',
      description: 'ลายเล็บสไตล์แฟนตาซีแบบที่ 5 สีพื้น เฟรนปรายเล็บ เพ้นท์ลายเล็บและติดอะไหล่',
      price: 499,
      durationMinutes: 120,
      style: 'แฟนตาซี',
      imagePath: 'assets/images/nail_Fantasy5.jpg',
    ),
  ];
}
