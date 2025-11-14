enum PaymentMethod {
  midtrans,
  cash,
  bankTransfer;

  static PaymentMethod fromString(String method) {
    switch (method) {
      case 'MIDTRANS':
        return PaymentMethod.midtrans;
      case 'CASH':
        return PaymentMethod.cash;
      case 'BANK_TRANSFER':
        return PaymentMethod.bankTransfer;
      default:
        return PaymentMethod.midtrans;
    }
  }

  String toApiString() {
    switch (this) {
      case PaymentMethod.midtrans:
        return 'MIDTRANS';
      case PaymentMethod.cash:
        return 'CASH';
      case PaymentMethod.bankTransfer:
        return 'BANK_TRANSFER';
    }
  }
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded;

  static PaymentStatus fromString(String status) {
    switch (status) {
      case 'PENDING':
        return PaymentStatus.pending;
      case 'PAID':
        return PaymentStatus.paid;
      case 'FAILED':
        return PaymentStatus.failed;
      case 'REFUNDED':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  String toApiString() {
    switch (this) {
      case PaymentStatus.pending:
        return 'PENDING';
      case PaymentStatus.paid:
        return 'PAID';
      case PaymentStatus.failed:
        return 'FAILED';
      case PaymentStatus.refunded:
        return 'REFUNDED';
    }
  }
}

class PaymentModel {
  final String id;
  final String? bookingId;
  final String? jastipRequestId;
  final PaymentMethod paymentMethod;
  final String? externalReferenceId;
  final String? proofOfPaymentUrl;
  final PaymentStatus status;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentModel({
    required this.id,
    this.bookingId,
    this.jastipRequestId,
    required this.paymentMethod,
    this.externalReferenceId,
    this.proofOfPaymentUrl,
    required this.status,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String?,
      jastipRequestId: json['jastipRequestId'] as String?,
      paymentMethod: PaymentMethod.fromString(json['paymentMethod'] as String),
      externalReferenceId: json['externalReferenceId'] as String?,
      proofOfPaymentUrl: json['proofOfPaymentUrl'] as String?,
      status: PaymentStatus.fromString(json['status'] as String),
      amount: double.parse(json['amount'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'jastipRequestId': jastipRequestId,
      'paymentMethod': paymentMethod.toApiString(),
      'externalReferenceId': externalReferenceId,
      'proofOfPaymentUrl': proofOfPaymentUrl,
      'status': status.toApiString(),
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isPending => status == PaymentStatus.pending;
  bool get isPaid => status == PaymentStatus.paid;
  bool get isFailed => status == PaymentStatus.failed;
  bool get isRefunded => status == PaymentStatus.refunded;
}

class MidtransSnapResponse {
  final String token;
  final String redirectUrl;

  MidtransSnapResponse({
    required this.token,
    required this.redirectUrl,
  });

  factory MidtransSnapResponse.fromJson(Map<String, dynamic> json) {
    return MidtransSnapResponse(
      token: json['token'] as String,
      redirectUrl: json['redirect_url'] as String,
    );
  }
}
