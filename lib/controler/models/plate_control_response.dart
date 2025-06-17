class PlateControlResponse {
  final String parkingName;
  final TicketInfo? ticketInfo;
  final List<DateTime> lastFines;
  final List<DateTime> lastChalks;

  PlateControlResponse({
    required this.parkingName,
    this.ticketInfo,
    required this.lastFines,
    required this.lastChalks,
  });

  factory PlateControlResponse.fromJson(Map<String, dynamic> json) {
    final ticketJson = json['ticket'];
    return PlateControlResponse(
      parkingName: json['parking_name'],
      ticketInfo: ticketJson != null ? TicketInfo.fromJson(ticketJson) : null,
      lastFines: (json['last_fines'] as List<dynamic>? ?? [])
          .map((e) => DateTime.fromMillisecondsSinceEpoch(e * 1000))
          .toList(),
      lastChalks: (json['last_chalks'] as List<dynamic>? ?? [])
          .map((e) => DateTime.fromMillisecondsSinceEpoch(e * 1000))
          .toList(),
    );
  }
}

class TicketInfo {
  final DateTime start;
  final DateTime end;

  TicketInfo({required this.start, required this.end});

  factory TicketInfo.fromJson(Map<String, dynamic> json) {
    return TicketInfo(
      start: DateTime.fromMillisecondsSinceEpoch(json['start_time'] * 1000),
      end: DateTime.fromMillisecondsSinceEpoch(json['stop_time'] * 1000),
    );
  }
}
