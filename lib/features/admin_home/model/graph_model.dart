class GraphModel {
  int totalSale;
  int totalProfit;
  Map<String, List<Statistic>> statistics;

  GraphModel({
    required this.totalSale,
    required this.totalProfit,
    required this.statistics,
  });

  factory GraphModel.fromJson(Map<String, dynamic> json) => GraphModel(
        totalSale: json["Total Sale"],
        totalProfit: json["Total Profit"],
        statistics: Map.from(json["statistics"]).map((k, v) =>
            MapEntry<String, List<Statistic>>(
                k, List<Statistic>.from(v.map((x) => Statistic.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "Total Sale": totalSale,
        "Total Profit": totalProfit,
        "statistics": Map.from(statistics).map((k, v) =>
            MapEntry<String, dynamic>(
                k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };
}

class Statistic {
  int orderId;
  String orderValue;
  DateTime createdAt;

  Statistic({
    required this.orderId,
    required this.orderValue,
    required this.createdAt,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) => Statistic(
        orderId: json["orderId"],
        orderValue: json["orderValue"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderValue": orderValue,
        "createdAt": createdAt.toIso8601String(),
      };
}
