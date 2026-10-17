import 'package:equatable/equatable.dart';

enum DrSeverity {
  none,
  mild,
  moderate,
  severe,
  proliferative,
}

extension DrSeverityX on DrSeverity {
  String get label => switch (this) {
        DrSeverity.none => 'No DR',
        DrSeverity.mild => 'Mild NPDR',
        DrSeverity.moderate => 'Moderate NPDR',
        DrSeverity.severe => 'Severe NPDR',
        DrSeverity.proliferative => 'Proliferative DR',
      };

  String get description => switch (this) {
        DrSeverity.none =>
          'No signs of diabetic retinopathy detected. Continue regular screening.',
        DrSeverity.mild =>
          'Mild non-proliferative changes observed. Monitor closely.',
        DrSeverity.moderate =>
          'Moderate non-proliferative diabetic retinopathy detected.',
        DrSeverity.severe =>
          'Severe non-proliferative changes. Urgent ophthalmology referral recommended.',
        DrSeverity.proliferative =>
          'Proliferative diabetic retinopathy detected. Immediate specialist care required.',
      };

  int get riskLevel => switch (this) {
        DrSeverity.none => 1,
        DrSeverity.mild => 2,
        DrSeverity.moderate => 3,
        DrSeverity.severe => 4,
        DrSeverity.proliferative => 5,
      };
}

class Patient extends Equatable {
  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.diabetesType,
    required this.lastScanDate,
    this.avatarUrl,
    this.riskLevel = DrSeverity.none,
  });

  final String id;
  final String name;
  final int age;
  final String gender;
  final String diabetesType;
  final DateTime? lastScanDate;
  final String? avatarUrl;
  final DrSeverity riskLevel;

  @override
  List<Object?> get props =>
      [id, name, age, gender, diabetesType, lastScanDate, avatarUrl, riskLevel];
}

class ScanResult extends Equatable {
  const ScanResult({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.timestamp,
    required this.severity,
    required this.confidence,
    required this.detectedFeatures,
    required this.recommendations,
    this.imagePath,
    this.doctorNotes,
  });

  final String id;
  final String patientId;
  final String patientName;
  final DateTime timestamp;
  final DrSeverity severity;
  final double confidence;
  final List<String> detectedFeatures;
  final List<String> recommendations;
  final String? imagePath;
  final String? doctorNotes;

  @override
  List<Object?> get props => [
        id,
        patientId,
        patientName,
        timestamp,
        severity,
        confidence,
        detectedFeatures,
        recommendations,
        imagePath,
        doctorNotes,
      ];
}

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.hospital,
    this.avatarUrl,
    this.licenseNumber,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String hospital;
  final String? avatarUrl;
  final String? licenseNumber;

  @override
  List<Object?> get props =>
      [id, name, email, role, hospital, avatarUrl, licenseNumber];
}

class DashboardStats extends Equatable {
  const DashboardStats({
    required this.totalScans,
    required this.todayScans,
    required this.highRiskCases,
    required this.averageConfidence,
    required this.severityDistribution,
  });

  final int totalScans;
  final int todayScans;
  final int highRiskCases;
  final double averageConfidence;
  final Map<DrSeverity, int> severityDistribution;

  @override
  List<Object?> get props => [
        totalScans,
        todayScans,
        highRiskCases,
        averageConfidence,
        severityDistribution,
      ];
}
