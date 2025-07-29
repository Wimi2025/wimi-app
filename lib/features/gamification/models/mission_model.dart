import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'mission_model.freezed.dart';
part 'mission_model.g.dart';

@freezed
class Mission with _$Mission {
  const factory Mission({
    required String id,
    required String title,
    required String description,
    required String category,
    required MissionType type,
    required MissionDifficulty difficulty,
    required int xpReward,
    required int coinsReward,
    required Map<String, dynamic> requirements,
    required Map<String, dynamic> progress,
    required DateTime createdAt,
    required DateTime? expiresAt,
    @Default(false) bool isCompleted,
    @Default(false) bool isActive,
    @Default(false) bool isDaily,
    @Default(false) bool isWeekly,
    @Default([]) List<String> prerequisites,
    @Default([]) List<MissionReward> rewards,
  }) = _Mission;

  factory Mission.fromJson(Map<String, dynamic> json) =>
      _$MissionFromJson(json);
}

@freezed
class MissionReward with _$MissionReward {
  const factory MissionReward({
    required RewardType type,
    required String id,
    required int quantity,
    String? description,
  }) = _MissionReward;

  factory MissionReward.fromJson(Map<String, dynamic> json) =>
      _$MissionRewardFromJson(json);
}

enum MissionType {
  lesson, // Completar lecciones
  streak, // Mantener racha
  score, // Obtener puntuación
  time, // Tiempo en app
  social, // Actividades sociales
  achievement, // Desbloquear logros
  quiz, // Responder quizzes
  video, // Ver videos
  reading, // Leer contenido
  practice, // Ejercicios prácticos
  challenge, // Desafíos especiales
  exploration, // Explorar secciones
}

enum MissionDifficulty { easy, medium, hard, expert }

enum RewardType { xp, coins, badge, avatar, theme, powerup, unlockContent }

// Extensiones para facilitar el uso
extension MissionTypeExtension on MissionType {
  String get displayName {
    switch (this) {
      case MissionType.lesson:
        return 'Lección';
      case MissionType.streak:
        return 'Racha';
      case MissionType.score:
        return 'Puntuación';
      case MissionType.time:
        return 'Tiempo';
      case MissionType.social:
        return 'Social';
      case MissionType.achievement:
        return 'Logro';
      case MissionType.quiz:
        return 'Quiz';
      case MissionType.video:
        return 'Video';
      case MissionType.reading:
        return 'Lectura';
      case MissionType.practice:
        return 'Práctica';
      case MissionType.challenge:
        return 'Desafío';
      case MissionType.exploration:
        return 'Exploración';
    }
  }

  String get icon {
    switch (this) {
      case MissionType.lesson:
        return '📚';
      case MissionType.streak:
        return '🔥';
      case MissionType.score:
        return '⭐';
      case MissionType.time:
        return '⏱️';
      case MissionType.social:
        return '👥';
      case MissionType.achievement:
        return '🏆';
      case MissionType.quiz:
        return '❓';
      case MissionType.video:
        return '🎥';
      case MissionType.reading:
        return '📖';
      case MissionType.practice:
        return '💪';
      case MissionType.challenge:
        return '⚡';
      case MissionType.exploration:
        return '🗺️';
    }
  }
}

extension MissionDifficultyExtension on MissionDifficulty {
  String get displayName {
    switch (this) {
      case MissionDifficulty.easy:
        return 'Fácil';
      case MissionDifficulty.medium:
        return 'Medio';
      case MissionDifficulty.hard:
        return 'Difícil';
      case MissionDifficulty.expert:
        return 'Experto';
    }
  }

  String get color {
    switch (this) {
      case MissionDifficulty.easy:
        return '#4CAF50';
      case MissionDifficulty.medium:
        return '#FF9800';
      case MissionDifficulty.hard:
        return '#F44336';
      case MissionDifficulty.expert:
        return '#9C27B0';
    }
  }

  int get multiplier {
    switch (this) {
      case MissionDifficulty.easy:
        return 1;
      case MissionDifficulty.medium:
        return 2;
      case MissionDifficulty.hard:
        return 3;
      case MissionDifficulty.expert:
        return 5;
    }
  }
}

// Clase para gestionar progreso de misiones
class MissionProgress extends Equatable {
  final String missionId;
  final int currentValue;
  final int targetValue;
  final DateTime lastUpdate;
  final Map<String, dynamic> metadata;

  const MissionProgress({
    required this.missionId,
    required this.currentValue,
    required this.targetValue,
    required this.lastUpdate,
    this.metadata = const {},
  });

  double get progressPercentage =>
      targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;

  bool get isCompleted => currentValue >= targetValue;

  int get remainingValue => (targetValue - currentValue).clamp(0, targetValue);

  MissionProgress copyWith({
    String? missionId,
    int? currentValue,
    int? targetValue,
    DateTime? lastUpdate,
    Map<String, dynamic>? metadata,
  }) {
    return MissionProgress(
      missionId: missionId ?? this.missionId,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue ?? this.targetValue,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      metadata: metadata ?? this.metadata,
    );
  }

  factory MissionProgress.fromJson(Map<String, dynamic> json) {
    return MissionProgress(
      missionId: json['missionId'] as String,
      currentValue: json['currentValue'] as int,
      targetValue: json['targetValue'] as int,
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'missionId': missionId,
      'currentValue': currentValue,
      'targetValue': targetValue,
      'lastUpdate': lastUpdate.toIso8601String(),
      'metadata': metadata,
    };
  }

  @override
  List<Object?> get props => [
    missionId,
    currentValue,
    targetValue,
    lastUpdate,
    metadata,
  ];
}

// Factory para crear misiones predefinidas
class MissionFactory {
  static Mission createDailyLesson() {
    return Mission(
      id: 'daily_lesson_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Lección Diaria',
      description: 'Completa al menos una lección hoy',
      category: 'daily',
      type: MissionType.lesson,
      difficulty: MissionDifficulty.easy,
      xpReward: 50,
      coinsReward: 10,
      requirements: {'lessons_to_complete': 1},
      progress: {'lessons_completed': 0},
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 1)),
      isDaily: true,
      isActive: true,
    );
  }

  static Mission createWeeklyStreak() {
    return Mission(
      id: 'weekly_streak_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Racha Semanal',
      description: 'Mantén una racha de 7 días consecutivos',
      category: 'weekly',
      type: MissionType.streak,
      difficulty: MissionDifficulty.medium,
      xpReward: 200,
      coinsReward: 50,
      requirements: {'streak_days': 7},
      progress: {'current_streak': 0},
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      isWeekly: true,
      isActive: true,
    );
  }

  static Mission createChallengeQuiz(String category) {
    return Mission(
      id: 'challenge_quiz_${category}_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Desafío de $category',
      description: 'Responde correctamente 5 preguntas de $category',
      category: category,
      type: MissionType.quiz,
      difficulty: MissionDifficulty.hard,
      xpReward: 100,
      coinsReward: 25,
      requirements: {'correct_answers': 5, 'category': category},
      progress: {'answers_correct': 0},
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 3)),
      isActive: true,
    );
  }
}
