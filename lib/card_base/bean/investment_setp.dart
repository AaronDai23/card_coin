enum InvestStepStatus { pending, progress, done }

class InvestmentStep {
  String title;
  String? subtitle;
  String? time;
  InvestStepStatus status;

  InvestmentStep({
    required this.title,
    this.subtitle,
    this.time,
    required this.status,
  });
}
