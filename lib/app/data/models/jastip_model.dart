import 'port_model.dart';
import 'user_model.dart';

enum JastipRequestStatus {
  open,
  accepted,
  inTransit,
  delivered,
  completed,
  cancelled;

  static JastipRequestStatus fromString(String status) {
    switch (status) {
      case 'OPEN':
        return JastipRequestStatus.open;
      case 'ACCEPTED':
        return JastipRequestStatus.accepted;
      case 'IN_TRANSIT':
        return JastipRequestStatus.inTransit;
      case 'DELIVERED':
        return JastipRequestStatus.delivered;
      case 'COMPLETED':
        return JastipRequestStatus.completed;
      case 'CANCELLED':
        return JastipRequestStatus.cancelled;
      default:
        return JastipRequestStatus.open;
    }
  }

  String toApiString() {
    switch (this) {
      case JastipRequestStatus.open:
        return 'OPEN';
      case JastipRequestStatus.accepted:
        return 'ACCEPTED';
      case JastipRequestStatus.inTransit:
        return 'IN_TRANSIT';
      case JastipRequestStatus.delivered:
        return 'DELIVERED';
      case JastipRequestStatus.completed:
        return 'COMPLETED';
      case JastipRequestStatus.cancelled:
        return 'CANCELLED';
    }
  }
}

enum JastipOfferStatus {
  pending,
  accepted,
  rejected;

  static JastipOfferStatus fromString(String status) {
    switch (status) {
      case 'PENDING':
        return JastipOfferStatus.pending;
      case 'ACCEPTED':
        return JastipOfferStatus.accepted;
      case 'REJECTED':
        return JastipOfferStatus.rejected;
      default:
        return JastipOfferStatus.pending;
    }
  }

  String toApiString() {
    switch (this) {
      case JastipOfferStatus.pending:
        return 'PENDING';
      case JastipOfferStatus.accepted:
        return 'ACCEPTED';
      case JastipOfferStatus.rejected:
        return 'REJECTED';
    }
  }
}

class JastipRequestModel {
  final String id;
  final String requesterUserId;
  final String requestType; // DELIVER or PICKUP
  final String originPortId;
  final String destinationPortId;
  final JastipRequestStatus status;
  final String? acceptedOfferId;
  final String itemName;
  final String? itemDescription;
  final String? itemPhotoUrl;
  final double rewardAmount;
  final String? receiverName;
  final String? receiverPhone;
  final String? pickupContactName;
  final String? pickupContactPhone;
  final String? pickupAddressDetail;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final String? deliveryAddressDetail;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PortModel? originPort;
  final PortModel? destinationPort;
  final UserModel? requester;
  final JastipOfferModel? acceptedOffer;

  JastipRequestModel({
    required this.id,
    required this.requesterUserId,
    required this.requestType,
    required this.originPortId,
    required this.destinationPortId,
    required this.status,
    this.acceptedOfferId,
    required this.itemName,
    this.itemDescription,
    this.itemPhotoUrl,
    required this.rewardAmount,
    this.receiverName,
    this.receiverPhone,
    this.pickupContactName,
    this.pickupContactPhone,
    this.pickupAddressDetail,
    this.pickupLatitude,
    this.pickupLongitude,
    this.deliveryAddressDetail,
    this.deliveryLatitude,
    this.deliveryLongitude,
    required this.createdAt,
    required this.updatedAt,
    this.originPort,
    this.destinationPort,
    this.requester,
    this.acceptedOffer,
  });

