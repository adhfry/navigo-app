import 'port_model.dart';

class RouteModel {
  final String id;
  final String originPortId;
  final String destinationPortId;
  final double? estimatedDurationHours;
  final PortModel? originPort;
  final PortModel? destinationPort;

  RouteModel({
    required this.id,
    required this.originPortId,
    required this.destinationPortId,
    this.estimatedDurationHours,
    this.originPort,
    this.destinationPort,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] as String,
      originPortId: json['originPortId'] as String,
      destinationPortId: json['destinationPortId'] as String,
      estimatedDurationHours: json['estimatedDurationHours'] != null
          ? double.parse(json['estimatedDurationHours'].toString())
          : null,
      originPort: json['originPort'] != null
          ? PortModel.fromJson(json['originPort'] as Map<String, dynamic>)
          : null,
      destinationPort: json['destinationPort'] != null
          ? PortModel.fromJson(json['destinationPort'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originPortId': originPortId,
      'destinationPortId': destinationPortId,
      'estimatedDurationHours': estimatedDurationHours,
      'originPort': originPort?.toJson(),
      'destinationPort': destinationPort?.toJson(),
    };
  }
}
