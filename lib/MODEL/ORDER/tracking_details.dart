import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingModel {
  TrackingModel({
    required this.stage,
    required this.updatedAt,
    required this.updatedStages,
  });

  final String stage;
  static const String stageKey = "stage";

  final DateTime? updatedAt;
  static const String updatedAtKey = "updated_at";

  final Map<String, DateTime> updatedStages;
  static const String updatedStagesKey = "updatedStages";

  TrackingModel copyWith({
    String? stage,
    DateTime? updatedAt,
    Map<String, DateTime>? updatedStages,
  }) {
    return TrackingModel(
      stage: stage ?? this.stage,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedStages: updatedStages ?? this.updatedStages,
    );
  }

  factory TrackingModel.fromJson(Map<String, dynamic> json) {
    return TrackingModel(
      stage: json[stageKey] ?? "",
      updatedAt: json[updatedAtKey] != null
          ? (json[updatedAtKey] as Timestamp).toDate()
          : null,
      updatedStages: (json[updatedStagesKey] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, (value as Timestamp).toDate())) ??
          {},
    );
  }

  Map<String, dynamic> toJson() => {
        stageKey: stage,
        updatedAtKey: updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
        updatedStagesKey: updatedStages
            .map((key, value) => MapEntry(key, Timestamp.fromDate(value))),
      };

  @override
  String toString() {
    return "Stage: $stage, Updated At: $updatedAt, Updated Stages: $updatedStages";
  }
}