  factory JastipRequestModel.fromJson(Map<String, dynamic> json) {
    return JastipRequestModel(
      id: json['id'] as String,
      requesterUserId: json['requesterUserId'] as String,
      requestType: json['requestType'] as String,
      originPortId: json['originPortId'] as String,
      destinationPortId: json['destinationPortId'] as String,
      status: JastipRequestStatus.fromString(json['status'] as String),
      acceptedOfferId: json['acceptedOfferId'] as String?,
      itemName: json['itemName'] as String,
      itemDescription: json['itemDescription'] as String?,
      itemPhotoUrl: json['itemPhotoUrl'] as String?,
      rewardAmount: double.parse(json['rewardAmount'].toString()),
      receiverName: json['receiverName'] as String?,
      receiverPhone: json['receiverPhone'] as String?,
      pickupContactName: json['pickupContactName'] as String?,
      pickupContactPhone: json['pickupContactPhone'] as String?,
      pickupAddressDetail: json['pickupAddressDetail'] as String?,
      pickupLatitude: json['pickupLatitude'] != null
          ? double.parse(json['pickupLatitude'].toString())
          : null,
      pickupLongitude: json['pickupLongitude'] != null
          ? double.parse(json['pickupLongitude'].toString())
          : null,
      deliveryAddressDetail: json['deliveryAddressDetail'] as String?,
      deliveryLatitude: json['deliveryLatitude'] != null
          ? double.parse(json['deliveryLatitude'].toString())
          : null,
      deliveryLongitude: json['deliveryLongitude'] != null
          ? double.parse(json['deliveryLongitude'].toString())
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      originPort: json['originPort'] != null
          ? PortModel.fromJson(json['originPort'] as Map<String, dynamic>)
          : null,
      destinationPort: json['destinationPort'] != null
          ? PortModel.fromJson(
              json['destinationPort'] as Map<String, dynamic>)
          : null,
      requester: json['requester'] != null
          ? UserModel.fromJson(json['requester'] as Map<String, dynamic>)
          : null,
      acceptedOffer: json['acceptedOffer'] != null
          ? JastipOfferModel.fromJson(
              json['acceptedOffer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requesterUserId': requesterUserId,
      'requestType': requestType,
      'originPortId': originPortId,
      'destinationPortId': destinationPortId,
      'status': status.toApiString(),
      'acceptedOfferId': acceptedOfferId,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemPhotoUrl': itemPhotoUrl,
      'rewardAmount': rewardAmount,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'pickupContactName': pickupContactName,
      'pickupContactPhone': pickupContactPhone,
      'pickupAddressDetail': pickupAddressDetail,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'deliveryAddressDetail': deliveryAddressDetail,
      'deliveryLatitude': deliveryLatitude,
      'deliveryLongitude': deliveryLongitude,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'originPort': originPort?.toJson(),
      'destinationPort': destinationPort?.toJson(),
      'requester': requester?.toJson(),
      'acceptedOffer': acceptedOffer?.toJson(),
    };
  }

  bool get isDeliver => requestType == 'DELIVER';
  bool get isPickup => requestType == 'PICKUP';
  bool get isOpen => status == JastipRequestStatus.open;
  bool get isAccepted => status == JastipRequestStatus.accepted;
  bool get isInTransit => status == JastipRequestStatus.inTransit;
  bool get isDelivered => status == JastipRequestStatus.delivered;
  bool get isCompleted => status == JastipRequestStatus.completed;
  bool get isCancelled => status == JastipRequestStatus.cancelled;
}

class JastipOfferModel {
  final String id;
  final String requestId;
  final String travelerUserId;
  final JastipOfferStatus status;
  final DateTime createdAt;
  final UserModel? traveler;

  JastipOfferModel({
    required this.id,
    required this.requestId,
    required this.travelerUserId,
    required this.status,
    required this.createdAt,
    this.traveler,
  });

  factory JastipOfferModel.fromJson(Map<String, dynamic> json) {
    return JastipOfferModel(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      travelerUserId: json['travelerUserId'] as String,
      status: JastipOfferStatus.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      traveler: json['traveler'] != null
          ? UserModel.fromJson(json['traveler'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestId': requestId,
      'travelerUserId': travelerUserId,
      'status': status.toApiString(),
      'createdAt': createdAt.toIso8601String(),
      'traveler': traveler?.toJson(),
    };
  }

  bool get isPending => status == JastipOfferStatus.pending;
  bool get isAccepted => status == JastipOfferStatus.accepted;
  bool get isRejected => status == JastipOfferStatus.rejected;
}
