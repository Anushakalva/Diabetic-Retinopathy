import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/services/app_providers.dart';
import '../../../widgets/cards/feature_cards.dart';
import '../../../widgets/inputs/custom_inputs.dart';
import '../../../widgets/loaders/app_loaders.dart';

class PatientsScreen extends ConsumerWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(filteredPatientsProvider);
    final isWide = MediaQuery.sizeOf(context).width > 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            onPressed: () {},
            tooltip: 'Add Patient',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? AppSpacing.xl : AppSpacing.md,
        ),
        child: Column(
          children: [
            AppSearchBar(
              onChanged: (q) =>
                  ref.read(patientSearchProvider.notifier).state = q,
            ).animate().fadeIn().slideY(begin: -0.05, end: 0),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: patients.isEmpty
                  ? const EmptyStateWidget(
                      title: 'No patients found',
                      message:
                          'Try adjusting your search or add a new patient.',
                      icon: Icons.people_outline_rounded,
                    )
                  : ListView.separated(
                      itemCount: patients.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final patient = patients[index];
                        return PatientCard(
                          patient: patient,
                          onTap: () {
                            ref
                                .read(selectedPatientProvider.notifier)
                                .state = patient;
                            context.push('/camera');
                          },
                        ).animate(delay: (index * 60).ms);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
