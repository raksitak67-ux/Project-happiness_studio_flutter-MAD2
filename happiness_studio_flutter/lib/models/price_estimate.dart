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

  double get total => basePrice + pvcPrice + extraPrice + accessoryPrice;
  double get deposit => total * 0.30;

  factory PriceEstimate.calculate({
    required double basePrice,
    required bool usePvc,
    required String nailShape,
    required String style,
    required String details,
  }) {
    final pvc = usePvc ? 200.0 : 0.0;
    final extra = details.trim().isEmpty ? 0.0 : 50.0;
    final accessory = style == 'กลิตเตอร์' ? 80.0 : 50.0;
    final suggestion = nailShape == 'Almond'
        ? 'แนะนำอะไหล่คริสตัลขนาดเล็ก หรือหัวใจสีเงิน'
        : 'แนะนำอะไหล่มุกหรือเพชรเม็ดเล็ก';
    return PriceEstimate(
      basePrice: basePrice,
      pvcPrice: pvc,
      extraPrice: extra,
      accessoryPrice: accessory,
      recommendation:
          'แนะนำทรง $nailShape กับสไตล์$style โดยปรับโทนสีให้เข้ากับ Reference ของคุณ',
      accessorySuggestion: suggestion,
    );
  }
}
