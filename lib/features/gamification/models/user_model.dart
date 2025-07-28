class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final int level;
  final int experience;
  final int coins;
  final int streak;
  final DateTime lastLogin;
  final List<String> completedLessons;
  final List<String> achievements;
  final Map<String, int> categoryProgress;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.level = 1,
    this.experience = 0,
    this.coins = 0,
    this.streak = 0,
    required this.lastLogin,
    this.completedLessons = const [],
    this.achievements = const [],
    this.categoryProgress = const {},
  });

  // Calcular XP necesario para el siguiente nivel
  int get experienceToNextLevel {
    return level * 100; // 100 XP por nivel
  }

  // Calcular progreso hacia el siguiente nivel
  double get levelProgress {
    return experience / experienceToNextLevel;
  }

  // Verificar si puede subir de nivel
  bool get canLevelUp {
    return experience >= experienceToNextLevel;
  }

  // Factory constructor desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      photoURL: json['photoURL'],
      level: json['level'] ?? 1,
      experience: json['experience'] ?? 0,
      coins: json['coins'] ?? 0,
      streak: json['streak'] ?? 0,
      lastLogin: DateTime.parse(json['lastLogin'] ?? DateTime.now().toIso8601String()),
      completedLessons: List<String>.from(json['completedLessons'] ?? []),
      achievements: List<String>.from(json['achievements'] ?? []),
      categoryProgress: Map<String, int>.from(json['categoryProgress'] ?? {}),
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'level': level,
      'experience': experience,
      'coins': coins,
      'streak': streak,
      'lastLogin': lastLogin.toIso8601String(),
      'completedLessons': completedLessons,
      'achievements': achievements,
      'categoryProgress': categoryProgress,
    };
  }

  // Copiar con cambios
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    int? level,
    int? experience,
    int? coins,
    int? streak,
    DateTime? lastLogin,
    List<String>? completedLessons,
    List<String>? achievements,
    Map<String, int>? categoryProgress,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      coins: coins ?? this.coins,
      streak: streak ?? this.streak,
      lastLogin: lastLogin ?? this.lastLogin,
      completedLessons: completedLessons ?? this.completedLessons,
      achievements: achievements ?? this.achievements,
      categoryProgress: categoryProgress ?? this.categoryProgress,
    );
  }
} 