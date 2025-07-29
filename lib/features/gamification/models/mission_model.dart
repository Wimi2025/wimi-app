import 'package:flutter/material.dart';

enum MissionType {
  daily, // Misiones diarias
  weekly, // Misiones semanales
  monthly, // Misiones mensuales
  special, // Misiones especiales de eventos
  story, // Misiones de historia/campaña
}

enum MissionStatus {
  locked, // Bloqueada (requisitos no cumplidos)
  available, // Disponible para iniciar
  active, // En progreso
  completed, // Completada
  expired, // Expirada
}

enum MissionDifficulty {
  beginner, // Principiante
  intermediate, // Intermedio
  advanced, // Avanzado
  expert, // Experto
}

class Mission {
  final String id;
  final String title;
  final String description;
  final String longDescription;

  final MissionType type;
  final MissionStatus status;
  final MissionDifficulty difficulty;

  // Recompensas
  final int xpReward;
  final int coinsReward;
  final List<String> badgeRewards;
  final Map<String, dynamic> specialRewards;

  // Progreso
  final int currentProgress;
  final int targetProgress;
  final List<MissionObjective> objectives;

  // Configuración
  final DateTime? startDate;
  final DateTime? endDate;
  final Duration? timeLimit;
  final List<String> prerequisites; // IDs de misiones prerequisito

  // Metadatos
  final String category; // 'ahorro', 'inversion', 'presupuesto', etc.
  final String iconPath;
  final Color primaryColor;
  final List<String> tags;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.longDescription,
    required this.type,
    required this.status,
    required this.difficulty,
    required this.xpReward,
    required this.coinsReward,
    required this.badgeRewards,
    required this.specialRewards,
    required this.currentProgress,
    required this.targetProgress,
    required this.objectives,
    this.startDate,
    this.endDate,
    this.timeLimit,
    required this.prerequisites,
    required this.category,
    required this.iconPath,
    required this.primaryColor,
    required this.tags,
  });

  // Getters calculados
  double get progressPercentage => targetProgress > 0
      ? (currentProgress / targetProgress).clamp(0.0, 1.0)
      : 0.0;

  bool get isCompleted => status == MissionStatus.completed;
  bool get isActive => status == MissionStatus.active;
  bool get isExpired => endDate != null && DateTime.now().isAfter(endDate!);
  bool get hasTimeLimit => timeLimit != null;

  Duration? get remainingTime {
    if (endDate == null) return null;
    final remaining = endDate!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  String get difficultyDisplayName {
    switch (difficulty) {
      case MissionDifficulty.beginner:
        return 'Principiante';
      case MissionDifficulty.intermediate:
        return 'Intermedio';
      case MissionDifficulty.advanced:
        return 'Avanzado';
      case MissionDifficulty.expert:
        return 'Experto';
    }
  }

  String get typeDisplayName {
    switch (type) {
      case MissionType.daily:
        return 'Diaria';
      case MissionType.weekly:
        return 'Semanal';
      case MissionType.monthly:
        return 'Mensual';
      case MissionType.special:
        return 'Especial';
      case MissionType.story:
        return 'Historia';
    }
  }

  // Métodos de utilidad
  Mission copyWith({
    String? id,
    String? title,
    String? description,
    String? longDescription,
    MissionType? type,
    MissionStatus? status,
    MissionDifficulty? difficulty,
    int? xpReward,
    int? coinsReward,
    List<String>? badgeRewards,
    Map<String, dynamic>? specialRewards,
    int? currentProgress,
    int? targetProgress,
    List<MissionObjective>? objectives,
    DateTime? startDate,
    DateTime? endDate,
    Duration? timeLimit,
    List<String>? prerequisites,
    String? category,
    String? iconPath,
    Color? primaryColor,
    List<String>? tags,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      longDescription: longDescription ?? this.longDescription,
      type: type ?? this.type,
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      xpReward: xpReward ?? this.xpReward,
      coinsReward: coinsReward ?? this.coinsReward,
      badgeRewards: badgeRewards ?? this.badgeRewards,
      specialRewards: specialRewards ?? this.specialRewards,
      currentProgress: currentProgress ?? this.currentProgress,
      targetProgress: targetProgress ?? this.targetProgress,
      objectives: objectives ?? this.objectives,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      timeLimit: timeLimit ?? this.timeLimit,
      prerequisites: prerequisites ?? this.prerequisites,
      category: category ?? this.category,
      iconPath: iconPath ?? this.iconPath,
      primaryColor: primaryColor ?? this.primaryColor,
      tags: tags ?? this.tags,
    );
  }

  // Serialización
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'longDescription': longDescription,
      'type': type.index,
      'status': status.index,
      'difficulty': difficulty.index,
      'xpReward': xpReward,
      'coinsReward': coinsReward,
      'badgeRewards': badgeRewards,
      'specialRewards': specialRewards,
      'currentProgress': currentProgress,
      'targetProgress': targetProgress,
      'objectives': objectives.map((obj) => obj.toJson()).toList(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'timeLimit': timeLimit?.inMilliseconds,
      'prerequisites': prerequisites,
      'category': category,
      'iconPath': iconPath,
      'primaryColor': primaryColor.value,
      'tags': tags,
    };
  }

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      longDescription: json['longDescription'],
      type: MissionType.values[json['type']],
      status: MissionStatus.values[json['status']],
      difficulty: MissionDifficulty.values[json['difficulty']],
      xpReward: json['xpReward'],
      coinsReward: json['coinsReward'],
      badgeRewards: List<String>.from(json['badgeRewards']),
      specialRewards: Map<String, dynamic>.from(json['specialRewards']),
      currentProgress: json['currentProgress'],
      targetProgress: json['targetProgress'],
      objectives: (json['objectives'] as List)
          .map((obj) => MissionObjective.fromJson(obj))
          .toList(),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      timeLimit: json['timeLimit'] != null
          ? Duration(milliseconds: json['timeLimit'])
          : null,
      prerequisites: List<String>.from(json['prerequisites']),
      category: json['category'],
      iconPath: json['iconPath'],
      primaryColor: Color(json['primaryColor']),
      tags: List<String>.from(json['tags']),
    );
  }
}

