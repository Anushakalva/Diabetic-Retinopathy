import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/app_models.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  return PatientRepository();
});

final scanRepositoryProvider = Provider<ScanRepository>((ref) {
  return ScanRepository();
});

class AuthRepository {
  UserProfile? _currentUser;

  UserProfile? get currentUser => _currentUser;

  Future<UserProfile> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    _currentUser = const UserProfile(
      id: 'doc-001',
      name: 'Dr. Sarah Mitchell',
      email: 'sarah.mitchell@retinacare.org',
      role: 'Ophthalmologist',
      hospital: 'Metro Eye Institute',
      licenseNumber: 'MD-284719',
    );
    return _currentUser!;
  }

  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _currentUser = null;
  }

  bool get isAuthenticated => _currentUser != null;
}

class PatientRepository {
  final List<Patient> _patients = [
    Patient(
      id: 'p-001',
      name: 'James Wilson',
      age: 58,
      gender: 'Male',
      diabetesType: 'Type 2',
      lastScanDate: DateTime.now().subtract(const Duration(days: 14)),
      riskLevel: DrSeverity.mild,
    ),
    Patient(
      id: 'p-002',
      name: 'Maria Garcia',
      age: 45,
      gender: 'Female',
      diabetesType: 'Type 1',
      lastScanDate: DateTime.now().subtract(const Duration(days: 3)),
      riskLevel: DrSeverity.none,
    ),
    Patient(
      id: 'p-003',
      name: 'Robert Chen',
      age: 62,
      gender: 'Male',
      diabetesType: 'Type 2',
      lastScanDate: DateTime.now().subtract(const Duration(days: 45)),
      riskLevel: DrSeverity.moderate,
    ),
    Patient(
      id: 'p-004',
      name: 'Emily Thompson',
      age: 51,
      gender: 'Female',
      diabetesType: 'Type 2',
      lastScanDate: DateTime.now().subtract(const Duration(days: 7)),
      riskLevel: DrSeverity.severe,
    ),
    Patient(
      id: 'p-005',
      name: 'David Park',
      age: 39,
      gender: 'Male',
      diabetesType: 'Type 1',
      lastScanDate: DateTime.now().subtract(const Duration(days: 21)),
      riskLevel: DrSeverity.none,
    ),
  ];

  List<Patient> getAll() => List.unmodifiable(_patients);

  Patient? getById(String id) {
    try {
      return _patients.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Patient> search(String query) {
    if (query.isEmpty) return getAll();
    final q = query.toLowerCase();
    return _patients
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.diabetesType.toLowerCase().contains(q))
        .toList();
  }
}

class ScanRepository {
  final _uuid = const Uuid();
  final _random = Random();

  final List<ScanResult> _scans = [
    ScanResult(
      id: 's-001',
      patientId: 'p-001',
      patientName: 'James Wilson',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      severity: DrSeverity.mild,
      confidence: 0.94,
      detectedFeatures: ['Microaneurysms', 'Mild hemorrhages'],
      recommendations: [
        'Schedule follow-up in 6 months',
        'Optimize glycemic control',
        'Monitor blood pressure',
      ],
    ),
    ScanResult(
      id: 's-002',
      patientId: 'p-004',
      patientName: 'Emily Thompson',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      severity: DrSeverity.severe,
      confidence: 0.91,
      detectedFeatures: [
        'Cotton wool spots',
        'Venous beading',
        'IRMA lesions',
      ],
      recommendations: [
        'Urgent ophthalmology referral within 2 weeks',
        'Consider fluorescein angiography',
        'Intensive diabetes management',
      ],
      doctorNotes:
          'Patient shows significant NPDR changes. Refer to retina specialist.',
    ),
  ];

  List<ScanResult> getRecent({int limit = 10}) {
    final sorted = List<ScanResult>.from(_scans)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted.take(limit).toList();
  }

  ScanResult? getById(String id) {
    try {
      return _scans.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<ScanResult> analyzeScan({
    required String patientId,
    required String patientName,
    String? imagePath,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 8000));

    final severities = DrSeverity.values;
    final severity = severities[_random.nextInt(severities.length)];
    final confidence = 0.82 + _random.nextDouble() * 0.16;

    final result = ScanResult(
      id: _uuid.v4(),
      patientId: patientId,
      patientName: patientName,
      timestamp: DateTime.now(),
      severity: severity,
      confidence: confidence,
      detectedFeatures: _featuresForSeverity(severity),
      recommendations: _recommendationsForSeverity(severity),
      imagePath: imagePath,
    );

    _scans.insert(0, result);
    return result;
  }

  DashboardStats getDashboardStats() {
    final distribution = <DrSeverity, int>{};
    for (final s in DrSeverity.values) {
      distribution[s] = 0;
    }
    for (final scan in _scans) {
      distribution[scan.severity] = (distribution[scan.severity] ?? 0) + 1;
    }

    final today = DateTime.now();
    final todayScans = _scans
        .where((s) =>
            s.timestamp.year == today.year &&
            s.timestamp.month == today.month &&
            s.timestamp.day == today.day)
        .length;

    final highRisk = _scans
        .where((s) =>
            s.severity == DrSeverity.severe ||
            s.severity == DrSeverity.proliferative)
        .length;

    final avgConfidence = _scans.isEmpty
        ? 0.0
        : _scans.map((s) => s.confidence).reduce((a, b) => a + b) /
            _scans.length;

    return DashboardStats(
      totalScans: _scans.length + 247,
      todayScans: todayScans + 12,
      highRiskCases: highRisk + 8,
      averageConfidence: avgConfidence > 0 ? avgConfidence : 0.93,
      severityDistribution: distribution,
    );
  }

  List<String> _featuresForSeverity(DrSeverity severity) {
    return switch (severity) {
      DrSeverity.none => ['Normal vasculature', 'Clear optic disc'],
      DrSeverity.mild => ['Microaneurysms', 'Dot hemorrhages'],
      DrSeverity.moderate => [
          'Hemorrhages',
          'Hard exudates',
          'Cotton wool spots',
        ],
      DrSeverity.severe => [
          'Venous beading',
          'IRMA',
          'Multiple hemorrhages',
        ],
      DrSeverity.proliferative => [
          'Neovascularization',
          'Vitreous hemorrhage signs',
          'Fibrous proliferation',
        ],
    };
  }

  List<String> _recommendationsForSeverity(DrSeverity severity) {
    return switch (severity) {
      DrSeverity.none => [
          'Continue annual screening',
          'Maintain HbA1c below 7%',
        ],
      DrSeverity.mild => [
          'Follow-up in 6-12 months',
          'Optimize diabetes management',
        ],
      DrSeverity.moderate => [
          'Refer to ophthalmologist within 3-6 months',
          'Consider OCT imaging',
        ],
      DrSeverity.severe => [
          'Urgent referral within 2-4 weeks',
          'Pan-retinal photocoagulation evaluation',
        ],
      DrSeverity.proliferative => [
          'Immediate specialist referral',
          'Consider anti-VEGF therapy',
          'Surgical evaluation if needed',
        ],
    };
  }
}
