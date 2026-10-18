class Payment {
  final double amount;
  final String? slipPath;
  final String status;

  const Payment({
    required this.amount,
    this.slipPath,
    this.status = 'รอตรวจสอบ (สาธิต)',
  });
}
