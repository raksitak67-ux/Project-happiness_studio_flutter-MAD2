class PriceEstimate {
  final double basePrice;
  final double pvcPrice;
  final double extraPrice;
  final double accessoryPrice;
  final String recommendation;
  final String accessorySuggestion;

  const PriceEstimate({
    required this.basePrice,
    required this.pvcPrice,
    required this.extraPrice,
    required this.accessoryPrice,
    required this.recommendation,
    required this.accessorySuggestion,
  });

  // คำนวณราคารวม
  double get total => basePrice + pvcPrice + extraPrice + accessoryPrice;

  // เงินมัดจำคงที่ 100 บาท
  double get deposit => 100.0;

  factory PriceEstimate.calculate({
    required double basePrice,
    required bool usePvc,
    required String nailShape,
    required String style,
    required String details,
    String accessoryLevel = 'none',
  }) {
    // ค่า PVC
    final pvc = usePvc ? 200.0 : 0.0;

    // รายละเอียดเพิ่มเติมไม่มีค่าใช้จ่าย
    const extra = 0.0;

    // ค่าอะไหล่ตามตัวเลือกของลูกค้า
    double accessory;

    switch (accessoryLevel) {
      case 'few':
        accessory = 50.0;
        break;
      case 'many':
        accessory = 100.0;
        break;
      default:
        accessory = 0.0;
    }

    // คำแนะนำเกี่ยวกับอะไหล่
    final suggestion = accessoryLevel == 'none'
        ? 'ไม่เลือกใช้อะไหล่เพิ่มเติม'
        : nailShape == 'Almond'
        ? 'แนะนำอะไหล่คริสตัลขนาดเล็ก หรือหัวใจสีเงิน'
        : 'แนะนำอะไหล่มุกหรือเพชรเม็ดเล็ก';

    return PriceEstimate(
      basePrice: basePrice,
      pvcPrice: pvc,
      extraPrice: extra,
      accessoryPrice: accessory,
      recommendation: 'แนะนำทรง $nailShape กับสไตล์ $style',
      accessorySuggestion: suggestion,
    );
  }
}
