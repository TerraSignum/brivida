import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/job.dart';
import '../../../core/utils/debug_logger.dart';
import '../data/jobs_repo.dart';
import 'job_quote_service.dart';

// Provider for jobs list
final userJobsProvider = StreamProvider<List<Job>>((ref) {
  DebugLogger.debug('🔗 Creating userJobsProvider stream');
  final repo = ref.watch(jobsRepoProvider);
  return repo.getUserJobs();
});

// Provider for open jobs (pro feed)
final openJobsProvider = StreamProvider<List<Job>>((ref) {
  DebugLogger.debug('🔗 Creating openJobsProvider stream');
  final repo = ref.watch(jobsRepoProvider);
  return repo.getOpenJobs();
});

// Provider for visible jobs (assigned to current pro)
final visibleJobsProvider = StreamProvider<List<Job>>((ref) {
  DebugLogger.debug('🔗 Creating visibleJobsProvider stream');
  final repo = ref.watch(jobsRepoProvider);
  return repo.getVisibleJobs();
});

// Provider for specific job
final jobProvider = StreamProvider.family<Job?, String>((ref, jobId) {
  DebugLogger.debug('🔗 Creating jobProvider stream', {'jobId': jobId});
  final repo = ref.watch(jobsRepoProvider);
  return repo.getJobStream(jobId);
});

// Provider for private job details (address, entrance notes, etc.)
final jobPrivateProvider = StreamProvider.family<JobPrivate?, String>((
  ref,
  jobId,
) {
  DebugLogger.debug('🔗 Creating jobPrivateProvider stream', {'jobId': jobId});
  final repo = ref.watch(jobsRepoProvider);
  return repo.getJobPrivateStream(jobId);
});

// Controller for job operations
final jobsControllerProvider = Provider<JobsController>((ref) {
  DebugLogger.debug('🔗 Creating JobsController provider instance');
  final repo = ref.watch(jobsRepoProvider);
  final quoteService = ref.watch(jobQuoteServiceProvider);
  return JobsController(repo, quoteService);
});

class JobCreationResult {
  const JobCreationResult({required this.jobId, this.addressError});

  final String jobId;
  final Object? addressError;

  bool get addressSynchronized => addressError == null;
}

class JobsController {
  final JobsRepository _repo;
  final JobQuoteService _quoteService;

  JobsController(this._repo, this._quoteService) {
    DebugLogger.debug('🏗️ JobsController created', {
      'repoType': _repo.runtimeType.toString(),
    });
  }

