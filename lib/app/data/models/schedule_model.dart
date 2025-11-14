import 'route_model.dart';
import 'ship_model.dart';

class ScheduleModel {
  final String id;
  final String routeId;
  final String shipId;
  final String operatorId;
  final DateTime departureTime;
  final DateTime estimatedArrivalTime;
  final double price;
  final int availableSeats;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RouteModel? route;
  final ShipModel? ship;

  ScheduleModel({
    required this.id,
    required this.routeId,
    required this.shipId,
    required this.operatorId,
    required this.departureTime,
    required this.estimatedArrivalTime,
    required this.price,
    required this.availableSeats,
    required this.createdAt,
    required this.updatedAt,
    this.route,
    this.ship,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] as String,
      routeId: json['routeId'] as String,
      shipId: json['shipId'] as String,
      operatorId: json['operatorId'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      estimatedArrivalTime:
          DateTime.parse(json['estimatedArrivalTime'] as String),
      price: double.parse(json['price'].toString()),
      availableSeats: json['availableSeats'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      route: json['route'] != null
          ? RouteModel.fromJson(json['route'] as Map<String, dynamic>)
          : null,
      ship: json['ship'] != null
          ? ShipModel.fromJson(json['ship'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routeId': routeId,
      'shipId': shipId,
      'operatorId': operatorId,
      'departureTime': departureTime.toIso8601String(),
      'estimatedArrivalTime': estimatedArrivalTime.toIso8601String(),
      'price': price,
      'availableSeats': availableSeats,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'route': route?.toJson(),
      'ship': ship?.toJson(),
    };
  }

  Duration get travelDuration =>
      estimatedArrivalTime.difference(departureTime);

  bool get isAvailable => availableSeats > 0;
}
