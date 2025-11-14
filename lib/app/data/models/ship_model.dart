class ShipPhotoModel {
  final String id;
  final String shipId;
  final String photoUrl;
  final bool isPrimary;

  ShipPhotoModel({
    required this.id,
    required this.shipId,
    required this.photoUrl,
    required this.isPrimary,
  });

  factory ShipPhotoModel.fromJson(Map<String, dynamic> json) {
    return ShipPhotoModel(
      id: json['id'] as String,
      shipId: json['shipId'] as String,
      photoUrl: json['photoUrl'] as String,
      isPrimary: json['isPrimary'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shipId': shipId,
      'photoUrl': photoUrl,
      'isPrimary': isPrimary,
    };
  }
}

class ShipModel {
  final String id;
  final String operatorId;
  final String name;
  final String? description;
  final int capacity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ShipPhotoModel>? photos;

  ShipModel({
    required this.id,
    required this.operatorId,
    required this.name,
    this.description,
    required this.capacity,
    required this.createdAt,
    required this.updatedAt,
    this.photos,
  });

  factory ShipModel.fromJson(Map<String, dynamic> json) {
    return ShipModel(
      id: json['id'] as String,
      operatorId: json['operatorId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      capacity: json['capacity'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      photos: json['photos'] != null
          ? (json['photos'] as List)
              .map((photo) =>
                  ShipPhotoModel.fromJson(photo as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operatorId': operatorId,
      'name': name,
      'description': description,
      'capacity': capacity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'photos': photos?.map((photo) => photo.toJson()).toList(),
    };
  }

  String? get primaryPhotoUrl {
    if (photos == null || photos!.isEmpty) return null;
    final primary = photos!.firstWhere(
      (photo) => photo.isPrimary,
      orElse: () => photos!.first,
    );
    return primary.photoUrl;
  }
}