  // Create a new job
  Future<JobCreationResult> createJob({
    required JobCategory category,
    Set<String> extras = const <String>{},
    bool materialProvidedByPro = false,
    bool isExpress = false,
    RecurrenceType recurrenceType = RecurrenceType.none,
    required DateTime start,
    String notes = '',
    String? addressCity,
    String? addressDistrict,
    String? addressHint,
    String? addressText,
    String? entranceNotes,
    bool hasPrivateLocation = false,
  }) async {
    DebugLogger.enter('JobsController.createJob', {
      'category': category.name,
      'extras': extras.toList(),
      'materialProvidedByPro': materialProvidedByPro,
      'isExpress': isExpress,
      'start': start.toIso8601String(),
      'hasNotes': notes.isNotEmpty,
      'hasAddressCity': addressCity?.isNotEmpty == true,
      'hasAddressDistrict': addressDistrict?.isNotEmpty == true,
      'hasAddressHint': addressHint?.isNotEmpty == true,
      'hasAddressText': addressText?.isNotEmpty == true,
      'hasEntranceNotes': entranceNotes?.isNotEmpty == true,
      'hasPrivateLocation': hasPrivateLocation,
    });
    DebugLogger.startTimer('createJob_controller');

    try {
      final quote = _quoteService.quote(
        JobQuoteInput(
          category: category,
          selectedExtras: extras,
          materialProvidedByPro: materialProvidedByPro,
          isExpress: isExpress,
        ),
      );

      DebugLogger.debug('🧮 Job quote calculated', {
        'totalHours': quote.totalHours,
        'totalCost': quote.totalCost,
        'baseHours': quote.baseHours,
        'extrasHours': quote.extrasHours,
        'services': quote.services,
      });

      final endTime = quote.calculateEnd(start);
      final recurrence = _mapRecurrence(recurrenceType);
      final sortedExtras = extras.toList()..sort();

      DebugLogger.debug('📝 Building job object for creation', {
        'category': category.name,
        'rooms': quote.defaultRooms,
        'sizeM2': quote.defaultSizeM2,
        'budget': quote.totalCost,
        'servicesCount': quote.services.length,
        'endTime': endTime.toIso8601String(),
      });

      final job = Job(
        customerUid: '', // Will be set by repository
        sizeM2: quote.defaultSizeM2,
        rooms: quote.defaultRooms,
        services: quote.services,
        window: JobWindow(start: start, end: endTime),
        budget: quote.totalCost,
        notes: notes,
        addressCity: addressCity,
        addressDistrict: addressDistrict,
        addressHint: addressHint,
        hasPrivateLocation: hasPrivateLocation,
        category: category,
        baseHours: quote.baseHours,
        extras: sortedExtras,
        extrasHours: quote.extrasHours,
        materialProvidedByPro: materialProvidedByPro,
        materialFeeEur: quote.materialFee,
        isExpress: isExpress,
        recurrence: recurrence,
        occurrenceIndex: 1,
        extraServices: sortedExtras,
        materialsRequired: !materialProvidedByPro,
      );

      DebugLogger.debug('✅ Job object built successfully', {
        'windowStart': job.window.start.toIso8601String(),
        'windowEnd': job.window.end.toIso8601String(),
        'hasServices': job.services.isNotEmpty,
        'hasLocation': job.hasPrivateLocation,
      });

      DebugLogger.debug('🔄 Delegating to repository createJob');
      final jobId = await _repo.createJob(job);
      Object? addressError;

      if (addressText != null && addressText.trim().isNotEmpty) {
        final trimmedAddress = addressText.trim();
        final trimmedEntranceNotes =
            entranceNotes != null && entranceNotes.trim().isNotEmpty
            ? entranceNotes.trim()
            : null;

        DebugLogger.debug('📍 Setting job address after creation', {
          'jobId': jobId,
          'hasEntranceNotes': trimmedEntranceNotes?.isNotEmpty == true,
        });

        try {
          await _repo.setJobAddress(
            jobId: jobId,
            addressText: trimmedAddress,
            entranceNotes: trimmedEntranceNotes,
          );
        } catch (error, addressStackTrace) {
          addressError = error;
          DebugLogger.error(
            '❌ Failed to sync job address after creation',
            error,
            addressStackTrace,
          );
        }
      }

      DebugLogger.debug('✅ Job created successfully via controller', {
        'jobId': jobId,
        'calculatedBudget': quote.totalCost,
        'servicesCount': quote.services.length,
        'addressSynced': addressError == null,
      });

      final duration = DebugLogger.stopTimer('createJob_controller');
      DebugLogger.performance('createJob_controller', duration!);
      DebugLogger.exit(
        'JobsController.createJob',
        'JobCreationResult(jobId: $jobId, addressSynced: ${addressError == null})',
      );

      return JobCreationResult(jobId: jobId, addressError: addressError);
    } catch (e, stackTrace) {
      DebugLogger.error('❌ Error in JobsController.createJob', e, stackTrace);
      DebugLogger.stopTimer('createJob_controller');
      DebugLogger.exit('JobsController.createJob', 'error');
      rethrow;
    }
  }

  Map<String, dynamic> _mapRecurrence(RecurrenceType type) {
    switch (type) {
      case RecurrenceType.weekly:
        return {'type': type.name, 'intervalDays': 7};
      case RecurrenceType.biweekly:
        return {'type': type.name, 'intervalDays': 14};
      case RecurrenceType.monthly:
        return {'type': type.name, 'intervalDays': 30};
      case RecurrenceType.none:
        return const {'type': 'none', 'intervalDays': 0};
    }
  }

