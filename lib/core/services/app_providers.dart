import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';
import '../repositories/app_repositories.dart';

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserProfile?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  AuthNotifier(this._repo) : super(const AsyncValue.data(null));

  final AuthRepository _repo;

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repo.login(email: email, password: password),
    );
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(null);
  }

  bool get isAuthenticated => _repo.isAuthenticated;
}

final patientsProvider = Provider<List<Patient>>((ref) {
  return ref.watch(patientRepositoryProvider).getAll();
});

final patientSearchProvider = StateProvider<String>((ref) => '');

final filteredPatientsProvider = Provider<List<Patient>>((ref) {
  final query = ref.watch(patientSearchProvider);
  return ref.watch(patientRepositoryProvider).search(query);
});

final recentScansProvider = Provider<List<ScanResult>>((ref) {
  return ref.watch(scanRepositoryProvider).getRecent();
});

final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  return ref.watch(scanRepositoryProvider).getDashboardStats();
});

final selectedPatientProvider = StateProvider<Patient?>((ref) => null);

final analysisImagePathProvider = StateProvider<String?>((ref) => null);

final currentScanResultProvider = StateProvider<ScanResult?>((ref) => null);
