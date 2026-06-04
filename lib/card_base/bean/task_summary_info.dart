class TaskSummaryInfo {
  final int pendingCount;
  final int receivedCount;
  final int todayPendingCount;
  final int todayReceivedCount;
  final int totalCount;
  final int yesterdayPendingCount;
  final int yesterdayReceivedCount;

  TaskSummaryInfo({
    required this.pendingCount,
    required this.receivedCount,
    required this.todayPendingCount,
    required this.todayReceivedCount,
    required this.totalCount,
    required this.yesterdayPendingCount,
    required this.yesterdayReceivedCount,
  });

  factory TaskSummaryInfo.fromJson(Map<String, dynamic> json) {
    return TaskSummaryInfo(
      pendingCount: json['pendingCount'],
      receivedCount: json['receivedCount'],
      todayPendingCount: json['todayPendingCount'],
      todayReceivedCount: json['todayReceivedCount'],
      totalCount: json['totalCount'],
      yesterdayPendingCount: json['yesterdayPendingCount'],
      yesterdayReceivedCount: json['yesterdayReceivedCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pendingCount': pendingCount,
      'receivedCount': receivedCount,
      'todayPendingCount': todayPendingCount,
      'todayReceivedCount': todayReceivedCount,
      'totalCount': totalCount,
      'yesterdayPendingCount': yesterdayPendingCount,
      'yesterdayReceivedCount': yesterdayReceivedCount,
    };
  }
}