  // Update job notes/budget
  Future<void> updateJob(
    String jobId, {
    String? notes,
    double? budget,
    List<String>? services,
    double? sizeM2,
    int? rooms,
  }) async {
    DebugLogger.enter('JobsController.updateJob', {
      'jobId': jobId,
      'hasNotes': notes != null,
      'hasBudget': budget != null,
      'hasServices': services != null,
      'hasSizeM2': sizeM2 != null,
      'hasRooms': rooms != null,
      'newBudget': budget,
      'newServicesCount': services?.length,
      'newSizeM2': sizeM2,
      'newRooms': rooms,
    });
    DebugLogger.startTimer('updateJob_controller');

    try {
      final updates = <String, dynamic>{};

      if (notes != null) {
        updates['notes'] = notes;
        DebugLogger.debug('📝 Adding notes to update', {
          'notesLength': notes.length,
          'hasContent': notes.isNotEmpty,
        });
      }

      if (budget != null) {
        updates['budget'] = budget;
        DebugLogger.debug('💰 Adding budget to update', {'newBudget': budget});
      }

      if (services != null) {
        updates['services'] = services;
        DebugLogger.debug('🛠️ Adding services to update', {
          'servicesCount': services.length,
          'services': services,
        });
      }

      if (sizeM2 != null) {
        updates['sizeM2'] = sizeM2;
        DebugLogger.debug('📐 Adding sizeM2 to update', {'newSizeM2': sizeM2});
      }

      if (rooms != null) {
        updates['rooms'] = rooms;
        DebugLogger.debug('🏠 Adding rooms to update', {'newRooms': rooms});
      }

      if (updates.isNotEmpty) {
        DebugLogger.debug('📊 Final update payload prepared', {
          'jobId': jobId,
          'fieldsToUpdate': updates.keys.toList(),
          'updateCount': updates.length,
        });

        DebugLogger.debug('🔄 Delegating to repository updateJob');
        await _repo.updateJob(jobId, updates);

        DebugLogger.debug('✅ Job updated successfully via controller', {
          'jobId': jobId,
          'updatedFields': updates.keys.toList(),
        });
      } else {
        DebugLogger.warning('⚠️ No valid updates provided for job', {
          'jobId': jobId,
        });
      }

      final duration = DebugLogger.stopTimer('updateJob_controller');
      DebugLogger.performance('updateJob_controller', duration!);
      DebugLogger.exit('JobsController.updateJob', 'success');
    } catch (e, stackTrace) {
      DebugLogger.error(
        '❌ Error in JobsController.updateJob: jobId=$jobId',
        e,
        stackTrace,
      );
      DebugLogger.stopTimer('updateJob_controller');
      DebugLogger.exit('JobsController.updateJob', 'error');
      rethrow;
    }
  }

  // Get single job
  Future<Job?> getJob(String jobId) async {
    DebugLogger.enter('JobsController.getJob', {'jobId': jobId});
    DebugLogger.startTimer('getJob_controller');

    try {
      DebugLogger.debug('🔄 Delegating to repository getJob', {'jobId': jobId});

      final job = await _repo.getJob(jobId);

      if (job != null) {
        DebugLogger.debug('✅ Job retrieved successfully via controller', {
          'jobId': job.id,
          'customerUid': job.customerUid,
          'status': job.status.name,
          'category': job.category.name,
          'budget': job.budget,
          'sizeM2': job.sizeM2,
          'rooms': job.rooms,
        });
      } else {
        DebugLogger.warning('⚠️ Job not found via controller', {
          'jobId': jobId,
        });
      }

      final duration = DebugLogger.stopTimer('getJob_controller');
      DebugLogger.performance('getJob_controller', duration!);
      DebugLogger.exit('JobsController.getJob', job?.id ?? 'null');

      return job;
    } catch (e, stackTrace) {
      DebugLogger.error(
        '❌ Error in JobsController.getJob: jobId=$jobId',
        e,
        stackTrace,
      );
      DebugLogger.stopTimer('getJob_controller');
      DebugLogger.exit('JobsController.getJob', 'error');
      rethrow;
    }
  }
}
