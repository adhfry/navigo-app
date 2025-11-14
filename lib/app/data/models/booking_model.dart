import 'schedule_model.dart';

enum BookingStatus {
  pendingPayment,
  confirmed,
  cancelled,
  completed;

  static BookingStatus fromString(String status) {
    switch (status) {
      case 'PENDING_PAYMENT':
        return BookingStatus.pendingPayment;
      case 'CONFIRMED':
        return BookingStatus.confirmed;
      case 'CANCELLED':
        return BookingStatus.cancelled;
      case 'COMPLETED':
        return BookingStatus.completed;
      default:
        return BookingStatus.pendingPayment;
    }
  }

  String toApiString() {
    switch (this) {
      case BookingStatus.pendingPayment:
        return 'PENDING_PAYMENT';
      case BookingStatus.confirmed:
        return 'CONFIRMED';
      case BookingStatus.cancelled:
        return 'CANCELLED';
      case BookingStatus.completed:
        return 'COMPLETED';
    }
  }
}

class BookingModel {
  final String id;
  final String userId;
  final String scheduleId;
  final BookingStatus status;
  final double totalPrice;
  final DateTime createdAt;
  final ScheduleModel? schedule;

  BookingModel({
    required this.id,
    required this.userId,
    required this.scheduleId,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    this.schedule,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      scheduleId: json['scheduleId'] as String,
      status: BookingStatus.fromString(json['status'] as String),
      totalPrice: double.parse(json['totalPrice'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      schedule: json['schedule'] != null
          ? ScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'scheduleId': scheduleId,
      'status': status.toApiString(),
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'schedule': schedule?.toJson(),
    };
  }

  bool get isPendingPayment => status == BookingStatus.pendingPayment;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCancelled => status == BookingStatus.cancelled;
  bool get isCompleted => status == BookingStatus.completed;
}
