import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  final String id;
  final String routeId;
  final String title;
  final int order;
  final int durationMin;
  final List<LessonBlock> blocks;

  LessonModel({
    required this.id,
    required this.routeId,
    required this.title,
    required this.order,
    required this.durationMin,
    required this.blocks,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['lessonId'] ?? '',
      routeId: json['routeId'] ?? '',
      title: json['title'] ?? '',
      order: json['order'] ?? 0,
      durationMin: json['durationMin'] ?? 5,
      blocks:
          (json['blocks'] as List<dynamic>?)
              ?.map((block) => LessonBlock.fromJson(block))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': id,
      'routeId': routeId,
      'title': title,
      'order': order,
      'durationMin': durationMin,
      'blocks': blocks.map((block) => block.toJson()).toList(),
    };
  }

  factory LessonModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LessonModel(
      id: doc.id,
      routeId: data['routeId'] ?? '',
      title: data['title'] ?? '',
      order: data['order'] ?? 0,
      durationMin: data['durationMin'] ?? 5,
      blocks:
          (data['blocks'] as List<dynamic>?)
              ?.map((block) => LessonBlock.fromJson(block))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'routeId': routeId,
      'title': title,
      'order': order,
      'durationMin': durationMin,
      'blocks': blocks.map((block) => block.toJson()).toList(),
    };
  }
}

class LessonBlock {
  final String type;
  final Map<String, dynamic> payload;

  LessonBlock({required this.type, required this.payload});

  factory LessonBlock.fromJson(Map<String, dynamic> json) {
    return LessonBlock(
      type: json['type'] ?? '',
      payload: Map<String, dynamic>.from(json['payload'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'payload': payload};
  }

  // Getters para tipos específicos
  bool get isText => type == 'text';
  bool get isMcq => type == 'mcq';
  bool get isVf => type == 'vf';
  bool get isGap => type == 'gap';
  bool get isSlider => type == 'slider';
  bool get isSim => type == 'sim';

  // Getters para payload específicos
  String get textContent => payload['md'] ?? '';

  String get mcqQuestion => payload['question'] ?? '';
  List<String> get mcqOptions => List<String>.from(payload['options'] ?? []);
  int get mcqAnswerIndex => payload['answerIndex'] ?? 0;
  String get mcqRationale => payload['rationale'] ?? '';

  String get vfStatement => payload['statement'] ?? '';
  bool get vfAnswer => payload['answer'] ?? false;
  String get vfRationale => payload['rationale'] ?? '';

  String get gapSentence => payload['sentence'] ?? '';
  String get gapMissing => payload['missing'] ?? '';

  String get sliderLabel => payload['label'] ?? '';
  double get sliderMin => (payload['min'] ?? 0).toDouble();
  double get sliderMax => (payload['max'] ?? 100).toDouble();
  double get sliderStep => (payload['step'] ?? 1).toDouble();
  double? get sliderCorrect => payload['correct']?.toDouble();
  double get sliderTolerance => (payload['tolerance'] ?? 0).toDouble();

  String get simName => payload['name'] ?? '';
  Map<String, dynamic> get simParams =>
      Map<String, dynamic>.from(payload['params'] ?? {});
}

class RouteModel {
  final String id;
  final String title;
  final String icon;
  final int order;

  RouteModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.order,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['routeId'] ?? '',
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'routeId': id, 'title': title, 'icon': icon, 'order': order};
  }

  factory RouteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RouteModel(
      id: doc.id,
      title: data['title'] ?? '',
      icon: data['icon'] ?? '',
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'title': title, 'icon': icon, 'order': order};
  }
}

class UserProgress {
  final String userId;
  final String lessonId;
  final String status; // 'new', 'in_progress', 'done'
  final int score; // 0-100
  final int attempts;
  final DateTime lastAt;

  UserProgress({
    required this.userId,
    required this.lessonId,
    required this.status,
    required this.score,
    required this.attempts,
    required this.lastAt,
  });

  factory UserProgress.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProgress(
      userId: data['userId'] ?? '',
      lessonId: data['lessonId'] ?? '',
      status: data['status'] ?? 'new',
      score: data['score'] ?? 0,
      attempts: data['attempts'] ?? 0,
      lastAt: (data['lastAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'lessonId': lessonId,
      'status': status,
      'score': score,
      'attempts': attempts,
      'lastAt': Timestamp.fromDate(lastAt),
    };
  }

  UserProgress copyWith({
    String? status,
    int? score,
    int? attempts,
    DateTime? lastAt,
  }) {
    return UserProgress(
      userId: userId,
      lessonId: lessonId,
      status: status ?? this.status,
      score: score ?? this.score,
      attempts: attempts ?? this.attempts,
      lastAt: lastAt ?? this.lastAt,
    );
  }
}

class UserStats {
  final String userId;
  final String period; // ej. week_2025_37
  final int xpEarned;
  final int lessonsCompleted;
  final Map<String, int> categoryBreakdown; // xp por routeId

  UserStats({
    required this.userId,
    required this.period,
    required this.xpEarned,
    required this.lessonsCompleted,
    required this.categoryBreakdown,
  });

  factory UserStats.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserStats(
      userId: data['userId'] ?? '',
      period: data['period'] ?? '',
      xpEarned: data['xpEarned'] ?? 0,
      lessonsCompleted: data['lessonsCompleted'] ?? 0,
      categoryBreakdown: Map<String, int>.from(data['categoryBreakdown'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'period': period,
      'xpEarned': xpEarned,
      'lessonsCompleted': lessonsCompleted,
      'categoryBreakdown': categoryBreakdown,
    };
  }
}

class LeaderboardEntry {
  final String uid;
  final String displayName;
  final int xp;
  final int rank;

  LeaderboardEntry({
    required this.uid,
    required this.displayName,
    required this.xp,
    required this.rank,
  });

  factory LeaderboardEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LeaderboardEntry(
      uid: data['uid'] ?? '',
      displayName: data['displayName'] ?? '',
      xp: data['xp'] ?? 0,
      rank: data['rank'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'uid': uid, 'displayName': displayName, 'xp': xp, 'rank': rank};
  }
}
