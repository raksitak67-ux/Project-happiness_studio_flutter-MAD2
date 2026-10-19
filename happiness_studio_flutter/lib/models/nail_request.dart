class NailRequest {
  final String nailDesignId;
  final String nailShape;
  final bool usePvc;
  final String details;
  final String? referencePath;

  // ระดับอะไหล่ที่ลูกค้าเลือก
  // none = ไม่ใช้, few = เล็กน้อย, many = หลายชิ้น
  final String accessoryLevel;

  const NailRequest({
    required this.nailDesignId,
    required this.nailShape,
    required this.usePvc,
    required this.details,
    this.referencePath,
    this.accessoryLevel = 'none',
  });
}
