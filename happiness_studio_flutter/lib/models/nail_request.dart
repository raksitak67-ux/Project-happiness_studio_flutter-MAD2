class NailRequest {
  final String nailDesignId;
  final String nailShape;
  final bool usePvc;
  final String details;
  final String? referencePath;

  const NailRequest({
    required this.nailDesignId,
    required this.nailShape,
    required this.usePvc,
    required this.details,
    this.referencePath,
  });
}
