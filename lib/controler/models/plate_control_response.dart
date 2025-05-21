class PlateControlResponse {
  final String username;
  final TicketInfo? ticketInfo;
  final List<DateTime> lastFines;
  final List<DateTime> lastChalks;

  PlateControlResponse({
    required this.username,
    this.ticketInfo,
    required this.lastFines,
    required this.lastChalks,
  });

  factory PlateControlResponse.fromJson(Map<String, dynamic> json) {
    final ticketJson = json['ticket_info'];
    return PlateControlResponse(
      username: json['username'] ?? '',
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
      start: DateTime.fromMillisecondsSinceEpoch(json['start'] * 1000),
      end: DateTime.fromMillisecondsSinceEpoch(json['end'] * 1000),
    );
  }
}
