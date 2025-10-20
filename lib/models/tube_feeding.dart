class TubeFeedingDetails {
  final String recommend;
  final String volumeToMix;
  final String timeMinutes;
  final String volumeToRinse;
  final List<String> notes;

  const TubeFeedingDetails({
    this.recommend = '',
    this.volumeToMix = '',
    this.timeMinutes = '',
    this.volumeToRinse = '',
    this.notes = const [],
  });

  factory TubeFeedingDetails.fromJson(Map<String, dynamic> json) {
    return TubeFeedingDetails(
      recommend: (json['recommend'] ?? '').toString(),
      volumeToMix: (json['volumeToMix'] ?? '').toString(),
      timeMinutes: (json['timeMinutes'] ?? '').toString(),
      volumeToRinse: (json['volumeToRinse'] ?? '').toString(),
      notes: (json['notes'] is List)
          ? List<String>.from((json['notes'] as List).map((e) => e.toString()))
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recommend': recommend,
      'volumeToMix': volumeToMix,
      'timeMinutes': timeMinutes,
      'volumeToRinse': volumeToRinse,
      'notes': notes,
    };
  }
}

class TubeFeeding {
  final TubeFeedingDetails gastric;
  final TubeFeedingDetails jejunal;

  const TubeFeeding({
    this.gastric = const TubeFeedingDetails(),
    this.jejunal = const TubeFeedingDetails(),
  });

  factory TubeFeeding.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> gastricJson =
        (json['gastric'] is Map<String, dynamic>) ? json['gastric'] : {};
    final Map<String, dynamic> jejunalJson =
        (json['jejunal'] is Map<String, dynamic>) ? json['jejunal'] : {};
    return TubeFeeding(
      gastric: TubeFeedingDetails.fromJson(gastricJson),
      jejunal: TubeFeedingDetails.fromJson(jejunalJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gastric': gastric.toJson(),
      'jejunal': jejunal.toJson(),
    };
  }
}