class MissionObjective {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final int currentValue;
  final int targetValue;
  final String type; // 'lesson_complete', 'xp_earn', 'streak_maintain', etc.
  final Map<String, dynamic> parameters;

  const MissionObjective({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.currentValue,
    required this.targetValue,
    required this.type,
    required this.parameters,
  });

  double get progressPercentage =>
      targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;

  MissionObjective copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    int? currentValue,
    int? targetValue,
    String? type,
    Map<String, dynamic>? parameters,
  }) {
    return MissionObjective(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue ?? this.targetValue,
      type: type ?? this.type,
      parameters: parameters ?? this.parameters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'currentValue': currentValue,
      'targetValue': targetValue,
      'type': type,
      'parameters': parameters,
    };
  }

  factory MissionObjective.fromJson(Map<String, dynamic> json) {
    return MissionObjective(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      currentValue: json['currentValue'],
      targetValue: json['targetValue'],
      type: json['type'],
      parameters: Map<String, dynamic>.from(json['parameters']),
    );
  }
}

// Factory para crear misiones predefinidas
class MissionFactory {
  static List<Mission> getDefaultMissions() {
    return [
      // Misión diaria de ejemplo
      Mission(
        id: 'daily_lesson_complete',
        title: 'Aprendiz Diario',
        description: 'Completa una lección hoy',
        longDescription:
            'Mantén tu racha de aprendizaje completando al menos una lección cada día.',
        type: MissionType.daily,
        status: MissionStatus.available,
        difficulty: MissionDifficulty.beginner,
        xpReward: 50,
        coinsReward: 25,
        badgeRewards: [],
        specialRewards: {},
        currentProgress: 0,
        targetProgress: 1,
        objectives: [
          MissionObjective(
            id: 'complete_lesson',
            title: 'Completar lección',
            description: 'Completa cualquier lección disponible',
            isCompleted: false,
            currentValue: 0,
            targetValue: 1,
            type: 'lesson_complete',
            parameters: {},
          ),
        ],
        endDate: DateTime.now().add(const Duration(days: 1)),
        prerequisites: [],
        category: 'general',
        iconPath: 'assets/icons/daily_mission.svg',
        primaryColor: Colors.blue,
        tags: ['diario', 'leccion'],
      ),

      // Misión semanal de ejemplo
      Mission(
        id: 'weekly_streak',
        title: 'Racha Semanal',
        description: 'Mantén una racha de 7 días',
        longDescription:
            'Demuestra tu dedicación manteniendo una racha de aprendizaje durante toda la semana.',
        type: MissionType.weekly,
        status: MissionStatus.available,
        difficulty: MissionDifficulty.intermediate,
        xpReward: 300,
        coinsReward: 150,
        badgeRewards: ['streak_master'],
        specialRewards: {'special_theme': 'fire_theme'},
        currentProgress: 0,
        targetProgress: 7,
        objectives: [
          MissionObjective(
            id: 'maintain_streak',
            title: 'Mantener racha',
            description: 'Estudia durante 7 días consecutivos',
            isCompleted: false,
            currentValue: 0,
            targetValue: 7,
            type: 'streak_maintain',
            parameters: {'consecutive_days': 7},
          ),
        ],
        endDate: DateTime.now().add(const Duration(days: 7)),
        prerequisites: [],
        category: 'disciplina',
        iconPath: 'assets/icons/streak_mission.svg',
        primaryColor: Colors.orange,
        tags: ['semanal', 'racha', 'disciplina'],
      ),
    ];
  }
}
